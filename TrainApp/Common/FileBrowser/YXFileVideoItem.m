//
//  YXFileVideoItem.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileVideoItem.h"

@implementation YXFileVideoItem

- (instancetype)init{
    if (self = [super init]) {
        self.type = YXFileTypeVideo;
    }
    return self;
}

@end
