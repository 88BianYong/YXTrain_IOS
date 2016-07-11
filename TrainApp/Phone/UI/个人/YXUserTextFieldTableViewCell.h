//
//  YXUserTextFieldTableViewCell.h
//  TrainApp
//
//  Created by 李五民 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXUserTextFieldTableViewCell : UITableViewCell

@property(nonatomic, copy)void(^startUpdateUserName)(NSString *);

-(void)setUserName:(NSString *)name;


@end
