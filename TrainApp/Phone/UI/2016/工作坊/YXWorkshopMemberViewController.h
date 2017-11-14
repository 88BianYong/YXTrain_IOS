//
//  YXWorkshopMemberViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"

@interface YXWorkshopMemberViewController : YXBaseViewController
@property (nonatomic, strong)NSMutableArray *cachMutableArray;//工作坊详情缓存成员数据
@property (nonatomic, assign)BOOL hiddenPullupBool;//是否显示上拉加载更多
@property (nonatomic, copy)NSString *baridString;
@end
