//
//  YXDataStatisticsManger.m
//  TrainApp
//
//  Created by ZLL on 16/9/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXDataStatisticsManger.h"
#import "TalkingData.h"
@implementation YXDataStatisticsManger
+ (void)sessionStarted:(NSString *)appKey withChannelId:(NSString *)channelId{
    if([YXConfigManager sharedInstance].talkingDataReport.boolValue){
        [TalkingData sessionStarted:appKey withChannelId:channelId];
    }
}
+ (void)trackPage:(NSString *)pageName withStatus:(BOOL)status{
    if([YXConfigManager sharedInstance].talkingDataReport.boolValue){
        if (status) {
            [TalkingData trackPageBegin:pageName];
        }else{
            [TalkingData trackPageEnd:pageName];
        }
    }
}
+ (void)trackEvent:(NSString *)eventId
             label:(NSString *)eventLabel
        parameters:(NSDictionary *)parameters{
    if([YXConfigManager sharedInstance].talkingDataReport.boolValue){
        [TalkingData trackEvent:eventId label:eventLabel parameters:parameters];
    }
}
+ (void)setGlobalKV:(NSString *)key value:(id)value{
    if([YXConfigManager sharedInstance].talkingDataReport.boolValue){
        [TalkingData setGlobalKV:key value:value];
    }
}
+ (void)removeGlobalKV:(NSString *)key{
    if([YXConfigManager sharedInstance].talkingDataReport.boolValue){
        [TalkingData removeGlobalKV: key];
    }
}
@end
