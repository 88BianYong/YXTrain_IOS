//
//  YXHostpostDatumFetch.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHotspotDatumFetch.h"
#import "YXHotspotRequest.h"
@interface YXHotspotDatumFetch()
@property (nonatomic, strong) YXHotspotRequest *hotspotRequest;
@end

@implementation YXHotspotDatumFetch
- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock{
    YXHotspotRequest *request = [[YXHotspotRequest alloc] init];
    request.pageindex = [NSString stringWithFormat:@"%d", self.pageindex + 1];
    request.pagesize = [NSString stringWithFormat:@"%d", self.pagesize];
    [request startRequestWithRetClass:[YXHotspotRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (error) {
            aCompleteBlock(0, nil, error);
        }
        else{
            YXHotspotRequestItem *item = (YXHotspotRequestItem *)retItem;
            aCompleteBlock([item.total intValue],item.data,nil);
        }
    }];
    self.hotspotRequest = request;
}
- (void)stop{
    [self.hotspotRequest stopRequest];
}
@end
