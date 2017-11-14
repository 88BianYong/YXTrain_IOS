//
//  BeijingCheckedMobileMessageCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSInteger kMessageCountdownTime = 60;
typedef void(^BeijingCheckedMobileMessageBlock) (void);
@interface BeijingCheckedMobileMessageCell : UITableViewCell
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) BOOL isCountdown;
- (void)setBeijingCheckedMobileMessageBlock:(BeijingCheckedMobileMessageBlock)block;
- (void)resetMobileMessage;
@end
