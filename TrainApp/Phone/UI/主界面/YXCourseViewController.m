//
//  YXCourseViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/21.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseViewController.h"
#import "YXCourseFilterView.h"
#import "YXCourseListFetcher.h"
#import "YXCourseListCell.h"
#import "YXCourseDetailViewController.h"
#import "YXCourseRecordViewController.h"

@interface YXCourseViewController ()<YXCourseFilterViewDelegate>
@property (nonatomic, strong) YXCourseFilterView *filterView;
@property (nonatomic, strong) YXCourseListFilterModel *filterModel;
@end

@implementation YXCourseViewController

- (void)viewDidLoad {
    YXCourseListFetcher *fetcher = [[YXCourseListFetcher alloc]init];
    WEAK_SELF
    fetcher.filterBlock = ^(YXCourseListFilterModel *model){
        STRONG_SELF
        if (self.filterModel) {
            return;
        }
        [self dealWithFilterModel:model];
    };
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"课程列表";
    [self setupRightWithTitle:@"看课记录"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.tableView registerClass:[YXCourseListCell class] forCellReuseIdentifier:@"YXCourseListCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealWithFilterModel:(YXCourseListFilterModel *)model{
    self.filterModel = model;
    YXCourseFilterView *filterView = [[YXCourseFilterView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    for (YXCourseFilterGroup *group in model.groupArray) {
        NSMutableArray *array = [NSMutableArray array];
        for (YXCourseFilter *filter in group.filterArray) {
            [array addObject:filter.name];
        }
        [filterView addFilters:array forKey:group.name];
    }
    filterView.delegate = self;
    [self.view addSubview:filterView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(44);
    }];
}

- (void)naviRightAction{
    YXCourseRecordViewController *vc = [[YXCourseRecordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXCourseListCell"];
    cell.course = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXCourseListRequestItem_body_module_course *course = self.dataArray[indexPath.row];
    YXCourseDetailViewController *vc = [[YXCourseDetailViewController alloc]init];
    vc.course = course;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - YXCourseFilterViewDelegate
- (void)filterChanged:(NSArray *)filterArray{
    // 学科
    NSNumber *num0 = filterArray[0];
    YXCourseFilterGroup *group0 = self.filterModel.groupArray[0];
    YXCourseFilter *studyItem = group0.filterArray[num0.integerValue];
    // 学段
    NSNumber *num1 = filterArray[1];
    YXCourseFilterGroup *group1 = self.filterModel.groupArray[1];
    YXCourseFilter *segmentItem = group1.filterArray[num1.integerValue];
    // 类型
    NSNumber *num2 = filterArray[2];
    YXCourseFilterGroup *group2 = self.filterModel.groupArray[2];
    YXCourseFilter *typeItem = group2.filterArray[num2.integerValue];
    // 阶段
    NSNumber *num3 = filterArray[3];
    YXCourseFilterGroup *group3 = self.filterModel.groupArray[3];
    YXCourseFilter *stageItem = group3.filterArray[num3.integerValue];
    
    NSLog(@"Changed: 学科:%@，学段:%@，类型:%@，阶段:%@",studyItem.name,segmentItem.name,typeItem.name,stageItem.name);
    
    YXCourseListFetcher *fetcher = (YXCourseListFetcher *)self.dataFetcher;
    fetcher.studyid = studyItem.filterID;
    fetcher.segid = segmentItem.filterID;
    fetcher.type = typeItem.filterID;
    fetcher.stageid = stageItem.filterID;
    [self firstPageFetch];
}

@end
