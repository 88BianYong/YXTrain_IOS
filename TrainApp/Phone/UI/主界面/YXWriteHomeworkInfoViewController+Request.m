//
//  YXWriteHomeworkInfoViewController+Request.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/14.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWriteHomeworkInfoViewController+Request.h"
#import "YXWriteHomeworkInfoViewController+Format.h"
#import "YXVideoRecordManager.h"
#import "FileHash.h"
static  NSString *const trackEventName = @"上传作业";
@implementation YXWriteHomeworkInfoViewController (Request)
- (void)requestForHomework {
    WriteHomeworkManager *request = [[WriteHomeworkManager alloc] init];
    request.itemBody = self.videoModel;
    [self startLoading];
    WEAK_SELF
    [request requestHomeworkCompleteBlock:^(WriteHomeworkModel *model, NSError *error) {
        STRONG_SELF
        [self stopLoading];
        if (model.managerStatus >= WriteHomeworkmanagerStatus_Category) {
            if (error) {
                self.errorView.frame = self.view.bounds;
                [self.view addSubview:self.errorView];
            }else {
                self.listItem = model.listItem;
                [self schoolSectionWithData];
                [self.errorView removeFromSuperview];
                [self.tableView reloadData];
            }
        }
        if (model.managerStatus >= WriteHomeworkmanagerStatus_Info) {
            if (error) {
                [self showToast:@"作业信息获取失败"];
            }else {
                self.homeworkItem = model.homeworkItem;
                [self saveWorkhomeInfo:self.homeworkItem.body];
                [self.tableView reloadData];
            }
        }
        if (model.managerStatus >= WriteHomeworkmanagerStatus_ChapterList){
            if (error) {
                self.menuView.isError = YES;
            }else{
                self.menuView.isError = NO;
                self.chapterList = model.chapterList;
                [self saveChapterList];
                [self.tableView reloadData];
            }
        }
    }];
    self.managerRequest = request;
}
- (void)requestForChapterList{
    if (self.chapterRequest) {
        [self.chapterRequest stopRequest];
    }
    YXChapterListRequest *request = [[YXChapterListRequest alloc] init];
    request.stage_id = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_SchoolSection)][0];
    request.subject_id = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Subject)][0];
    request.version_id = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Version)][0];
    request.grade_id = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Grade)][0];
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXChapterListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            self.menuView.isError = YES;
        }else{
            self.menuView.isError = NO;
            self.chapterList = retItem;
            [self saveChapterList];
            [self.tableView reloadData];
        }
    }];
    self.chapterRequest = request;
}
- (void)requestSaveHomework{
    WriteHomeworkManager *request = [[WriteHomeworkManager alloc] init];
    request.itemBody = self.videoModel;
    [self startLoading];
    WEAK_SELF
    [request requestSaveHomework:[self modelForSaveHomeWork] selectedDictionary:self.selectedMutableDictionary completeBlock:^(YXHomeworkInfoRequestItem_Body *itemBody, NSError *error) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            NSString *aError = [NSString stringWithFormat:@"error=%@",error];
            NSDictionary *dict = @{
                                   @"token": [YXUserManager sharedManager].userModel.token?:@"",
                                   @"uid": [YXUserManager sharedManager].userModel.uid?:@"",
                                   @"error": aError?:@""};
            [YXDataStatisticsManger trackEvent:@"上传作业视频" label:@"出错信息" parameters:dict];
            [self showToast:@"视频作业上传失败"];
            return;
        }
        self.videoModel = itemBody;
        [YXVideoRecordManager saveVideoArrayWithModel:self.videoModel];
        [YXDataStatisticsManger trackEvent:trackEventName label:@"成功上传作业" parameters:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.managerRequest = request;
}
- (void)requestForUpdVideoHomework{
    WriteHomeworkManager *request = [[WriteHomeworkManager alloc] init];
    request.itemBody = self.videoModel;
    [self startLoading];
    WEAK_SELF
    [request requestUpdVideoHomework:[self formatUploadVideoHomeworkContent] selectedDictionary:self.selectedMutableDictionary completeBlock:^(YXHomeworkInfoRequestItem_Body *itemBody, NSError *error) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:@"网络异常,请稍后重试"];
            return;
        }
        self.videoModel = itemBody;
        [YXVideoRecordManager saveVideoArrayWithModel:self.videoModel];
        [self showToast:@"保存成功"];
        [YXDataStatisticsManger trackEvent:trackEventName label:@"成功修改作业信息" parameters:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    self.managerRequest = request;
}

@end
