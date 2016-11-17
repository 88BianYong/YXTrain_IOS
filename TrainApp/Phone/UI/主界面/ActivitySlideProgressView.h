//
//  ActivitySlideProgressView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/18.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitySlideProgressView : UIView
@property (nonatomic, strong) UIView *wholeProgressView;
@property (nonatomic, assign) CGFloat playProgress;
@property (nonatomic, assign) CGFloat bufferProgress;
@end
