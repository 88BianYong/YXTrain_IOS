//
//  StudentsLearnFilterView.h
//  TrainApp
//
//  Created by 郑小龙 on 17/2/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterManageListRequest.h"

@interface StudentsLearnFilterView : UIView
@property (nonatomic, strong) NSMutableArray<__kindof MasterManageListRequestItem_Body_Group *> *groups;
@property (nonatomic, copy) void(^StudentsLearnFilterSchoolBlock)(NSString *baridString);
@property (nonatomic, copy) void(^StudentsLearnFilterConditionBlock)(NSDictionary *dictionary);
@end
