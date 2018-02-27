//
//  CourseTestViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseTestViewController_17.h"
#import "CourseTestViewController_DeYang17.h"
#import "CourseTestViewController_Default17.h"

@interface CourseTestViewController_17 ()
@end

@implementation CourseTestViewController_17
+ (instancetype)alloc{
    if ([self class] == [CourseTestViewController_17 class]) {
        if ([LSTSharedInstance sharedInstance].trainManager.currentProject.special.integerValue == 1) {
             return [CourseTestViewController_DeYang17 alloc];
        }else {
            return [CourseTestViewController_Default17 alloc];
        }
    }
    return [super alloc];
}
@end
