//
//  YXDataStatisticsManger.h
//  TrainApp
//
//  Created by ZLL on 16/9/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXDataStatisticsManger : NSObject
+ (void)sessionStarted:(NSString *)appKey withChannelId:(NSString *)channelId;
+ (void)trackPage:(NSString *)pageName withStatus:(BOOL)status;//status 跟踪的状态(YES为开始跟踪 NO为结束跟踪)
+ (void)trackEvent:(NSString *)eventId
             label:(NSString *)eventLabel
        parameters:(NSDictionary *)parameters;
//添加全局的字段，这里的内容每次的自定义事都会带着，发到服务器。也就是说如果您的自定义事件中每一条都需要带同样的内容，如用户名称等，就可以添加进去;如果在之后，创建自定义的时候，有相同的key，则会覆盖，全局的里相同key的内容
+(void)setGlobalKV:(NSString*)key value:(id)value;
+(void)removeGlobalKV:(NSString*)key;
@end
