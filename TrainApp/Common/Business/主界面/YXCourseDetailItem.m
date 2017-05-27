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
@implementation YXCourseDetailItem_mti

@end
@implementation YXCourseDetailItem_score
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"self": @"sself",
                                                       @"count": @"ccount"}];
}
@end
@implementation YXCourseDetailItem_chapter

@end

@implementation YXCourseDetailItem
- (YXCourseDetailItem_chapter_fragment *)willPlayVideoSeek:(NSInteger)integer {
    if (self.playIndexPath == nil) {
        self.playIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }else {
        YXCourseDetailItem_chapter *chapter = self.chapters[self.playIndexPath.section];
        NSInteger row = self.playIndexPath.row;
        NSInteger section = self.playIndexPath.section;
        if (row + 1 < chapter.fragments.count) {
            row = row + 1;
        }else {
            row = 0;
            section = section + 1;
        }
        if (section >= self.chapters.count){
            self.playIndexPath = nil;
            return nil;
        }
        self.playIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    }
    NSInteger currentInterger = 0;
    for (NSInteger c = self.playIndexPath.section; c < self.chapters.count; c ++) {
        YXCourseDetailItem_chapter *chapter = self.chapters[c];
        NSInteger row = c == self.playIndexPath.section ? self.playIndexPath.row : 0;
        for (NSInteger f = row;  f < chapter.fragments.count ; f ++) {
            YXCourseDetailItem_chapter_fragment *fragment = chapter.fragments[f];
            if ([fragment.type isEqualToString:@"0"] && currentInterger >= integer) {
                self.playIndexPath = [NSIndexPath indexPathForRow:f inSection:c];
                return fragment;
            }
            currentInterger ++;
        }
    }
    self.playIndexPath = nil;
    return nil;
}
@end
