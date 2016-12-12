//
//  LSTAlertView.h
//  TrainApp
//
//  Created by ZLL on 2016/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "AlertView.h"
#import "LSTAlertButton.h"
#import "LSTAlertTitleLabel.h"

extern CGFloat const kDefaultContentViewWith;
typedef void(^ButtonActionBlock)(void);

@interface LSTAlertView : AlertView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;

- (void)addButtonWithTitle:(NSString *)title style:(LSTAlertActionStyle)style action:(ButtonActionBlock)buttonActionBlock;
- (UIView *)generateDefaultView;
- (void)show;
- (void)show:(BOOL)animated;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view animated:(BOOL)animated;
@end
