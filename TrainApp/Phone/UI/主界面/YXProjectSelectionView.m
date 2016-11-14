//
//  YXProjectSelectionView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXProjectSelectionView.h"
#import "YXProjectSelectionBgView.h"
#import "YXProjectSelectionCell.h"

static const CGFloat kImageWidth = 30;

@interface YXProjectSelectionView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) YXProjectSelectionBgView *selectionBgView;
@property (nonatomic, strong) UITableView *selectionTableView;
@property (nonatomic, strong) UIView *sectionHeaderView;
@end

@implementation YXProjectSelectionView
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDynamicNotification:) name:kYXTrainCurrentProjectIndex object:nil];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.bgButton = [[UIButton alloc]initWithFrame:self.bounds];
    [self.bgButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    self.bgButton.userInteractionEnabled = NO;
    [self addSubview:self.bgButton];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.titleLabel];
    
    self.rightImageView = [[UIImageView alloc]init];
    self.rightImageView.image = [UIImage imageNamed:@"切换标题模块的按钮"];
    self.rightImageView.contentMode = UIViewContentModeCenter;
    self.rightImageView.hidden = YES;
    [self addSubview:self.rightImageView];
    
    self.maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.maskView addGestureRecognizer:tap];
    
    CGFloat w = 220;
    CGFloat x = ([UIScreen mainScreen].bounds.size.width-w)/2;
    CGFloat y = 57;
    self.selectionBgView = [[YXProjectSelectionBgView alloc]initWithFrame:CGRectMake(x, y, w, 0) triangleX:w/2];
    
    self.selectionTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.selectionTableView.backgroundColor = [UIColor clearColor];
    self.selectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectionTableView.rowHeight = 45;
    self.selectionTableView.dataSource = self;
    self.selectionTableView.delegate = self;
    self.selectionTableView.sectionFooterHeight = 0.1;
    [self.selectionTableView registerClass:[YXProjectSelectionCell class] forCellReuseIdentifier:@"YXProjectSelectionCell"];
    self.sectionHeaderView = [[UIView alloc]init];
}

- (void)setProjectArray:(NSArray *)projectArray{
    _projectArray = projectArray;
    if (projectArray.count == 0) {
        return;
    }
    //    self.currentIndex = 0;
    YXTrainListRequestItem_body_train *train = _projectArray[self.currentIndex];
    NSString *currentProject = train.name;
    [self setupTitleWithProject:currentProject];
}

- (void)setupTitleWithProject:(NSString *)pName{
    CGSize size = [pName sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGFloat titleWidth = MIN(ceilf(size.width), self.bounds.size.width-kImageWidth);
    self.titleLabel.frame = CGRectMake((self.bounds.size.width-titleWidth-kImageWidth)/2, 0, titleWidth, self.bounds.size.height);
    self.titleLabel.text = pName;
    if (self.projectArray.count > 1) {
        self.rightImageView.hidden = NO;
        self.rightImageView.frame = CGRectMake(self.titleLabel.frame.origin.x+self.titleLabel.frame.size.width, (self.bounds.size.height-kImageWidth)/2, kImageWidth, kImageWidth);
        self.bgButton.userInteractionEnabled = YES;
    }
}

- (void)btnAction{
    [self showSelectionView];
}

- (void)tapAction{
    [self hideSelectionView];
}

#pragma mark - show & hide
- (void)showSelectionView{
    self.rightImageView.image = [UIImage imageNamed:@"切换标题模块的按钮-拷贝"];
    UIView *superview = self.window;
    [superview addSubview:self.maskView];
    
    CGFloat tableHeight = MIN(self.projectArray.count*self.selectionTableView.rowHeight, 180 + 22);
    CGRect rect = self.selectionBgView.frame;
    rect.size.height = tableHeight+8;
    self.selectionBgView.frame = rect;
    
    self.selectionTableView.frame = CGRectMake(0, 8, self.selectionBgView.bounds.size.width, tableHeight);
    [self.selectionBgView addSubview:self.selectionTableView];
    [superview addSubview:self.selectionBgView];
    [self.selectionTableView reloadData];
}

- (void)hideSelectionView{
    [self.selectionBgView removeFromSuperview];
    [self.maskView removeFromSuperview];
    self.rightImageView.image = [UIImage imageNamed:@"切换标题模块的按钮"];
}

- (void)currentProjectIndex:(NSInteger)index{
    if (self.currentIndex == index) {
        [self hideSelectionView];
        return;
    }
    self.currentIndex = index;
    YXTrainListRequestItem_body_train *train = self.projectArray[self.currentIndex];
    [self setupTitleWithProject:train.name];
    [self hideSelectionView];
    BLOCK_EXEC(self.projectChangeBlock,self.currentIndex);
    
}
- (void)receiveDynamicNotification:(NSNotification *)aNotification{
    NSString *pid = aNotification.object;
    __block NSInteger index = -1;
    [self.projectArray enumerateObjectsUsingBlock:^(YXTrainListRequestItem_body_train * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.pid isEqualToString:pid]) {
            index = idx;
            [self currentProjectIndex:index];
            *stop = YES;
        }
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.projectArray.count;
    }
    else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXProjectSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXProjectSelectionCell"];
    YXTrainListRequestItem_body_train *train = self.projectArray[indexPath.row];
    cell.name = train.name;
    cell.isCurrent = (indexPath.row == self.currentIndex);
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self currentProjectIndex:indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        [self sectionHeaderViewWithTitle:@"在培项目" imageName:@"在培项目icon"];
    }else{
        [self sectionHeaderViewWithTitle:@"历史项目" imageName:@"历史项目icon"];
    }
    return self.sectionHeaderView;
}
- (void)sectionHeaderViewWithTitle:(NSString *)title imageName:(NSString *)imageName {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"d0d3d6"];
    
    UIImageView *iconView = [[UIImageView  alloc]initWithImage:[UIImage imageNamed:imageName]];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor whiteColor];
    CGFloat titleLabelWidth = [title sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}].width;
    
    [self.sectionHeaderView addSubview:headerView];
    [headerView addSubview:iconView];
    [headerView addSubview:titleLabel];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(30);
    }];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.centerX.equalTo(headerView.mas_centerX).offset(-(5 + titleLabelWidth * 0.5));
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(iconView);
        make.left.equalTo(iconView.mas_right).offset(5);
    }];
}
@end
