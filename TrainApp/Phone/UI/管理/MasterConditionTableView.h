//
//  MasterFilterTableView.h
//  TrainApp
//
//  Created by 郑小龙 on 17/2/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterConditionTableView : UITableView
@property (nonatomic, copy) void(^MasterConditionChooseBlock)(NSDictionary *dictionary);
@property (nonatomic, assign) BOOL isChooseBool;
@end
