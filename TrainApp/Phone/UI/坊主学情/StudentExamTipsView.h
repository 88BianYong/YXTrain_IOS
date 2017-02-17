//
//  StudentExamTipsView.h
//  TrainApp
//
//  Created by 郑小龙 on 17/2/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentExamTipsView : UIView
@property (nonatomic, copy) void(^studentExamTipsOpenCloseBlock)(UIButton *sender);
@end
