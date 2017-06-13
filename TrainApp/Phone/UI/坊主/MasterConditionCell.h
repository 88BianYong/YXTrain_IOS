//
//  MasterConditionCell.h
//  TrainApp
//
//  Created by 郑小龙 on 17/2/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MasterConditionRoundView : UIView
@property (nonatomic, assign) BOOL isChooseBool;
@property (nonatomic, strong) UIView *outsideRoundView;
@property (nonatomic, strong) UIView *insideRoundView;
@property (nonatomic, strong) UILabel *nameLabel;
@end
@interface MasterConditionCell : UITableViewCell
@property (nonatomic, strong) MasterConditionRoundView *leftRoundView;
@property (nonatomic, strong) MasterConditionRoundView *rightRoundView;
@property (nonatomic, assign) NSInteger chooseInteger;
@end
