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
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation YXProjectSelectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
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
    self.rightImageView.image = [UIImage imageNamed:@"下拉三角灰"];
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
    
    self.selectionTableView = [[UITableView alloc]init];
    self.selectionTableView.backgroundColor = [UIColor clearColor];
    self.selectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectionTableView.rowHeight = 45;
    self.selectionTableView.dataSource = self;
    self.selectionTableView.delegate = self;
    [self.selectionTableView registerClass:[YXProjectSelectionCell class] forCellReuseIdentifier:@"YXProjectSelectionCell"];
}

- (void)setProjectArray:(NSArray *)projectArray{
    _projectArray = projectArray;
    if (projectArray.count == 0) {
        return;
    }
    self.currentIndex = 0;
    NSString *currentProject = projectArray[self.currentIndex];
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
    self.rightImageView.image = [UIImage imageNamed:@"下拉三角蓝"];
    UIView *superview = self.window;
    [superview addSubview:self.maskView];
    
    CGFloat tableHeight = MIN(self.projectArray.count*self.selectionTableView.rowHeight, 180);
    CGRect rect = self.selectionBgView.frame;
    rect.size.height = tableHeight+7;
    self.selectionBgView.frame = rect;
    
    self.selectionTableView.frame = CGRectMake(0, 7, self.selectionBgView.bounds.size.width, tableHeight);
    [self.selectionBgView addSubview:self.selectionTableView];
    [superview addSubview:self.selectionBgView];
    [self.selectionTableView reloadData];
}

- (void)hideSelectionView{
    [self.selectionBgView removeFromSuperview];
    [self.maskView removeFromSuperview];
    self.rightImageView.image = [UIImage imageNamed:@"下拉三角灰"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.projectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXProjectSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXProjectSelectionCell"];
    cell.name = self.projectArray[indexPath.row];
    cell.isCurrent = (indexPath.row == self.currentIndex);
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.currentIndex == indexPath.row) {
        [self hideSelectionView];
        return;
    }
    self.currentIndex = indexPath.row;
    [self setupTitleWithProject:self.projectArray[self.currentIndex]];
    [self hideSelectionView];
    BLOCK_EXEC(self.projectChangeBlock,self.currentIndex);
}

@end
