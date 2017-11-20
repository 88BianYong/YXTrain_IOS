//
//  MasterHomeworkTableHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterManagerSchemeItem.h"
@interface MasterHomeworkTableHeaderView_17 : UIView
@property (nonatomic, strong) NSArray<MasterManagerSchemeItem*> *schemes;
@property (nonatomic, copy) void(^masterHomeworkButtonBlock)(UIButton *sender);
@property (nonatomic, copy ,readonly) NSString *descripe;
@end
