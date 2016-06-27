//
//  YXLoginFieldTableViewCell.h
//  TrainApp
//
//  Created by 李五民 on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLoginFieldTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^textChangedBlock)(NSString *text);

- (void)setPlaceHolderWithString:(NSString *)str keyType:(UIKeyboardType)keyType isSecure:(BOOL)isSecure;

@end
