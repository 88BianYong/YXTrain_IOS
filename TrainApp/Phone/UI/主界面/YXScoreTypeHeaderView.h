//
//  YXScoreTypeCell.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXScoreHeaderViewType) {
    YXScoreHeaderViewType_Lead = 0,
    YXScoreHeaderViewType_Exp = 1,
};

@interface YXScoreTypeHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign) YXScoreHeaderViewType type;

@end
