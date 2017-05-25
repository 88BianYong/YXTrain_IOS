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
    //[self setupModel];
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
- (void)setCourseItem:(YXCourseDetailItem *)courseItem {
    _courseItem = courseItem;
    [self.tableView reloadData];
}
#pragma mark - UITableViewDelegate 
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VideoCourseIntroductionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"VideoCourseIntroductionHeaderView"];
    headerView.score = self.courseItem.score;
    headerView.titleString = self.title;
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
