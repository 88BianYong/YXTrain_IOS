//
//  YXStartViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/25.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXStartViewController.h"

@interface YXStartViewController ()
{
    
}

@end

@implementation YXStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    UIImageView *imageView = [[UIImageView alloc] init];
    if (IS_IPHONE_4) {
        imageView.image = [UIImage imageNamed:@"640-960"];
    }
    else if (IS_IPHONE_5){
        imageView.image = [UIImage imageNamed:@"640-1136"];
    }else if (IS_IPHONE_6) {
        imageView.image = [UIImage imageNamed:@"750-1334"];
    }
    else if(IS_IPHONE_6P){
        imageView.image = [UIImage imageNamed:@"1242-2208"];
    }else if(IS_IPHONE_X){
        imageView.image = [UIImage imageNamed:@"iphonex"];
    }
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
