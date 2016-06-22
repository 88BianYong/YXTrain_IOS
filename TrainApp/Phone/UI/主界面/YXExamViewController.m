//
//  YXExamViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamViewController.h"
#import "YXTestPushViewController.h"

@interface YXExamViewController ()

@end

@implementation YXExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"考核";
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    lb.text = @"vc1";
    lb.textColor = [UIColor blackColor];
    [self.view addSubview:lb];
    
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 60, 40)];
    [b setTitle:@"Push" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnAction{
    YXFileVideoItem *item = [[YXFileVideoItem alloc]init];
    item.name = @"测试测试";
    item.url = @"http://mbtestsourse.teacherclub.com.cn/course/cf/xk/xxjs/xxjslpxkcdd/video/1/1.m3u8";
    [YXFileBrowseManager sharedManager].fileItem = item;
    [YXFileBrowseManager sharedManager].baseViewController = self;
    [[YXFileBrowseManager sharedManager]addFavorWithData:[NSObject new] completion:^{
        NSLog(@"Item favor success!");
    }];
    [[YXFileBrowseManager sharedManager] browseFile];
    return;
//    YXTestPushViewController *vc = [[YXTestPushViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
