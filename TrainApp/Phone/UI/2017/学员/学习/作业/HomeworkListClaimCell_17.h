//
//  HomeworkListClaimCell_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkListRequest_17.h"

@interface HomeworkListClaimCell_17 : UITableViewCell
@property (nonatomic, strong) HomeworkListRequest_17Item_Scheme *scheme;
@property (nonatomic, copy) void(^homeworkListClaimButtonBlock)(UIButton *sender);

@end
