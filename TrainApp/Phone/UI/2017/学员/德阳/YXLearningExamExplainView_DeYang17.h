//
//  YXLearningExamExplainView_DeYang17.h
//  TrainApp
//
//  Created by 郑小龙 on 2018/2/26.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLearningExamExplainView_DeYang17 : UIView
+ (CGFloat)heightForDescription:(NSString *)desc ;
- (void)showInView:(UIView *)view examExplain:(NSString *)string;
- (void)setupOriginRect:(CGRect)rect withToTop:(BOOL)isTop;
@end
