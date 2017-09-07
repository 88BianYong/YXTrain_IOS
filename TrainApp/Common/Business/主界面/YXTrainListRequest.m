//
//  YXTrainListRequest.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTrainListRequest.h"

@implementation YXTrainListRequestItem_body_train
- (NSString<Optional> *)role {
    if (self.w.integerValue == 5) {
        return @"9";
    }
    if (_role) {
        return _role;
    }else {
        NSArray *array = [self.roles componentsSeparatedByString:@","];
        for (NSString *r in array) {
            if ([r isEqualToString:@"99"]) {
                return @"99";
            }
        }
        return @"9";
    }
}
- (NSString<Optional> *)isDoubel {
    if (self.w.integerValue == 5) {
        return @"0";
    }
    BOOL isMaster = NO;
    BOOL isStudent = NO;
    NSArray *array = [self.roles componentsSeparatedByString:@","];
    for (NSString *r in array) {
        if ([r isEqualToString:@"99"]) {
            isMaster = YES;
        }
        if ([r isEqualToString:@"9"]) {
            isStudent = YES;
        }
    }
    if (isStudent && isMaster) {
        return @"1";
    }else {
        return @"0";
    }
}

- (NSString<Optional> *)isOpenLayer {
    if (_isOpenLayer.boolValue && self.layerId.integerValue <= 0) {
        return @"1";
    }else {
        return @"0";
    }
}
- (NSString<Optional> *)isOpenTheme {
    if (_isOpenTheme.boolValue && self.themeId.integerValue <= 0) {
        return @"1";
    }else {
        return @"0";
    }
}
@end

@implementation YXTrainListRequestItem_body
//- (void)setTrained:(NSMutableArray<YXTrainListRequestItem_body_train,Optional> *)trained {
//    NSMutableArray<YXTrainListRequestItem_body_train> *mutableArray = [[NSMutableArray<YXTrainListRequestItem_body_train> alloc] init];
//    [trained enumerateObjectsUsingBlock:^(YXTrainListRequestItem_body_train *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.w.integerValue == 5) {
//            [mutableArray addObject:obj];
//        }
//    }];
//    if (mutableArray.count > 0) {
//        _trained = mutableArray;
//    }else {
//        _trained = nil;
//    }
//}
//- (void)setTraining:(NSMutableArray<YXTrainListRequestItem_body_train,Optional> *)training {
//    NSMutableArray<YXTrainListRequestItem_body_train> *mutableArray = [[NSMutableArray<YXTrainListRequestItem_body_train> alloc] init];
//    [training enumerateObjectsUsingBlock:^(YXTrainListRequestItem_body_train *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.w.integerValue == 5) {
//            [mutableArray addObject:obj];
//        }
//    }];
//    if (mutableArray.count > 0) {
//        _training = mutableArray;
//    }else {
//        _training = nil;
//    }
//}
@end

@implementation YXTrainListRequestItem

@end

@implementation YXTrainListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"guopei/trainlist"];
    }
    return self;
}
@end
