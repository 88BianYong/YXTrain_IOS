//
//  YXTestViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTestViewController.h"
#import "SRWebSocket.h"

@interface YXTestViewController ()<SRWebSocketDelegate>
{
    SRWebSocket *_webSocket;
    NSTimer *_timer;
}
@end

@implementation YXTestViewController
static NSInteger integer;
- (void)viewDidLoad {
    self.devTestActions = @[@"122"];
    [super viewDidLoad];
    [self setupData];
    _timer = [NSTimer scheduledTimerWithTimeInterval:9.0f target:self selector:@selector(sendString) userInfo:nil repeats:YES];
    
}

- (void)sendString{
    integer ++;
    [_webSocket send:[NSString stringWithFormat:@"哇哈哈%ld",(long)integer]];
    DDLogDebug(@">>>>%ld",(long)_webSocket.readyState);
}
- (void)setupData{
    _webSocket.delegate = nil;
    
    [_webSocket close];
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://mobile.yanxiu.com/test/api/websocket"]]];
    
    _webSocket.delegate = self;
    
    [_webSocket open];
        
//    [self webSocketDidOpen:_webSocket];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//连接成功
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;

{
    NSLog(@"Websocket Connected");
    NSString *sendString = @"爱你一万年";
    [_webSocket send:sendString];
    
}

//连接失败

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;

{
    
    NSLog(@":( Websocket Failed With Error %@", error);
    
    _webSocket = nil;
    
}

//接收到新消息的处理

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;

{
    
    NSLog(@"Received \"%@\"", message);
    
}

//连接关闭

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

{
    
    NSLog(@"WebSocket closed");
    
    //self.title = @"Connection Closed! (see logs)";
    
    _webSocket = nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self setupData];
}

@end
