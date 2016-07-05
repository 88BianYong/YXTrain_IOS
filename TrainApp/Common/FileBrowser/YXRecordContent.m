//
//  YXRecordContent.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXRecordContent.h"

@implementation YXRecordContent_k

@end

@implementation YXRecordContent
+ (YXRecordContent *)contentFromCourseDetailItem:(YXCourseDetailItem *)courseItem{
    YXRecordContent *content = [[YXRecordContent alloc] init];
    content.ac = courseItem.ac;
    content.tc = courseItem.tc;
    content.rc = courseItem.rc;
    content.t = courseItem.t;
    content.c = courseItem.c;
    content.p = courseItem.p;
    content.i = courseItem.i;
    content.md5 = courseItem.md5;
    content.mxt = courseItem.mxt;
    
    NSMutableArray *kArray = [NSMutableArray array];
    for (YXCourseDetailItem_chapter *cp in courseItem.chapters) {
        YXRecordContent_k *ck = [[YXRecordContent_k alloc] init];
        ck.status = @"false";
        
        NSMutableArray *pdArray = [NSMutableArray array];
        for (YXCourseDetailItem_chapter_fragment *fm in cp.fragments) {
            NSString *s = [NSString stringWithFormat:@"%@_%@", fm.record, fm.duration];
            [pdArray addObject:s];
        }
        ck.pd = [NSArray arrayWithArray:pdArray];
        
        [kArray addObject:ck];
    }
    content.k = (NSArray<Optional, YXRecordContent_k> *)[NSArray arrayWithArray:kArray];
    return content;
}
@end
