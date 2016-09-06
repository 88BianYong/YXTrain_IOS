//
//  YXRotateListRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXRotateListRequest.h"

@implementation YXRotateListRequestItem_Rotates
- (BOOL)isFinished
{
    if ([self.status integerValue] == 0) {
        return YES;
    }
    return NO;
}

- (NSString<Optional> *)resurl
{
    if ([_resurl hasPrefix:@"www"]) {
        _resurl = [NSString stringWithFormat:@"http://%@", _resurl];
    }
    return _resurl;
}

@end

@implementation YXRotateListRequestItem

@end

@implementation YXRotateListRequest

@end
