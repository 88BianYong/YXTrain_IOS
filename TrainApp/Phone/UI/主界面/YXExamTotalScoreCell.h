//
//  YXExamTotalScoreCell.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXExamTotalScoreCell : UITableViewCell

@property (nonatomic, strong) NSString *totalScore;
@property (nonatomic, strong) NSString *totalPoint;

- (void)startAnimation;

@end
