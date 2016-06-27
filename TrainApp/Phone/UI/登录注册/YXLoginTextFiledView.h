//
//  YXLoginTextFiledView.h
//  TrainApp
//
//  Created by 李五民 on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLoginTextFiledView : UIView

@property (nonatomic,copy) void(^textChangedBlock)(NSString *);

- (void)setTextFiledViewBackgroundColor:(UIColor *)backgroundColor;
- (void)setTextFiledEditedBackgroundColor:(UIColor *)backgroundColor;
- (void)setPlaceHolderWithString:(NSString *)str keyType:(UIKeyboardType)keyType isSecure:(BOOL)isSecure;
- (void)setTextColor:(UIColor *)color placeHolderColor:(UIColor *)placeHolderColor;
- (void)resetTextFieldText;

@end
