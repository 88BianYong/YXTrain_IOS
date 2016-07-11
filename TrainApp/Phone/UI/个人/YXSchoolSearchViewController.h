//
//  YXSchoolSearchViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 16/7/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
@class YXSchool;
@interface YXSchoolSearchViewController : YXBaseViewController
@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) void(^addSchoolNameSuccessBlock)(NSString *);
@end
