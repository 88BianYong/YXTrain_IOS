//
//  BeijingExamExplainView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeijingExamExplainView : UIView
@property (nonatomic, assign) CGRect originRect;
- (void)showInView:(UIView *)view examExplain:(NSString *)string;
@end
