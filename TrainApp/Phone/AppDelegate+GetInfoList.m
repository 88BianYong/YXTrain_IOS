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
    NSDate *agoDate = [[NSUserDefaults standardUserDefaults] objectForKey:kGetInfoListTime];
    if ([agoDate timeIntervalSinceNow] > 3 * 24 * 60 * 60 || 1) {
        [self requestForGetAllProvinces];
    }
}
- (void)requestForGetAllProvinces{
    YXProvincesRequest *request = [[YXProvincesRequest alloc] init];
    [request startRequestWithRetClass:[YXProvincesRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
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
@end
