//
//  YXAboutViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXAboutViewController.h"
#import "YXAboutHeaderView.h"
#import "YXAboutCell.h"
@interface YXAboutViewController ()
<
  UITableViewDelegate,
  UITableViewDataSource
>
{
    UITableView *_tableView; 
}

@end

@implementation YXAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Setting
- (void)setupUI{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    [_tableView registerClass:[YXAboutCell class] forCellReuseIdentifier:@"YXAboutCell"];
    [self.view addSubview:_tableView];
    
    YXAboutHeaderView *headerView = [[YXAboutHeaderView alloc] init];
    headerView.frame = CGRectMake(0, 0, 320, 300);
    _tableView.tableHeaderView = headerView;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size
                                                                  .width, 100.f)];
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.frame = CGRectMake(0, 0, 150, 50.0f);
    footerButton.center = footerView.center;
    footerButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    footerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerButton setTitle:@"使用条款和隐私策略" forState:UIControlStateNormal];
    [footerButton setTitleColor:[UIColor colorWithHexString:@"41c694"] forState:UIControlStateNormal];
    [footerView addSubview:footerButton];
    _tableView.tableFooterView = footerView;
    
}

#pragma mark - tableView dataSorce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXAboutCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
        cell.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.titleLabel.text = @"官方微信  lstong910";
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    else{
        NSString *phoneString = @"客服电话  400-7799-010";
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:phoneString];
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"]} range:NSMakeRange(0, 4)];
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"41c694"]} range:NSMakeRange(5, 13)];
        cell.titleLabel.attributedText = attributeString;
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}
#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}


@end
