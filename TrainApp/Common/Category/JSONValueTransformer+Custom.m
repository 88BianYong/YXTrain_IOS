//
//  JSONValueTransformer+Custom.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/4/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "JSONValueTransformer+Custom.h"

@implementation JSONValueTransformer (Custom)
- (NSString *)yx_NSStringFromNSNumber:(NSNumber *)number {
    NSString *doubleString  = [NSString stringWithFormat:@"%lf", number.doubleValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}
@end
