//
//  WriteHomeworkmanager.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "WriteHomeworkManager.h"

@implementation WriteHomeworkModel
@end


@interface WriteHomeworkManager ()
@property (nonatomic, copy) WriteHomeworkmanagerBlock managerBlock;
@property (nonatomic, strong) WriteHomeworkModel *managerModel;

@property (nonatomic, strong)YXCategoryListRequest *listRequest;
@property (nonatomic, strong)YXChapterListRequest *chapterRequest;
@property (nonatomic, strong)YXWriteHomeworkRequest *homeworkRequest;
@property (nonatomic, strong)YXHomeworkInfoRequestItem_Body *itemBody;


@end

@implementation WriteHomeworkManager
-(instancetype)init {
    if (self = [super init]) {
        self.managerModel = [[WriteHomeworkModel alloc] init];
        self.managerModel.managerStatus = WriteHomeworkmanagerStatus_Category;
    }
    return self;
}

- (void)requestHomework:(YXHomeworkInfoRequestItem_Body *)body CompleteBlock:(WriteHomeworkmanagerBlock)aCompleteBlock {
    self.itemBody = body;
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

@end
