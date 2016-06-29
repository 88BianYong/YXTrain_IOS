//
//  YXCourseDetailViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseDetailViewController.h"
#import "YXCourseDetailRequest.h"
#import "YXModuleDetailRequest.h"
#import "YXCourseDetailCell.h"
#import "YXCourseDetailHeaderView.h"

@interface YXCourseDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXModuleDetailRequest *moduleDetailRequest;
@property (nonatomic, strong) YXCourseDetailRequest *courseDetailRequest;
@property (nonatomic, strong) YXCourseDetailItem *courseItem;
@end

@implementation YXCourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.course.course_title;
    [self setupUI];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"eceef2"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    self.tableView.rowHeight = 70;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(6);
    }];
    [self.tableView registerClass:[YXCourseDetailCell class] forCellReuseIdentifier:@"YXCourseDetailCell"];
    [self.tableView registerClass:[YXCourseDetailHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXCourseDetailHeaderView"];
}

- (void)getData{
    if (self.course.is_selected.integerValue == 0) {
        [self.courseDetailRequest stopRequest];
        self.courseDetailRequest = [[YXCourseDetailRequest alloc]init];
        self.courseDetailRequest.cid = self.course.courses_id;
        self.courseDetailRequest.stageid = self.course.module_id;
//        self.courseDetailRequest.pid =
        [self startLoading];
        WEAK_SELF
        [self.courseDetailRequest startRequestWithRetClass:[YXCourseDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self stopLoading];
            if (error) {
                [self showToast:error.localizedDescription];
                return;
            }
            YXCourseDetailRequestItem *item = (YXCourseDetailRequestItem *)retItem;
            [self dealWithCourseItem:item.body];
        }];
    }else{
        [self.moduleDetailRequest stopRequest];
        self.moduleDetailRequest = [[YXModuleDetailRequest alloc]init];
        self.moduleDetailRequest.cid = self.course.courses_id;
        [self startLoading];
        WEAK_SELF
        [self.moduleDetailRequest startRequestWithRetClass:[YXModuleDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self stopLoading];
            if (error) {
                [self showToast:error.localizedDescription];
                return;
            }
            YXModuleDetailRequestItem *item = (YXModuleDetailRequestItem *)retItem;
            [self dealWithCourseItem:item.body];
        }];
    }
}

- (void)dealWithCourseItem:(YXCourseDetailItem *)courseItem{
    self.courseItem = courseItem;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.courseItem.chapters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YXCourseDetailItem_chapter *chapter = self.courseItem.chapters[section];
    return chapter.fragments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXCourseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXCourseDetailCell"];
    YXCourseDetailItem_chapter *chapter = self.courseItem.chapters[indexPath.section];
    cell.data = chapter.fragments[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YXCourseDetailHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXCourseDetailHeaderView"];
    YXCourseDetailItem_chapter *chapter = self.courseItem.chapters[section];
    header.title = chapter.chapter_name;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
