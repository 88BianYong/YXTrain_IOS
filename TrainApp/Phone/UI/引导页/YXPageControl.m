//
//  YXPageControl.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/21.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXPageControl.h"

@implementation YXPageControl
- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 6;
        size.width = 6;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
    }
}
@end
