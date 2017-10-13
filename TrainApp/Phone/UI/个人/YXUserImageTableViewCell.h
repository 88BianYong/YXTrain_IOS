//
//  YXUserImageTableViewCell.h
//  TrainApp
//
//  Created by 李五民 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXUserImageTableViewCell : UITableViewCell

@property (nonatomic, strong) void(^userImageTap)(void);

-(void)setImageWithUrl:(NSString *)urlString;
-(void)setImageWithDataImage:(UIImage *)image;

@end
