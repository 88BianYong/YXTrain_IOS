//
//  YXTOWebViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTOWebViewController.h"

@interface YXTOWebViewController ()
@property (nonatomic, strong) NSDate *beginDate;
@end

@implementation YXTOWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [b setTitle:@"返回" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:16];
    [b addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:b];
    
    self.beginDate = [NSDate date];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        self.beginDate = [NSDate date];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kRecordNeedUpdateNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        SAFE_CALL_OneParam(self.browseTimeDelegate, browseTimeUpdated, [[NSDate date] timeIntervalSinceDate:self.beginDate]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneButtonTapped:(UIBarButtonItem *)item
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    SAFE_CALL_OneParam(self.browseTimeDelegate, browseTimeUpdated, [[NSDate date] timeIntervalSinceDate:self.beginDate]);
    SAFE_CALL(self.exitDelegate, browserExit);
}

@end
