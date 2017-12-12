//
//  MasterHomeworkSetChooseView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkSetChooseView_17.h"
#import "YXProjectSelectionBgView.h"
static const CGFloat kImageWidth = 30;

@interface MasterHomeworkSetChooseView_17 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) NSInteger chooseInteger;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXProjectSelectionBgView *selectionBgView;
@end
@implementation MasterHomeworkSetChooseView_17
- (void)dealloc {
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self setupUI];
    }
    return self;
}
#pragma mark - set
- (void)setChooseInteger:(NSInteger)chooseInteger {
    if (chooseInteger == _chooseInteger) {
        [self hideSelectionView];
        return;
    }
    _chooseInteger = chooseInteger;
    [self setupTitleWithHomework:self.homeworkArray[_chooseInteger].title];
    [self hideSelectionView];
    BLOCK_EXEC(self.masterHomeworkSetChooseBlock,self.chooseInteger);
}
- (void)setHomeworkArray:(NSArray<MasterHomeworkSetListDetailItem_Body_Homework *> *)homeworkArray {
    _homeworkArray = homeworkArray;
    [self setupTitleWithHomework:self.homeworkArray[_chooseInteger].title];
}
#pragma mark - setupUI
- (void)setupUI {
    self.bgButton = [[UIButton alloc]initWithFrame:self.bounds];
    self.bgButton.userInteractionEnabled = NO;
    WEAK_SELF
    [[self.bgButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self showSelectionView];
    }];
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
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [[gestureRecognizer rac_gestureSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self hideSelectionView];
    }];
     [self.maskView addGestureRecognizer:gestureRecognizer];
    CGFloat w = 240;
    CGFloat x = ([UIScreen mainScreen].bounds.size.width-w)/2;
    CGFloat y = 147;
    self.selectionBgView = [[YXProjectSelectionBgView alloc]initWithFrame:CGRectMake(x, y, w, 0) triangleX:w/2];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithHexString:@"eceef2"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15.0, 0, 15.0f);
    self.tableView.rowHeight = 45.0f;
    self.tableView.layer.cornerRadius = YXTrainCornerRadii;
    self.tableView.clipsToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"staticString"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
}
- (void)setupTitleWithHomework:(NSString *)projectName {
    CGSize size = [projectName sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGFloat titleWidth = MIN(ceilf(size.width), self.bounds.size.width-kImageWidth);
    self.titleLabel.frame = CGRectMake((self.bounds.size.width-titleWidth-kImageWidth)/2, 0, titleWidth, self.bounds.size.height);
    self.titleLabel.text = projectName;
    if (self.homeworkArray.count > 0 ) {
        self.rightImageView.hidden = NO;
        self.rightImageView.frame = CGRectMake(self.titleLabel.frame.origin.x+self.titleLabel.frame.size.width, (self.bounds.size.height-kImageWidth)/2, kImageWidth, kImageWidth);
        self.bgButton.userInteractionEnabled = YES;
    }
}
#pragma mark - show & hide
- (void)showSelectionView {
    self.rightImageView.image = [UIImage imageNamed:@"切换标题模块的按钮-拷贝"];
    UIView *superview = self.window;
    [superview addSubview:self.maskView];
    CGFloat tableHeight;
    tableHeight = MIN((self.homeworkArray.count)*45.0f, 45 * 5 + 20);
    CGRect rect = self.selectionBgView.frame;
    rect.size.height = tableHeight+8;
    self.selectionBgView.frame = rect;
    self.tableView.frame = CGRectMake(0, 8, self.selectionBgView.bounds.size.width, tableHeight);
    [self.selectionBgView addSubview:self.tableView];
    [superview addSubview:self.selectionBgView];
    [self.tableView reloadData];
}

- (void)hideSelectionView {
    [self.selectionBgView removeFromSuperview];
    [self.maskView removeFromSuperview];
    self.rightImageView.image = [UIImage imageNamed:@"切换标题模块的按钮"];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeworkArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"staticString"];
    cell.textLabel.text = self.homeworkArray[indexPath.row].title;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    if (indexPath.row == self.chooseInteger) {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    }else {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"334466"];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.chooseInteger = indexPath.row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXSectionHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}
- (void)removeFromSuperview {
    [self hideSelectionView];
    [super removeFromSuperview];
}
- (void)chooseHomeworkDetail:(NSInteger)interger {
    self.chooseInteger = interger;
}
@end
