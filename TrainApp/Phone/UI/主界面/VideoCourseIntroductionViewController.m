//
//  VideoCourseIntroductionViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseIntroductionViewController.h"

@interface VideoCourseIntroductionViewController ()

@end

@implementation VideoCourseIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI {
- (void)setCourseItem:(YXCourseDetailItem *)courseItem {
    _courseItem = courseItem;
}
@end
