//
//  YXWebSocketManger.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWebSocketManger.h"
#import "SRWebSocket.h"
#import "TrainRedPointManger.h"
@interface YXWebSocketManger()<SRWebSocketDelegate>
{
    SRWebSocket *_webSocket;
    NSTimer *_timer;
}
@end


@implementation YXWebSocketManger
- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];//返回前台检测网络
        [self setNetObserver];//注册网络检测
    }
    return self;
}

- (void)setNetObserver {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    WEAK_SELF
    reach.reachableBlock = ^(Reachability*reach)//有网重连
    {
        STRONG_SELF
        if (self ->_webSocket.readyState != SR_OPEN) {//连接关闭打开连接
            [self setupData];
        }
    };
    [reach startNotifier];
}

- (void)open{
    return;
    
//    if (self ->_webSocket.readyState != SR_OPEN) {
//        _state = YXWebSocketMangerState_Normal;
//        DDLogDebug(@"开始连接");
//        [self setupData];
//    }
}
- (void)close{
    [_webSocket close];
}

- (void)keepConnection{
    if (_webSocket.readyState == SR_OPEN) {//连接打开发送信息
        [_webSocket send:@"保持"];
    }
}

- (void)setupData{
    return;
    
//    _webSocket.delegate = nil;
//    [_webSocket close];
//    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[LSTSharedInstance sharedInstance].configManager.websocketServer]]];
//    _webSocket.delegate = self;
//    [_webSocket open];
}

- (void)setState:(YXWebSocketMangerState)state{
    _state = state;
    if (_webSocket.readyState == SR_OPEN) {//连接打开发送信息
        [_webSocket send:[self dictionaryToJsonData:@{@"type":[NSString stringWithFormat:@"%lu",(unsigned long)_state]}]];
        _state = YXWebSocketMangerState_Normal;
    }
    else{//连接关闭打开连接
        [self setupData];
    }
}
- (void)startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:9.0f target:self selector:@selector(setupData) userInfo:nil repeats:YES];

}

- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - format data

-(NSString *)dictionaryToJsonData:(NSDictionary *)object
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
- (void )dictionaryWithJsonString:(NSString *)jsonString {
    if (!isEmpty(jsonString)) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if ([dic[@"type"] integerValue] == 2) {//有热点动态发送通知
            [LSTSharedInstance sharedInstance].redPointManger.hotspotInteger = 1;
        }else if ([dic[@"type"] integerValue] == 3) {
            [LSTSharedInstance sharedInstance].redPointManger.dynamicInteger = [dic[@"num"] integerValue];
        }
    }
}
- (void)applicationDidBecomeActive:(NSNotification *)notification{
    if (_webSocket.readyState != SR_OPEN) {//连接关闭打开连接
       [self setupData];
    }
}


#pragma mark SRWebSocketDelegate
//连接成功
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    DDLogDebug(@"链接成功");
    NSDictionary *dic = @{@"type":@"1",@"token":[LSTSharedInstance sharedInstance].userManger.userModel.token?:@"",@"seqno":[LSTSharedInstance sharedInstance].configManager.deviceID?:@"1"};
    DDLogDebug(@"%@",dic);
   [_webSocket send:[self dictionaryToJsonData:dic]];
    if (_state != YXWebSocketMangerState_Normal) {//如有需要待发信息 重新发送
        [_webSocket send:[self dictionaryToJsonData:@{@"type":[NSString stringWithFormat:@"%lu",(unsigned long)_state]}]];
        _state = YXWebSocketMangerState_Normal;
    }
    [self stopTimer];
}

//连接失败
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    DDLogDebug(@"链接失败");
    _webSocket = nil;
    [self webSocketRetry];

}

//接收到新消息的处理
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    [self dictionaryWithJsonString:message];
    DDLogDebug(@"接收到新消息%@",message);
}

//连接关闭
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    DDLogDebug(@"连接关闭");
    _webSocket = nil;
    //[self webSocketRetry];
}
- (void)webSocketRetry{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if ([r isReachable]) {//链接失败有网10秒重试
        [self startTimer];
    }
}
@end
