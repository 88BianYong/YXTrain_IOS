//
//  WriteHomeworkmanager.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "WriteHomeworkManager.h"
#import "FileHash.h"
#import "YXUpdVideoHomeworkRequest.h"
@implementation WriteHomeworkModel
@end


@interface WriteHomeworkManager ()
@property (nonatomic, copy) WriteHomeworkmanagerBlock managerBlock;
@property (nonatomic, strong) WriteHomeworkModel *managerModel;
@property (nonatomic, strong)YXCategoryListRequest *listRequest;
@property (nonatomic, strong)YXChapterListRequest *chapterRequest;
@property (nonatomic, strong)YXWriteHomeworkRequest *homeworkRequest;

@property (nonatomic, strong)YXSaveHomeWorkRequest *saveRequest;
@property (nonatomic, strong)YXUpdVideoHomeworkRequest *uploadInfoRequest;


@end

@implementation WriteHomeworkManager
-(instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)requestHomeworkCompleteBlock:(WriteHomeworkmanagerBlock)aCompleteBlock {
    self.managerModel = [[WriteHomeworkModel alloc] init];
    self.managerModel.managerStatus = WriteHomeworkmanagerStatus_Category;
    self.managerBlock = aCompleteBlock;
    [self requestForCategoryId];
}


- (void)requestForCategoryId{
    if (self.listRequest) {
        [self.listRequest stopRequest];
    }
    YXCategoryListRequest *request  = [[YXCategoryListRequest alloc] init];
    request.flag = @"0";
    request.code = @"version_grade";
    WEAK_SELF
    [request startRequestWithRetClass:[YXCategoryListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(self.managerBlock,self.managerModel,error);
        }else{
            self.managerModel.listItem = retItem;
            if (self.itemBody.homeworkid.integerValue != 0) {
                [self requestForHomeworkInfo];
            }else{
                BLOCK_EXEC(self.managerBlock,self.managerModel,nil);
            }
        }
    }];
    self.listRequest = request;
}
- (void)requestForHomeworkInfo{
    if (self.homeworkRequest) {
        [self.homeworkRequest stopRequest];
    }
    WEAK_SELF
    YXWriteHomeworkRequest *request = [[YXWriteHomeworkRequest alloc] init];
    request.projectid = self.itemBody.pid;
    request.hwid = self.itemBody.homeworkid;
    [request startRequestWithRetClass:[YXWriteHomeworkRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        self.managerModel.managerStatus = WriteHomeworkmanagerStatus_Info;
        if (error) {
            BLOCK_EXEC(self.managerBlock,self.managerModel,error);
        }else{
            self.managerModel.homeworkItem = retItem;
            if (!isEmpty(self.managerModel.homeworkItem.body.meizi_chapter)) {
                [self requestForChapterList:self.managerModel.homeworkItem.body];
            }else{
                BLOCK_EXEC(self.managerBlock,self.managerModel,nil);
            }
        }
    }];
    self.homeworkRequest = request;
}

- (void)requestForChapterList:(YXWriteHomeworkRequestItem_Body *)body{
    if (self.chapterRequest) {
        [self.chapterRequest stopRequest];
    }
    YXChapterListRequest *request = [[YXChapterListRequest alloc] init];
    request.stage_id = body.meizi_segment;
    request.subject_id = body.meizi_study;
    request.version_id = body.meizi_edition;
    request.grade_id = body.meizi_grade;
    WEAK_SELF
    [request startRequestWithRetClass:[YXChapterListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        self.managerModel.managerStatus = WriteHomeworkmanagerStatus_ChapterList;
        if (error) {
            BLOCK_EXEC(self.managerBlock,self.managerModel,error);
        }else{
            self.managerModel.chapterList = retItem;
            BLOCK_EXEC(self.managerBlock,self.managerModel,nil);
        }
    }];
    self.chapterRequest = request;
}

#pragma mark - save Request
- (void)requestSaveHomework:(YXSaveHomeWorkRequestModel *)model selectedDictionary:(NSMutableDictionary *)dictionary completeBlock:(SaveWriteHomeworkmanagerBlock)aCompleteBlock;{
    if(self.saveRequest){
        [self.saveRequest stopRequest];
    }
    NSError *error = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[PATH_OF_VIDEO stringByAppendingPathComponent:self.itemBody.fileName] error:&error];
    NSString * fileSizeString = [fileAttributes objectForKey:@"NSFileSize"];
    unsigned long long fileSize = [fileSizeString longLongValue];
    YXSaveHomeWorkRequest *request = [[YXSaveHomeWorkRequest alloc] init];
    request.rid = [FileHash md5HashOfFileAtPath:[PATH_OF_VIDEO stringByAppendingPathComponent:self.itemBody.fileName]];
    request.ext = @"mp4";
    request.action = @"qiniuc";
    request.filename = self.itemBody.fileName;
    request.filesize = [NSString stringWithFormat:@"%llu",fileSize];
    request.reserve = model.toJSONString;
    WEAK_SELF
    [request startRequestWithRetClass:[YXSaveHomeWorkRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,nil,error);
            return;
        }
        YXSaveHomeWorkRequestItem *item = retItem;
        self.itemBody.homeworkid = item.resid;
        self.itemBody.uploadPercent = 0.0;
        self.itemBody.isUploadSuccess = NO;
        NSString *filePath = [PATH_OF_VIDEO stringByAppendingPathComponent:self.itemBody.fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            self.itemBody.lessonStatus = YXVideoLessonStatus_UploadComplete;
        }
        else{
            self.itemBody.lessonStatus = YXVideoLessonStatus_Finish;
        }
        YXHomeworkInfoRequestItem_Body_Detail *detail = [[YXHomeworkInfoRequestItem_Body_Detail alloc] init];
        detail.title = dictionary[@(YXWriteHomeworkListStatus_Title)][1];
        detail.segmentName = dictionary[@(YXWriteHomeworkListStatus_SchoolSection)][1];
        detail.gradeName = dictionary[@(YXWriteHomeworkListStatus_Grade)][1];
        detail.studyName = dictionary[@(YXWriteHomeworkListStatus_Subject)][1];
        detail.chapterName = dictionary[@(YXWriteHomeworkListStatus_Menu)][1];
        detail.versionName = dictionary[@(YXWriteHomeworkListStatus_Version)][1];
        detail.keyword =  dictionary[@(YXWriteHomeworkListStatus_Topic)][1];
        self.itemBody.detail = detail;
        BLOCK_EXEC(aCompleteBlock,self.itemBody,nil);
    }];
    self.saveRequest = request;
    
}

- (void)requestUpdVideoHomework:(NSString *)contentString selectedDictionary:(NSMutableDictionary *)dictionary completeBlock:(SaveWriteHomeworkmanagerBlock)aCompleteBlock {
    YXUpdVideoHomeworkRequest *request = [[YXUpdVideoHomeworkRequest alloc] init];
    request.title = dictionary[@(YXWriteHomeworkListStatus_Title)][1];
    request.pid = self.itemBody.pid;
    request.requireid = self.itemBody.requireId;
    request.hwid = self.itemBody.homeworkid;
    request.content = contentString;
    WEAK_SELF
    [request startRequestWithRetClass:[YXUpdVideoHomeworkRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,nil,error);
            return;
        }
        YXUpdVideoHomeworkRequestItem *item = retItem;
        self.itemBody.homeworkid = item.data.hwid;
        self.itemBody.uploadPercent = 0.0;
        self.itemBody.isUploadSuccess = NO;
        YXHomeworkInfoRequestItem_Body_Detail *detail = [[YXHomeworkInfoRequestItem_Body_Detail alloc] init];
        detail.title = dictionary[@(YXWriteHomeworkListStatus_Title)][1];
        detail.segmentName = dictionary[@(YXWriteHomeworkListStatus_SchoolSection)][1];
        detail.gradeName = dictionary[@(YXWriteHomeworkListStatus_Grade)][1];
        detail.studyName = dictionary[@(YXWriteHomeworkListStatus_Subject)][1];
        detail.chapterName = dictionary[@(YXWriteHomeworkListStatus_Menu)][1];
        detail.versionName = dictionary[@(YXWriteHomeworkListStatus_Version)][1];
        detail.keyword =  dictionary[@(YXWriteHomeworkListStatus_Topic)][1];
        self.itemBody.detail = detail;
        BLOCK_EXEC(aCompleteBlock,self.itemBody,error);
    }];
    self.uploadInfoRequest = request;
}

@end
