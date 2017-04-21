//
//  WebsocketRedView.h
//  TrainApp
//
//  Created by 郑小龙 on 17/1/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WebsocketRedView : UIView
@property (nonatomic, strong, readonly) UIButton *button;
@property (nonatomic, assign) NSInteger redPointNumber;//-1隐藏,0小红点,>0大红点显示数,>99显示99+
@property (nonatomic, copy) void (^WebsocketRedButtonActionBlock)(void);
- (void)webSocketReceiveMessage:(NSNotification *)aNotification;
@end
