//
//  YXFileAudioItem.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileAudioItem.h"

@implementation YXFileAudioItem

- (instancetype)init{
    if (self = [super init]) {
        self.type = YXFileTypeAudio;
    }
    return self;
}

@end
