//
//  CourseTestHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseGetQuizesRequest_17.h"
@interface CourseTestHeaderView_17 : UITableViewHeaderFooterView
@property (nonatomic, assign) NSInteger numberInteger;
@property (nonatomic, strong) CourseGetQuizesRequest_17Item_Result_Questions *question;
@end
