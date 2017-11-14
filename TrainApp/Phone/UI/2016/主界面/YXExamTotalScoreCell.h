//
//  YXExamTotalScoreCell.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXWaveView.h"
@interface YXExamTotalScoreCell : UITableViewCell

@property (nonatomic, strong) NSString *totalScore;
@property (nonatomic, strong) NSString *totalPoint;
@property (nonatomic, strong) YXWaveView *waveView;


- (void)startAnimation;

@end
