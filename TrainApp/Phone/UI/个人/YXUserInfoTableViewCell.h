//
//  YXUserInfoTableViewCell.h
//  TrainApp
//
//  Created by 李五民 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXUserInfoTableViewCell : UITableViewCell

- (void)configUIwithTitle:(NSString *)title content:(NSString *)contentString;

@property (nonatomic, copy) void(^userInfoButtonClickedBlock)();

@end
