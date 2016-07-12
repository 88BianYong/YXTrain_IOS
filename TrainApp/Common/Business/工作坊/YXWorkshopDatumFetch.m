//
//  YXWorkshopDatumFetch.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopDatumFetch.h"
#import "YXWorkshopDatumRequest.h"
#import "YXDatumSearchRequest.h"
#import "YXDatumCellModel.h"
@interface YXWorkshopDatumFetch()
{
    YXWorkshopDatumRequest *_datumRequest;
}
@end
@implementation YXWorkshopDatumFetch
- (void)startWithBlock:(void(^)(int total, NSArray *retItemArray, NSError *error))aCompleteBlock{
    _datumRequest = [[YXWorkshopDatumRequest alloc] init];
    _datumRequest.barid = self.barid;
    
    _datumRequest.pageindex = [NSString stringWithFormat:@"%d", self.pageindex + 1];
    _datumRequest.pagesize = [NSString stringWithFormat:@"%d", self.pagesize];
    [_datumRequest startRequestWithRetClass:[YXDatumSearchRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (error) {
            aCompleteBlock(0, nil, error);
            return;
        }
//        NSString *pathString = [[NSBundle mainBundle] pathForResource:@"temp" ofType:@"txt"];
//        NSString *string = [NSString stringWithContentsOfFile:pathString encoding:NSUTF8StringEncoding error:nil];
//        YXDatumSearchRequestItem *item = [[YXDatumSearchRequestItem alloc] initWithString:string error:nil];
//        NSMutableArray *array = [NSMutableArray array];
//        for (YXDatumSearchRequestItem_data *data in item.data) {
//            YXDatumCellModel *model = [YXDatumCellModel modelFromSearchRequestItemData:data];
//            [array addObject:model];
//        }
//        aCompleteBlock([item.total intValue], array, nil);
        
        YXDatumSearchRequestItem *item = retItem;
        aCompleteBlock([item.total intValue], item.data, nil);
        
    }];
}
- (void)stop{
    [_datumRequest stopRequest];
}
@end
