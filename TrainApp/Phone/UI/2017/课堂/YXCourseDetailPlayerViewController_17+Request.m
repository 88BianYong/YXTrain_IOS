//
//  YXCourseDetailPlayerViewController_17+Request.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXCourseDetailPlayerViewController_17+Request.h"

@implementation YXCourseDetailPlayerViewController_17 (Request)
- (void)requestForCourseDetail {
    if (self.course.is_selected.integerValue == 0 && self.fromWhere == VideoCourseFromWhere_Detail) {
        [self.courseDetailRequest stopRequest];
        YXCourseDetailRequest *request = [[YXCourseDetailRequest alloc] init];
        request.cid = self.course.courses_id;
        request.stageid = self.course.module_id;
        request.courseType = self.course.courseType;
        request.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
//        request.cid = @"10163206";
//        request.stageid = @"2240";
//        request.pid = @"1798";
#warning 测试
        if (request.cid.integerValue == 10163206) {
            request.pid = @"1798";
            request.token = @"daa7d588a41a46c898dddcea53aa0ab1";
        }
        WEAK_SELF
        [request startRequestWithRetClass:[YXCourseDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self stopLoading];
            YXCourseDetailRequestItem *item = (YXCourseDetailRequestItem *)retItem;
            UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
            data.requestDataExist = item.body.chapters.count != 0;
            data.localDataExist = NO;
            data.error = error;
            if ([self handleRequestData:data]) {
                return;
            }
            self.detailItem = item.body;
        }];
        self.courseDetailRequest = request;
    }else {
        [self.moduleDetailRequest stopRequest];
        YXModuleDetailRequest *request = [[YXModuleDetailRequest alloc]init];
        request.cid = self.course.courses_id;
        request.w = [LSTSharedInstance sharedInstance].trainManager.currentProject.w;
        request.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
        request.courseType = self.course.courseType;
        WEAK_SELF
        [request startRequestWithRetClass:[YXModuleDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self stopLoading];
            YXModuleDetailRequestItem *item = (YXModuleDetailRequestItem *)retItem;
            UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
            data.requestDataExist = item.body.chapters.count != 0;
            data.localDataExist = NO;
            data.error = error;
            if ([self handleRequestData:data]) {
                return;
            }
            self.detailItem = item.body;
        }];
        self.moduleDetailRequest = request;
    }
}

@end
