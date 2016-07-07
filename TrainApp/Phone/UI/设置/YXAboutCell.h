//
//  YXAboutCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YXAboutCellDelegate;
@interface YXAboutCell : UITableViewCell
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,assign) id<YXAboutCellDelegate> delegate;
@end
@protocol YXAboutCellDelegate <NSObject>

- (void)showMenu:(UITableViewCell *)cell;
@end