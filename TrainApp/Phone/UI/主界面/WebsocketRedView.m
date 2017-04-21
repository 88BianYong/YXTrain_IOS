//
//  WebsocketRedView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/1/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "WebsocketRedView.h"
@interface WebsocketRedView ()
@property (nonatomic, strong) UILabel *pointLabel;
@end
@implementation WebsocketRedView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, 37.0f, 32.0f);
        [self setupUI];
        [self webSocketReceiveMessage:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webSocketReceiveMessage:) name:kYXTrainPushWebSocketReceiveMessage object:nil];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    
    self.pointLabel = [[UILabel alloc] init];
    self.pointLabel.backgroundColor = [UIColor colorWithHexString:@"ed5836"];
    self.pointLabel.layer.cornerRadius = 2.5f;
    self.pointLabel.textAlignment = NSTextAlignmentCenter;
    self.pointLabel.textColor = [UIColor whiteColor];
    self.pointLabel.font = [UIFont systemFontOfSize:12.0f];
    self.pointLabel.clipsToBounds = YES;
    [self addSubview:self.pointLabel];
}
- (void)buttonAction:(UIButton *)sender {
    BLOCK_EXEC(self.WebsocketRedButtonActionBlock);
}
- (void)webSocketReceiveMessage:(NSNotification *)aNotification{

}
- (void)setRedPointNumber:(NSInteger)redPointNumber {
    _redPointNumber = redPointNumber;
    if (_redPointNumber < 0) {
        self.pointLabel.hidden = YES;
    }else if (_redPointNumber == 0) {
        self.pointLabel.frame = CGRectMake(32.0f, 0.0f, 5.0f, 5.0f);
        self.pointLabel.layer.cornerRadius = 2.5f;
        self.pointLabel.hidden = NO;
    }else if (_redPointNumber > 0 && _redPointNumber < 100) {
        self.pointLabel.frame = CGRectMake(32.0f, 0.0f, 15.0f, 15.0f);
        self.pointLabel.layer.cornerRadius = 7.5f;
        self.pointLabel.text = [NSString stringWithFormat:@"%ld",_redPointNumber];
        self.pointLabel.hidden = NO;
    }else {
        self.pointLabel.frame = CGRectMake(32.0f, 0.0f, 25.0f, 15.0f);
        self.pointLabel.layer.cornerRadius = 7.5f;
        self.pointLabel.text = @"99+";
        self.pointLabel.hidden = NO;
    }
}
@end
