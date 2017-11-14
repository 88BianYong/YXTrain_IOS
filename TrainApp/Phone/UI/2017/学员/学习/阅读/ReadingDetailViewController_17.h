//
//  ReadingDetailViewController_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "ReadingListRequest_17.h"
@interface ReadingDetailViewController_17 : YXBaseViewController
@property (nonatomic, strong) ReadingListRequest_17Item_Objs *reading;
@property (nonatomic, strong) NSString *stageString;
@property (nonatomic, copy) void(^readingDetailFinishCompleteBlock)(void);
@end
