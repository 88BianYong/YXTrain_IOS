//
//  YXLoginButtonTableViewCell.h
//  TrainApp
//
//  Created by 李五民 on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLoginButtonTableViewCell : UITableViewCell

- (void)setTitleWithString:(NSString *)string;
@property (nonatomic, copy) void(^buttonClicked)();

@end
