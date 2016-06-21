//
//  YXCourseFilterView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/21.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseFilterView.h"

@interface YXCourseFilterItem:NSObject
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSArray *filterArray;
@end
@implementation YXCourseFilterItem

@end
@interface YXCourseFilterView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *typeContainerView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *selectionTableView;
@property (nonatomic, strong) NSMutableArray *filterItemArray;
@end

@implementation YXCourseFilterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.filterItemArray = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
//    self.typeContainerView = [[UIView alloc]initWithFrame:self.bounds];
//    CGFloat lineHeight = 1/[UIScreen mainScreen].scale;
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.typeContainerView.bounds.size.height-lineHeight, self.typeContainerView.frame.size.width, lineHeight)];
//    line.backgroundColor = [UIColor blackColor];
//    [self.typeContainerView addSubview:line];
//    
//    self.maskView = [[UIView alloc]init];
//    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
//    [self.maskView addSubview:tap];
//    
//    self.selectionTableView = [[UITableView alloc]init];
//    self.selectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.selectionTableView.dataSource = self;
//    self.selectionTableView.delegate = self;
}

- (void)addFilters:(NSArray *)filters forKey:(NSString *)key{
    YXCourseFilterItem *item = [[YXCourseFilterItem alloc]init];
    item.typeName = key;
    item.filterArray = filters;
    [self.filterItemArray addObject:item];
}

@end
