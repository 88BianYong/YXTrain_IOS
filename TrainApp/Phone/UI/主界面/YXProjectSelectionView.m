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
//@property (nonatomic, strong) NSMutableArray *projectArray;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) YXProjectSelectionBgView *selectionBgView;
@property (nonatomic, strong) UITableView *selectionTableView;
@end

@implementation YXProjectSelectionView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDynamicNotification:) name:kYXTrainCurrentProjectIndex object:nil];
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
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
    
    CGFloat w = 230;
    CGFloat x = ([UIScreen mainScreen].bounds.size.width-w)/2;
    CGFloat y = 57;
    self.selectionBgView = [[YXProjectSelectionBgView alloc]initWithFrame:CGRectMake(x, y, w, 0) triangleX:w/2];
    
    self.selectionTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.selectionTableView.backgroundColor = [UIColor clearColor];
    self.selectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectionTableView.rowHeight = UITableViewAutomaticDimension;
    self.selectionTableView.estimatedRowHeight = 44.0f;
    self.selectionTableView.dataSource = self;
    self.selectionTableView.delegate = self;
    self.selectionTableView.sectionFooterHeight = 0.1;
    [self.selectionTableView registerClass:[YXProjectSelectionCell class] forCellReuseIdentifier:@"YXProjectSelectionCell"];
}
- (void)setProjectGroup:(NSArray *)projectGroup {
    _projectGroup = projectGroup;
    if (projectGroup.count == 0) {
        return;
    }
    TrainListProjectGroup *group = projectGroup[self.currentIndexPath.section];
    NSArray *items = group.items;
    YXTrainListRequestItem_body_train *train = items[self.currentIndexPath.row];
    NSString *currentProject = train.name;
    [self setupTitleWithProject:currentProject];
}
- (void)setupTitleWithProject:(NSString *)projectName {
    CGSize size = [projectName sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGFloat titleWidth = MIN(ceilf(size.width), self.bounds.size.width-kImageWidth);
    self.titleLabel.frame = CGRectMake((self.bounds.size.width-titleWidth-kImageWidth)/2, 0, titleWidth, self.bounds.size.height);
    self.titleLabel.text = projectName;
    if (self.projectGroup.firstObject.items.count >1 || self.projectGroup.lastObject.items.count > 1 || self.projectGroup.count > 1 ) {
        self.rightImageView.hidden = NO;
        self.rightImageView.frame = CGRectMake(self.titleLabel.frame.origin.x+self.titleLabel.frame.size.width, (self.bounds.size.height-kImageWidth)/2, kImageWidth, kImageWidth);
        self.bgButton.userInteractionEnabled = YES;
    }
}
- (void)btnAction {
    [self showSelectionView];
}
- (void)tapAction {
    [self hideSelectionView];
}
#pragma mark - show & hide
- (void)showSelectionView {
    self.rightImageView.image = [UIImage imageNamed:@"切换标题模块的按钮-拷贝"];
    UIView *superview = self.window;
    [superview addSubview:self.maskView];
    CGFloat tableHeight;
    if (self.projectGroup.count == 2) {
        tableHeight = MIN((self.projectGroup.firstObject.items.count + self.projectGroup.lastObject.items.count)*45.0f + 45 * 2, 45 * 6 + 20);
    }else {
        tableHeight = MIN(([self.projectGroup.firstObject.items count])*45.0f + 45, 45 * 5 + 20);
    }
    CGRect rect = self.selectionBgView.frame;
    rect.size.height = tableHeight+8;
    self.selectionBgView.frame = rect;
    
    self.selectionTableView.frame = CGRectMake(0, 8, self.selectionBgView.bounds.size.width, tableHeight);
    [self.selectionBgView addSubview:self.selectionTableView];
    [superview addSubview:self.selectionBgView];
    [self.selectionTableView reloadData];
}

- (void)hideSelectionView {
    [self.selectionBgView removeFromSuperview];
    [self.maskView removeFromSuperview];
    self.rightImageView.image = [UIImage imageNamed:@"切换标题模块的按钮"];
}
- (void)currentProjectIndexPath:(NSIndexPath *)indexPath {
    BOOL isEqual = ([self.currentIndexPath compare:indexPath] == NSOrderedSame) ? YES : NO;
    if (isEqual) {
        [self hideSelectionView];
        return;
    }
    self.currentIndexPath = indexPath;
    NSArray *items = self.projectGroup[indexPath.section].items;
    YXTrainListRequestItem_body_train *train = items[indexPath.row];
    [self setupTitleWithProject:train.name];
    [self hideSelectionView];
    BLOCK_EXEC(self.projectChangeBlock,self.currentIndexPath);
    
}
- (void)receiveDynamicNotification:(NSNotification *)aNotification {
    NSString *pid = aNotification.object;
    __block NSInteger index = -1;
    [self.projectGroup enumerateObjectsUsingBlock:^(TrainListProjectGroup * _Nonnull group, NSUInteger idx, BOOL * _Nonnull stop) {
        [group.items enumerateObjectsUsingBlock:^(YXTrainListRequestItem_body_train * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.pid isEqualToString:pid]) {
                index = idx;
                [self currentProjectIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                *stop = YES;
            }
        }];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.projectGroup.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *items = self.projectGroup[section].items;
    return items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXProjectSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXProjectSelectionCell"];
    NSArray *items = self.projectGroup[indexPath.section].items;
    YXTrainListRequestItem_body_train *train = items[indexPath.row];
    cell.name = train.name;
    BOOL isEqual = ([self.currentIndexPath compare:indexPath] == NSOrderedSame) ? YES : NO;
    cell.isCurrent = isEqual;
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self currentProjectIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TrainListProjectGroup *group = self.projectGroup[section];
    return [self sectionHeaderViewWithTitle:group.name];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}
- (UIView *)sectionHeaderViewWithTitle:(NSString *)title {
    NSString *imageName = [NSString stringWithFormat:@"%@icon",title];
    UIView *sectionHeaderView = [[UIView alloc]init];
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"d0d3d6"];
    UIImageView *iconView = [[UIImageView  alloc]initWithImage:[UIImage imageNamed:imageName]];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor whiteColor];
    CGFloat titleLabelWidth = [title sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}].width;
    
    [sectionHeaderView addSubview:headerView];
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
    return sectionHeaderView;
}
@end
