//
//  YXAlertCustomView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/10.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, YXAlertActionStyle) {
    YXAlertActionStyleAlone = 0,
    YXAlertActionStyleDefault = 1,
    YXAlertActionStyleCancel = 2,
} ;
typedef void (^ActionBlock)();

@interface YXAlertAction : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) YXAlertActionStyle style;
@property (nonatomic, copy) ActionBlock block;
@end

@interface YXAlertCustomView : UIView
+ (instancetype)alertViewWithTitle:(NSString *)title image:(NSString *)image actions:(NSArray *)actions;
- (void)showAlertView:(UIView *)view;
@end
