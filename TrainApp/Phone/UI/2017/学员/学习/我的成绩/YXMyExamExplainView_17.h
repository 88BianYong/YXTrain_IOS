//
//  YXMyExamExplainView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXMyExamExplainView_17 : UIView
+ (CGFloat)heightForDescription:(NSString *)desc ;

- (void)showInView:(UIView *)view examExplain:(NSString *)string;
- (void)setupOriginRect:(CGRect)rect withToTop:(BOOL)isTop;

@end
