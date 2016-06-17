//
//  YXFilePhotoItem.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFilePhotoItem.h"

@implementation YXFilePhotoItem

- (instancetype)init{
    if (self = [super init]) {
        self.type = YXFileTypePhoto;
    }
    return self;
}

@end
