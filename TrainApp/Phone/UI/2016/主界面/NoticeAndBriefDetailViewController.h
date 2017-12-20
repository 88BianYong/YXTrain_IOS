//
//  NoticeAndBriefDetailViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
typedef NS_ENUM (NSInteger, NoticeAndBriefFlag) {
    NoticeAndBriefFlag_Notice = 0,
    NoticeAndBriefFlag_Brief = 1,
};
@interface NoticeAndBriefDetailViewController : YXBaseViewController
@property (nonatomic, copy) NSString *nbIdString;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, assign) NoticeAndBriefFlag detailFlag;
@end
