//
//  MasterSchoolFilterView.h
//  TrainApp
//
//  Created by 郑小龙 on 17/2/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterManageListRequest.h"
@interface MasterSchoolTableView : UITableView
@property (nonatomic, strong) NSMutableArray<__kindof MasterManageListRequestItem_Body_Group *> *groups;
@property (nonatomic, assign) NSInteger chooseInteger;
@property (nonatomic, copy) void(^MasterSchoolTableViewBlock)(NSString *baridString);

@end
