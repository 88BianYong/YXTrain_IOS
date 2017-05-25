//
//  VideoCourseIntroductionViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseIntroductionViewController.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "VideoCourseIntroductionCell.h"
#import "VideoCourseIntroductionHeaderView.h"
@interface VideoCourseIntroductionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@end

@implementation VideoCourseIntroductionViewController

- (void)viewDidLoad {
    [self setupModel];
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - setupUI 
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 44.0f;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[VideoCourseIntroductionCell class] forCellReuseIdentifier:@"VideoCourseIntroductionCell"];
    [self.tableView registerClass:[VideoCourseIntroductionHeaderView class] forHeaderFooterViewReuseIdentifier:@"VideoCourseIntroductionHeaderView"];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)setupModel {
    self.courseItem = [[YXCourseDetailItem alloc] init];
    YXCourseDetailItem_score *score = [[YXCourseDetailItem_score alloc] init];
    score.avr = @"4";
    score.sself = @"受打击非法积分卡积分;刻录机啊;的发了空间啊;考虑到附近;啊路口见对方;垃圾费;逻辑阿萨德;看了房间;阿卡丽束带结发;垃圾的说法;卡戴珊;看风景撒;发";
    self.courseItem.score = score;
    
    
    YXCourseDetailItem_mti *mti1 = [[YXCourseDetailItem_mti alloc] init];
    mti1.ctn = @"哇哈哈";
    mti1.cti = @"司法局发空间发减肥啦立刻减肥辣椒粉咖啡机案件发;会计法;卡积分;啊;附近爱空间的发酵打发打发噶打飞机行更多";
    YXCourseDetailItem_mti *mti2 = [[YXCourseDetailItem_mti alloc] init];
    mti2.ctn = @"";
    mti2.cti = @"山三名司法局发空间发减肥啦立刻减肥辣椒粉咖啡机案件发;会计法;卡积分;啊;附近爱空间的发酵打发打发噶打飞机行更多";
    self.courseItem.mti = @[mti1,mti2];
}
- (void)setCourseItem:(YXCourseDetailItem *)courseItem {
    _courseItem = courseItem;
}
#pragma mark - UITableViewDelegate 
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VideoCourseIntroductionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"VideoCourseIntroductionHeaderView"];
    headerView.score = self.courseItem.score;
    return headerView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.courseItem) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseItem.mti.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCourseIntroductionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCourseIntroductionCell" forIndexPath:indexPath];
    cell.mti = self.courseItem.mti[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
}

@end
