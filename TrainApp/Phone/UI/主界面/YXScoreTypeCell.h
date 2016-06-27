//
//  YXScoreTypeCell.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXScoreCellType) {
    YXScoreCellType_Lead,
    YXScoreCellType_Exp
};

@interface YXScoreTypeCell : UITableViewCell

@property (nonatomic, assign) YXScoreCellType type;

@end
