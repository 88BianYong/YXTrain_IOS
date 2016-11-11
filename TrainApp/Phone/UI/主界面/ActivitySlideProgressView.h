//
//  ActivitySlideProgressView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/14.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitySlideProgressView : UIControl
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, assign) CGFloat playProgress;
@property (nonatomic, assign) CGFloat bufferProgress;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL bSliding;

- (void)updateUI;
@end
