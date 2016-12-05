//
//  YXFilterButton.h
//  TrainApp
//
//  Created by 李五民 on 16/6/28.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXFilterButton : UIButton

@property (nonatomic, strong) UILabel *btnLabel;
- (void)setButtonTitle:(NSString *)title withMaxWidth:(float)width;
- (void)btnTitleColor:(UIColor *)color;
- (void)changeButtonImageExpand:(BOOL)isExpand;
- (void)changeButtonImageSelected:(BOOL)isSelected;

@end
