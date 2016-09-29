//
//  YXDataStatisticsManger.h
//  TrainApp
//
//  Created by ZLL on 16/9/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXDataStatisticsManger : NSObject
/**
 *	@method	sessionStarted:withChannelId:
 *  初始化统计实例，请在application:didFinishLaunchingWithOptions:方法里调用
 *	@param 	appKey 	应用的唯一标识，统计后台注册得到
 @param 	channelId(可选) 	渠道名，如“app store”
 */
+ (void)sessionStarted:(NSString *)appKey withChannelId:(NSString *)channelId;
/**
 *  @method trackPage:withStatus:
 *  开始跟踪某一页面（可选），记录页面打开时间
 建议在viewWillAppear或者viewDidAppear方法里调用
 *	@param 	pageName 	页面名称（自定义）
 *  @param  status 跟踪的状态(YES为开始跟踪 NO为结束跟踪)
 */
+ (void)trackPage:(NSString *)pageName withStatus:(BOOL)status;
/**
 *	@method	trackEvent:label:parameters
 统计带二级参数的自定义事件，单次调用的参数数量不能超过10个
 *
 *	@param 	eventId 	事件名称（自定义）
 *	@param 	eventLabel 	事件标签（自定义）
 *	@param 	parameters 	事件参数 (key只支持NSString, value支持NSString和NSNumber)
 */
+ (void)trackEvent:(NSString *)eventId
             label:(NSString *)eventLabel
        parameters:(NSDictionary *)parameters;

///**
// *	@method	setGlobalKV:value:
// *  添加全局的字段，这里的内容会每次的自定义事都会带着，发到服务器。也就是说如果您的自定义事件中每一条都需要带同样的内容，如用户名称等，就可以添加进去
// *	@param 	key 	自定义事件的key，如果在之后，创建自定义的时候，有相同的key，则会覆盖，全局的里相同key的内容
// *  @param value  这里是NSObject类型，或者是NSString 或者NSNumber类型
// */
//+(void)setGlobalKV:(NSString*)key value:(id)value;
//
///**
// *	@method	removeGlobalKV:
// *  删除全局数据
// *	@param 	key 	自定义事件的key
// */
//+(void)removeGlobalKV:(NSString*)key;


@end
