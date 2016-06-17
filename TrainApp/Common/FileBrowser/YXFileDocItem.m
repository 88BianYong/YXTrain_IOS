//
//  YXFileDocItem.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileDocItem.h"

@implementation YXFileDocItem

- (instancetype)init{
    if (self = [super init]) {
        self.type = YXFileTypeDoc;
    }
    return self;
}

@end
