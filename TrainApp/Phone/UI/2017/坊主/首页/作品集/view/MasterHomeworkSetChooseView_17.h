//
//  MasterHomeworkSetChooseView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterHomeworkSetListDetailRequest_17.h"
@interface MasterHomeworkSetChooseView_17 : UIView
@property (nonatomic, strong) NSArray<MasterHomeworkSetListDetailItem_Body_Homework *> *homeworkArray;
@property (nonatomic, strong) void(^masterHomeworkSetChooseBlock)(NSInteger integer);
- (void)chooseHomeworkDetail:(NSInteger)interger;
@end
