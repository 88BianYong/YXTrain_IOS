//
//  SwipeTableViewCell.h
//  TrainApp
//
//  Created by 郑小龙 on 17/2/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL isChooseBool;
- (void)setupModeEditable:(BOOL)edit;
@end
