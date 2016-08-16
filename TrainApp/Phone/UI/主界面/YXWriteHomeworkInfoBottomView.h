//
//  YXWriteHomeworkInfoFooterView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXWriteHomeworkInfoBottomView : UIView
@property (nonatomic, copy) void (^topicStringHandler)(NSString *topic);
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, copy) NSString *topicString;
@end
