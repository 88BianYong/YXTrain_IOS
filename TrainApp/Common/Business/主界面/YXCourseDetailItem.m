//
//  YXCourseDetailItem.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseDetailItem.h"

@implementation YXCourseDetailItem_chapter_fragment
+ (JSONKeyMapper *)keyMapper
{
    // 这里应该是个bug，先client搞定吧
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"chapter_name": @"fragment_name"}];
}
@end

@implementation YXCourseDetailItem_chapter

@end

@implementation YXCourseDetailItem

@end
