//
//  YXNoticeViewController.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/22.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "PagedListViewControllerBase.h"
typedef NS_ENUM (NSInteger, YXNoticeAndBulletinFlag) {
    YXFlag_Notice = 0,
    YXFlag_Bulletin = 1,
};

@interface YXNoticeViewController : PagedListViewControllerBase<YXTrackPageDataProtocol>

@property (nonatomic, assign) YXNoticeAndBulletinFlag flag;

@end
