//
//  MasterHomeworkSetListFetcher_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkSetListFetcher_17.h"
#import "MasterHomeworkSetListRequest_17.h"
@interface MasterHomeworkSetListFetcher_17 ()
@property (nonatomic, strong) MasterHomeworkSetListRequest_17 *listRequest;
@end
@implementation MasterHomeworkSetListFetcher_17
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.listRequest stopRequest];
    MasterHomeworkSetListRequest_17 *request = [[MasterHomeworkSetListRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.page = [NSString stringWithFormat:@"%d",self.pageindex + 1];
    request.pageSize = [NSString stringWithFormat:@"%d",self.pagesize];
    request.barId =  self.barId;
    request.recommendStatus = self.recommendStatus;
    request.readStatus = self.readStatus;
    request.commendStatus = self.commendStatus;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterHomeworkSetListItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        MasterHomeworkSetListItem *item = retItem;
        BLOCK_EXEC(self.masterHomeworkBlock,[self fomartCollectionFilterModel:item.body],item.body.schemes);
        BLOCK_EXEC(aCompleteBlock,item.body.total.integerValue,item.body.homeworks,nil);
        
    }];
    self.listRequest = request;
}
- (NSMutableArray<LSTCollectionFilterDefaultModel *> *)fomartCollectionFilterModel:(id)item {
    MasterHomeworkSetListItem_Body *body = item;
    NSMutableArray<LSTCollectionFilterDefaultModel *> *modelArray = [[NSMutableArray<LSTCollectionFilterDefaultModel *> alloc] initWithCapacity:2];
    NSMutableArray<LSTCollectionFilterDefaultModelItem *> *barArray = [[NSMutableArray<LSTCollectionFilterDefaultModelItem *> alloc] init];
    [body.bars enumerateObjectsUsingBlock:^(MasterHomeworkSetListItem_Body_Bar *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterDefaultModelItem *model = [[LSTCollectionFilterDefaultModelItem alloc] init];
        model.name = obj.name;
        model.itemID = obj.barId;
        [barArray addObject:model];
    }];
    LSTCollectionFilterDefaultModel *barModel = [[LSTCollectionFilterDefaultModel alloc] init];
    barModel.defaultSelected = @"0";
    barModel.itemName = @"工作坊";
    barModel.item = barArray;
    [modelArray addObject:barModel];
    LSTCollectionFilterDefaultModelItem *model = [[LSTCollectionFilterDefaultModelItem alloc] init];
    model.name = @"全部";
    model.itemID = @"0";
    [barArray insertObject:model atIndex:0];
    
    NSArray<NSString *> *array1 = @[@"全部",@"已阅读",@"未阅读"];
    NSMutableArray<LSTCollectionFilterDefaultModelItem *> *statusArray1 = [[NSMutableArray<LSTCollectionFilterDefaultModelItem *> alloc] init];
    [array1 enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterDefaultModelItem *model = [[LSTCollectionFilterDefaultModelItem alloc] init];
        model.name = obj;
        model.itemID = [NSString stringWithFormat:@"%ld",idx];
        [statusArray1 addObject:model];
    }];
    LSTCollectionFilterDefaultModel *statusModel1 = [[LSTCollectionFilterDefaultModel alloc] init];
    statusModel1.defaultSelected = @"2";
    statusModel1.itemName = @"阅读状态";
    statusModel1.item = statusArray1;
    [modelArray addObject:statusModel1];
    
    NSArray<NSString *> *array2 = @[@"全部",@"已点评",@"未点评"];
    NSMutableArray<LSTCollectionFilterDefaultModelItem *> *statusArray2 = [[NSMutableArray<LSTCollectionFilterDefaultModelItem *> alloc] init];
    [array2 enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterDefaultModelItem *model = [[LSTCollectionFilterDefaultModelItem alloc] init];
        model.name = obj;
        model.itemID = [NSString stringWithFormat:@"%ld",idx];
        [statusArray2 addObject:model];
    }];
    LSTCollectionFilterDefaultModel *statusModel2 = [[LSTCollectionFilterDefaultModel alloc] init];
    statusModel2.defaultSelected = @"0";
    statusModel2.itemName = @"点评";
    statusModel2.item = statusArray2;
    [modelArray addObject:statusModel2];
    
    
    NSArray<NSString *> *array3 = @[@"全部",@"已推优",@"未推优"];
    NSMutableArray<LSTCollectionFilterDefaultModelItem *> *statusArray3 = [[NSMutableArray<LSTCollectionFilterDefaultModelItem *> alloc] init];
    [array3 enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterDefaultModelItem *model = [[LSTCollectionFilterDefaultModelItem alloc] init];
        model.name = obj;
        model.itemID = [NSString stringWithFormat:@"%ld",idx];
        [statusArray3 addObject:model];
    }];
    LSTCollectionFilterDefaultModel *statusModel3 = [[LSTCollectionFilterDefaultModel alloc] init];
    statusModel3.defaultSelected = @"0";
    statusModel3.itemName = @"推优";
    statusModel3.item = statusArray3;
    [modelArray addObject:statusModel3];
    return modelArray;
}
@end
