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
    
    self.tableView.tableHeaderView = headerView;
    
}
- (void)test{
    [UIView animateWithDuration:0.3 animations:^{
        headerView.frame = CGRectMake(0, 0, 320, 200.0f);
        self.tableView.tableHeaderView = headerView;
        
    }];
    
}
@end
