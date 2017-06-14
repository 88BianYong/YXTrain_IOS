//
//  AppDelegate+GetInfoList.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "AppDelegate+GetInfoList.h"

@implementation AppDelegate (GetInfoList)
- (void)getInfoListUpdateDate{
    NSDate *agoDate = [[NSUserDefaults standardUserDefaults] objectForKey:kYXTrainGetInfoListTime];
    if ([agoDate timeIntervalSinceNow] > 3 * 24 * 60 * 60 || agoDate == nil) {
        [self requestForCheckRequest];
    }
}
- (void)requestForCheckRequest{
    if (self.checkRequest) {
        [self.checkRequest stopRequest];
    }
    WEAK_SELF
    YXCheckRequest *request = [[YXCheckRequest alloc] init];
    [request startRequestWithRetClass:[YXCheckRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (!error) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kYXTrainGetInfoListTime];
            STRONG_SELF
            YXCheckRequestItem *item = retItem;
            NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            filePath = [filePath stringByAppendingPathComponent:@"provinceData.json"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                filePath = [[NSBundle mainBundle] pathForResource:@"provinceData" ofType:@"json"];
            }
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            if (data) {
                NSError *error;
                YXProvincesRequestItem *requestItem = [[YXProvincesRequestItem alloc] initWithData:data error:&error];
                if (![item.version isEqualToString:requestItem.version] && !isEmpty(item.version)) {
                    [self requestForGetAllProvinces];
                    [self requestForStageAndSubject];
                }
            }
        }
    }];
    self.checkRequest = request;
}


- (void)requestForGetAllProvinces{
    if (self.provincesRequest) {
        [self.provincesRequest stopRequest];
    }
    YXProvincesRequest *request = [[YXProvincesRequest alloc] init];
    WEAK_SELF
    [request startRequestWithRetClass:[YXProvincesRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        YXProvincesRequestItem *item = retItem;
        if (!error && item.data.count > 0) {
            NSData *data = item.toJSONData;
            NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path=[paths objectAtIndex:0];
            NSString *Json_path=[path stringByAppendingPathComponent:@"provinceData.json"];
            BOOL write  = [data writeToFile:Json_path atomically:YES];
            if (!write) {
                DDLogError(@"写入失败");
            }
        }
    }];
    self.provincesRequest = request;
}

- (void)requestForStageAndSubject
{
    if (self.stageAndSubjectRequest) {
        [self.stageAndSubjectRequest stopRequest];
    }
   YXStageAndSubjectRequest *request  = [[YXStageAndSubjectRequest alloc] init];
    WEAK_SELF
    [request startRequestWithRetClass:[YXStageAndSubjectItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        YXStageAndSubjectItem *item = retItem;
        if (!error && item.stages.count > 0) {
            NSData *data = item.toJSONData;
            NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *Json_path = [path stringByAppendingPathComponent:@"stageAndSubject.json"];
            BOOL write  = [data writeToFile:Json_path atomically:YES];
            if (!write) {
                DDLogError(@"写入失败");
            }
            DDLogDebug(@"%@",path);
        }
    }];
    self.stageAndSubjectRequest = request;
}

@end
