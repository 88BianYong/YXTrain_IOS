//
//  YXVerifyCodeInputTableViewCell.h
//  TrainApp
//
//  Created by 李五民 on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXVerifyCodeInputTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^verifyCodeAction)();
@property (nonatomic, copy) void(^verifyCodeChangedBlock)(NSString *verifyCode);
- (void)startTimer;
- (void)stopTimer;

@end
