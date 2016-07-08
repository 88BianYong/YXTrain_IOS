//
//  YXMineViewController.m
//  TrainApp
//
//  Created by 李五民 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXMineViewController.h"
#import "YXUserImageTableViewCell.h"
#import "YXUserInfoTableViewCell.h"
#import "YXSchoolSearchViewController.h"
@interface YXMineViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YXMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)setupUI {
    self.title = @"个人信息";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
    [self.tableView registerClass:[YXUserImageTableViewCell class] forCellReuseIdentifier:@"YXUserImageTableViewCell"];
    [self.tableView registerClass:[YXUserInfoTableViewCell class] forCellReuseIdentifier:@"YXUserInfoTableViewCell"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark --TabelViewDelegate, TabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YXUserImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXUserImageTableViewCell"];
        cell.userImageTap = ^(){
        
        };
        return cell;
    } else {
        YXUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXUserInfoTableViewCell"];
        if (indexPath.section == 1) {
            [cell configUIwithTitle:@"姓名" content:@"哈哈哈哈"];
        }
        if (indexPath.section == 2) {
            [cell configUIwithTitle:@"姓名" content:@"哈哈哈哈"];
        }
        if (indexPath.section == 3) {
            [cell configUIwithTitle:@"姓名" content:@"哈哈哈哈"];
        }
        if (indexPath.section == 4) {
            [cell configUIwithTitle:@"姓名" content:@"哈哈哈哈"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 190;
    } else {
        return 43;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXSchoolSearchViewController *searchVC = [[YXSchoolSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
@end
