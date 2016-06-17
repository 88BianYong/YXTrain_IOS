//
//  YXFileItemBase.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileItemBase.h"

@implementation YXFileItemBase

- (instancetype)init{
    if (self = [super init]) {
        self.type = YXFileTypeUnknown;
    }
    return self;
}

@end
