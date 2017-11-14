//
//  BeijingCheckedMobileUserCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BeijingCheckedMobileUserBlock) (void);
@interface BeijingCheckedMobileUserCell : UITableViewCell
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancleButton;
- (void)setBeijingCheckedMobileUserBlock:(BeijingCheckedMobileUserBlock)block;
@end
