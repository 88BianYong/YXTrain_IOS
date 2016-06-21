//
//  YXCourseViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/21.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseViewController.h"
#import "YXCourseFilterView.h"

@interface YXCourseViewController ()<YXCourseFilterViewDelegate>
@property (nonatomic, strong) NSArray *array1;
@property (nonatomic, strong) NSArray *array2;
@property (nonatomic, strong) NSArray *array3;
@property (nonatomic, strong) NSArray *array4;
@end

@implementation YXCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.array1 = @[@"全部",@"物理",@"数学",@"英语",@"化学",@"历史",@"生物",@"地理"];
    self.array2 = @[@"全部",@"小学",@"初中",@"高中"];
    self.array3 = @[@"全部",@"必修课",@"选修课"];
    self.array4 = @[@"全部",@"第一阶段",@"第二阶段",@"第三阶段",@"第四阶段",@"第五阶段",@"第N阶段"];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    YXCourseFilterView *filterView = [[YXCourseFilterView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    [filterView addFilters:self.array1 forKey:@"学科"];
    [filterView addFilters:self.array2 forKey:@"学段"];
    [filterView addFilters:self.array3 forKey:@"类型"];
    [filterView addFilters:self.array4 forKey:@"阶段"];
    filterView.delegate = self;
    [self.view addSubview:filterView];
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, filterView.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-filterView.bounds.size.height)];
    v.backgroundColor = [UIColor blueColor];
    [self.view addSubview:v];
}

#pragma mark - YXCourseFilterViewDelegate
- (void)filterChanged:(NSArray *)filterArray{
    NSString *subject = self.array1[((NSNumber *)filterArray[0]).integerValue];
    NSString *stage = self.array2[((NSNumber *)filterArray[1]).integerValue];
    NSString *type = self.array3[((NSNumber *)filterArray[2]).integerValue];
    NSString *phase = self.array4[((NSNumber *)filterArray[3]).integerValue];
    NSLog(@"Changed: 学科:%@，学段:%@，类型:%@，阶段:%@",subject,stage,type,phase);
}

@end
