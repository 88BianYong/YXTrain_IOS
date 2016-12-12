//
//  YXTestViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTestViewController.h"
@interface YXTestViewController ()
{
    UIView *headerView;
    CGFloat height;
}
@end

@implementation YXTestViewController
- (void)viewDidLoad {
    self.devTestActions = @[@"122",@"23",@"34",@"45"];
    [super viewDidLoad];
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    headerView.backgroundColor = [UIColor redColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 50);
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    height = 100.0f;
    
//    self.tableView.tableHeaderView = headerView;
    
}
- (void)test{
    height = 200.0f;
    headerView.frame = CGRectMake(0, 0, 320, 200.0f);
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    [UIView animateWithDuration:0.3 animations:^{

    }];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return height;
}
@end

