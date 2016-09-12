//
//  YXWebSocketManger.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWebSocketManger.h"
#import "SRWebSocket.h"
@interface YXWebSocketManger()<SRWebSocketDelegate>
{
    SRWebSocket *_webSocket;
}
@end


@implementation YXWebSocketManger
- (instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (instancetype)sharedInstance{
    static YXWebSocketManger *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)open{
    _state = YXWebSocketMangerState_Normal;
    [self setupData];
//    _timer = [NSTimer scheduledTimerWithTimeInterval:9.0f target:self selector:@selector(keepConnection) userInfo:nil repeats:YES];
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
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://mobile.yanxiu.com/test/api/websocket"]]];
    _webSocket.delegate = self;
    [_webSocket open];
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
        if ([dic[@"type"] isEqualToString:@"2"] || [dic[@"type"] isEqualToString:@"3"]) {//有热点动态发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:YXTrainWebSocketReceiveMessage object:dic[@"type"]];
        }else{
            

        }
    }
}


#pragma mark SRWebSocketDelegate
//连接成功
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    DDLogDebug(@"链接成功");
    NSDictionary *dic = @{@"type":@"1",@"token":[YXUserManager sharedManager].userModel.token?:@""};
   [_webSocket send:[self dictionaryToJsonData:dic]];
    if (_state != YXWebSocketMangerState_Normal) {//如有需要待发信息 重新发送
        [_webSocket send:[self dictionaryToJsonData:@{@"type":[NSString stringWithFormat:@"%lu",(unsigned long)_state]}]];
        _state = YXWebSocketMangerState_Normal;
    }
}

//连接失败
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    DDLogDebug(@"链接失败");
    _webSocket = nil;
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
}
@end
