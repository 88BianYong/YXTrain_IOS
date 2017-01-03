//
//  WebsocketRedView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/1/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "WebsocketRedView.h"

@implementation WebsocketRedView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, 37.0f, 32.0f);
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webSocketReceiveMessage:) name:kYXTrainWebSocketReceiveMessage object:nil];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    
    _pointView = [[UIView alloc] init];
    _pointView.backgroundColor = [UIColor colorWithHexString:@"ed5836"];
    _pointView.layer.cornerRadius = 2.5f;
    _pointView.hidden = YES;
    [self addSubview:_pointView];
}
- (void)buttonAction:(UIButton *)sender {
    BLOCK_EXEC(self.WebsocketRedButtonActionBlock);
}
- (void)webSocketReceiveMessage:(NSNotification *)aNotification{

}
@end
