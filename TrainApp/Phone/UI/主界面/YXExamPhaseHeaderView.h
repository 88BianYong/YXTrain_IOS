//
//  YXExamPhaseHeaderView.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXExamPhaseHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) void(^actionBlock)();

@property (nonatomic, assign) BOOL isFold;
@property (nonatomic, assign) BOOL isFinished;

@end
