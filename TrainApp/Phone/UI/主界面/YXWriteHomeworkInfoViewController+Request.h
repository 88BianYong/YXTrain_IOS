//
//  YXWriteHomeworkInfoViewController+Request.h
//  TrainApp
//
//  Created by 郑小龙 on 16/9/14.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWriteHomeworkInfoViewController.h"

@interface YXWriteHomeworkInfoViewController (Request)
- (void)requestForHomework;

- (void)requestForChapterList;

- (void)requestSaveHomework:(NSString *)hashStr;

- (void)requestForUpdVideoHomework;

@end
