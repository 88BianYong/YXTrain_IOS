//
//  YXTrainListChooseCell.h
//  TrainApp
//
//  Created by 郑小龙 on 2018/4/25.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXTrainListChooseCell : UITableViewCell
@property (nonatomic, strong) YXTrainListRequestItem_body_train *train;
@property (nonatomic, assign) BOOL isChooseBool;
@end
