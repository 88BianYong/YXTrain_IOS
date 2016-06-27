//
//  YXAlertView.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YXAlertViewBlock)(void);

@interface YXAlertView : UIAlertView

/** Creates and returns a new alert view with only a title.
 
 @param title The title of the alert view.
 @return A newly created alert view.
 */
+ (instancetype)alertViewWithTitle:(NSString *)title;

/** Creates and returns a new alert view with only a title, message, and cancel button.
 
 @param title The title of the alert view.
 @param message The message content of the alert.
 @return A newly created alert view.
 */
+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message;

/** Add a new button with an associated code block.
 
 @param title The text of the button.
 @param block A block of code.
 */
- (void)addButtonWithTitle:(NSString *)title action:(YXAlertViewBlock)block;

/** show alert view
 */
- (void)show;

@end


@interface YXAlertView (YXConfirmMethod)

+ (void)showAlertViewWithMessage:(NSString *)message;
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message hint:(NSString *)hint;

@end