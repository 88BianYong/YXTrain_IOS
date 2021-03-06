//
//  YXWriteHomeworkInfoViewController+Format.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWriteHomeworkInfoViewController.h"

@interface YXWriteHomeworkInfoViewController (Format)
- (void)schoolSectionWithData;
- (void)showWorkhomeInfo:(YXWriteHomeworkListStatus)status withChangeObj:(id)changeObj;
- (BOOL)saveInfoHomeWorkShowToast:(BOOL)isShow;
- (void)saveWorkhomeInfo:(YXWriteHomeworkRequestItem_Body *)body;
- (void)saveChapterList;
- (NSString *)formatUploadVideoHomeworkContent;
- (YXSaveHomeWorkRequestModel *)modelForSaveHomeWork;
@end
