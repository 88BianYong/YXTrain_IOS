//
//  YXWebSocketManger.h
//  TrainApp
//
//  Created by 郑小龙 on 16/9/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger ,YXWebSocketMangerState){
    YXWebSocketMangerState_Normal = 1,//默认
    YXWebSocketMangerState_Hotspot = 2,//热点
    YXWebSocketMangerState_Dynamic = 3,//动态
};


@interface YXWebSocketManger : NSObject
@property (nonatomic ,assign) YXWebSocketMangerState state;
+ (instancetype)sharedInstance;
- (void)open;
- (void)close;
@end
