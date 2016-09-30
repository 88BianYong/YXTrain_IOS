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
- (void)requestForCategoryId{
    if (self.listRequest) {
        [self.listRequest stopRequest];
    }
    YXCategoryListRequest *request  = [[YXCategoryListRequest alloc] init];
    request.flag = @"0";
    request.code = @"version_grade";
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXCategoryListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            self.errorView.frame = self.view.bounds;
            [self.view addSubview:self.errorView];
        }else{
            self.listItem = retItem;
            [self schoolSectionWithData];
            [self.tableView reloadData];
            if (self.videoModel.homeworkid.integerValue != 0) {
                [self requestForHomeworkInfo];
            }
            [self.errorView removeFromSuperview];
        }
    }];
    self.listRequest = request;
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

- (void)requestSaveHomework:(NSString *)hashStr{
    if(self.saveRequest){
        [self.saveRequest stopRequest];
    }
    NSError *error = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[PATH_OF_VIDEO stringByAppendingPathComponent:self.videoModel.fileName] error:&error];
    NSString * fileSizeString = [fileAttributes objectForKey:@"NSFileSize"];
    unsigned long long fileSize = [fileSizeString longLongValue];
    YXSaveHomeWorkRequest *request = [[YXSaveHomeWorkRequest alloc] init];
    request.rid = [FileHash md5HashOfFileAtPath:[PATH_OF_VIDEO stringByAppendingPathComponent:self.videoModel.fileName]];
    request.ext = @"mp4";
    request.action = @"qiniuc";
    request.filename = self.videoModel.fileName;
    request.filesize = [NSString stringWithFormat:@"%llu",fileSize];
    YXSaveHomeWorkRequestModel *model = [[YXSaveHomeWorkRequestModel alloc] init];
    model.categoryIds = [self getCategoryIds];
    model.title = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Title)][1];
    model.chapter = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Menu)][0];
    model.des = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Topic)][1];
    model.projectid = self.videoModel.pid;
    model.requireid = self.videoModel.requireId;
    model.typeId = @"1004";
    model.hwid = self.videoModel.homeworkid;
    model.shareType = @"0";
    model.status = @"-1";
    request.reserve = model.toJSONString;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXSaveHomeWorkRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (!error) {
            YXSaveHomeWorkRequestItem *item = retItem;
            self.videoModel.homeworkid = item.resid;
            self.videoModel.uploadPercent = 0.0;
            self.videoModel.isUploadSuccess = NO;
            NSString *filePath = [PATH_OF_VIDEO stringByAppendingPathComponent:self.videoModel.fileName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                self.videoModel.lessonStatus = YXVideoLessonStatus_UploadComplete;
            }
            else{
                self.videoModel.lessonStatus = YXVideoLessonStatus_Finish;
            }
            YXHomeworkInfoRequestItem_Body_Detail *detail = [[YXHomeworkInfoRequestItem_Body_Detail alloc] init];
            detail.title = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Title)][1];
            detail.segmentName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_SchoolSection)][1];
            detail.gradeName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Grade)][1];
            detail.studyName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Subject)][1];
            detail.chapterName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Menu)][1];
            detail.versionName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Version)][1];
            detail.keyword =  self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Topic)][1];
            self.videoModel.detail = detail;
            [YXVideoRecordManager saveVideoArrayWithModel:self.videoModel];
            [self.navigationController popViewControllerAnimated:YES];
            [YXDataStatisticsManger trackEvent:trackEventName label:@"成功上传作业" parameters:nil];
        }else{
            [self showToast:@"视频作业上传失败"];
        }
    }];
    self.saveRequest = request;
}

- (void)requestForHomeworkInfo{
    if (self.homeworkRequest) {
        [self.homeworkRequest stopRequest];
    }
    WEAK_SELF
    YXWriteHomeworkRequest *request = [[YXWriteHomeworkRequest alloc] init];
    request.projectid = self.videoModel.pid;
    request.hwid = self.videoModel.homeworkid;
    [self startLoading];
    [request startRequestWithRetClass:[YXWriteHomeworkRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:@"作业信息获取失败"];
        }else{
            YXWriteHomeworkRequestItem *item = retItem;
            self.homeworkItem = item;
            [self saveWorkhomeInfo:item.body];
            [self.tableView reloadData];
            if (!isEmpty(self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Grade)][1])) {
                [self requestForChapterList];
            };
        }
    }];
    self.homeworkRequest = request;
}

- (void)requestForUpdVideoHomework{
    if (self.uploadInfoRequest) {
        [self.uploadInfoRequest stopRequest];
    }
    [self startLoading];
    WEAK_SELF
    YXUpdVideoHomeworkRequest *request = [[YXUpdVideoHomeworkRequest alloc] init];
    request.title = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Title)][1];
    request.pid = self.videoModel.pid;
    request.requireid = self.videoModel.requireId;
    request.hwid = self.videoModel.homeworkid;
    request.content = [self formatUploadVideoHomeworkContent];
    [request startRequestWithRetClass:[YXUpdVideoHomeworkRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (!error) {
            YXUpdVideoHomeworkRequestItem *item = retItem;
            self.videoModel.homeworkid = item.data.hwid;
            self.videoModel.uploadPercent = 0.0;
            self.videoModel.isUploadSuccess = NO;
            YXHomeworkInfoRequestItem_Body_Detail *detail = [[YXHomeworkInfoRequestItem_Body_Detail alloc] init];
            detail.title = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Title)][1];
            detail.segmentName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_SchoolSection)][1];
            detail.gradeName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Grade)][1];
            detail.studyName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Subject)][1];
            detail.chapterName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Menu)][1];
            detail.versionName = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Version)][1];
            detail.keyword =  self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Topic)][1];
            self.videoModel.detail = detail;
            [YXVideoRecordManager saveVideoArrayWithModel:self.videoModel];
            [self showToast:@"保存成功"];
            [YXDataStatisticsManger trackEvent:trackEventName label:@"成功修改作业信息" parameters:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            [self showToast:@"网络异常,请稍后重试"];
        }
    }];
    self.uploadInfoRequest = request;
}

@end
