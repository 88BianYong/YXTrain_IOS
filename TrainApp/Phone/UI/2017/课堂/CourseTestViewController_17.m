//
//  CourseTestViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseTestViewController_17.h"
#import "CourseGetQuizesRequest_17.h"
#import "CourseTestCell_17.h"
#import "CourseTestHeaderView_17.h"
#import "CourseTestTableHeaderView_17.h"
@interface CourseTestViewController_17 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) CourseTestTableHeaderView_17 *headerView;

@property (nonatomic, strong) CourseGetQuizesRequest_17 *quizesRequest;
@property (nonatomic, strong) CourseGetQuizesRequest_17Item *quizesItem;
@end

@implementation CourseTestViewController_17
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
//    [self startLoading];
//    [self requestForGetQuizes];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - set

- (void)setQuizesItem:(CourseGetQuizesRequest_17Item *)quizesItem{
    _quizesItem = quizesItem;
    [self.tableView reloadData];
}

#pragma mark - setupUI
- (void)setupUI {
    self.navigationItem.title = @"";
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CourseTestHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"CourseTestHeaderView_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.tableView registerClass:[CourseTestCell_17 class] forCellReuseIdentifier:@"CourseTestCell_17"];
 
    self.headerView = [[CourseTestTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 71.0f)];
    self.tableView.tableHeaderView = self.headerView;
    self.errorView = [[YXErrorView alloc] init];
    WEAK_SELF
    self.errorView.retryBlock = ^{
        STRONG_SELF
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF

    };
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseTestCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTestCell_17" forIndexPath:indexPath];
//    cell.course = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f/[UIScreen mainScreen].scale;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CourseTestHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CourseTestHeaderView_17"];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}
#pragma mark - request
- (void)requestForGetQuizes {
    CourseGetQuizesRequest_17 *request = [[CourseGetQuizesRequest_17 alloc] init];
    [request startRequestWithRetClass:[CourseGetQuizesRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        
    }];
    self.quizesRequest = request;
}

@end
