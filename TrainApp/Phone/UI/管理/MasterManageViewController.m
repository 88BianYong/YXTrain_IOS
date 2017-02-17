//
//  MasterManageViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageViewController.h"
#import "MasterManageCell.h"
@interface MasterManageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MasterManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[MasterManageCell class] forCellReuseIdentifier:@"MasterManageCell"];

}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MasterManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterManageCell"];
    [cell reloadWithText:@"学员学情" imageName:@"学员学情icon"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *string = @"StudentsLearnController";
    UIViewController *VC = [[NSClassFromString(string) alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}
@end
