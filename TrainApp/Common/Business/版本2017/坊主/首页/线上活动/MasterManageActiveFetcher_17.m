//
//  MasterManageActiveFetcher_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageActiveFetcher_17.h"
#import "MasterManageActiveRequest_17.h"
@interface MasterManageActiveFetcher_17 ()
@property (nonatomic, strong) MasterManageActiveRequest_17 *listRequest;
@end
@implementation MasterManageActiveFetcher_17
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.listRequest stopRequest];
    MasterManageActiveRequest_17 *request = [[MasterManageActiveRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.page = [NSString stringWithFormat:@"%d",self.pageindex + 1];
    request.pageSize = [NSString stringWithFormat:@"%d",self.pagesize];
    request.barId =  self.barId;
    request.study = self.study;
    request.segment = self.segment;
    request.type = self.type;
    request.stageId = self.stageId;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterManageActiveItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        MasterManageActiveItem *item = retItem;
        BLOCK_EXEC(self.masterManageActiveBlock,[self fomartCollectionFilterModel:item.body],item.body.scheme);
        BLOCK_EXEC(aCompleteBlock,item.body.total.integerValue,item.body.actives,nil);
        
    }];
    self.listRequest = request;
}
- (NSMutableArray<LSTCollectionFilterDefaultModel *> *)fomartCollectionFilterModel:(id)item {
    MasterManageActiveItem_Body *body = item;
    NSMutableArray<LSTCollectionFilterDefaultModel *> *modelArray = [[NSMutableArray<LSTCollectionFilterDefaultModel *> alloc] initWithCapacity:5];
   NSArray<NSString *> *array0 = @[@"全部",@"已参加",@"未参加"];
   NSMutableArray<LSTCollectionFilterDefaultModelItem *> *statusArray0 = [[NSMutableArray<LSTCollectionFilterDefaultModelItem *> alloc] init];
    [array0 enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterDefaultModelItem *model = [[LSTCollectionFilterDefaultModelItem alloc] init];
        model.name = obj;
        model.itemID = [NSString stringWithFormat:@"%ld",idx];
        [statusArray0 addObject:model];
    }];
    LSTCollectionFilterDefaultModel *statusModel0 = [[LSTCollectionFilterDefaultModel alloc] init];
    statusModel0.defaultSelected = @"0";
    statusModel0.itemName = @"参加状态";
    statusModel0.item = statusArray0;
    [modelArray addObject:statusModel0];
    NSMutableArray<LSTCollectionFilterDefaultModelItem *> *barArray = [[NSMutableArray<LSTCollectionFilterDefaultModelItem *> alloc] init];
    [body.bars enumerateObjectsUsingBlock:^(MasterManageActiveItem_Body_Bar *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterDefaultModelItem *model = [[LSTCollectionFilterDefaultModelItem alloc] init];
        model.name = obj.name;
        model.itemID = obj.barId;
        [barArray addObject:model];
    }];
    LSTCollectionFilterDefaultModelItem *model = [[LSTCollectionFilterDefaultModelItem alloc] init];
    model.name = @"全部";
    model.itemID = @"0";
    [barArray insertObject:model atIndex:0];
    LSTCollectionFilterDefaultModel *barModel = [[LSTCollectionFilterDefaultModel alloc] init];
    barModel.defaultSelected = @"0";
    barModel.itemName = @"工作坊";
    barModel.item = barArray;
    [modelArray addObject:barModel];

    NSMutableArray<LSTCollectionFilterDefaultModelItem *> *statusArray1 = [[NSMutableArray<LSTCollectionFilterDefaultModelItem *> alloc] init];
    [body.stages enumerateObjectsUsingBlock:^(MasterManageActiveItem_Body_Stage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterDefaultModelItem *model = [[LSTCollectionFilterDefaultModelItem alloc] init];
        model.name = obj.name;
        model.itemID = obj.stageId;
        [statusArray1 addObject:model];
    }];
    [statusArray1 insertObject:model atIndex:0];
    LSTCollectionFilterDefaultModel *statusModel1 = [[LSTCollectionFilterDefaultModel alloc] init];
    statusModel1.defaultSelected = @"0";
    statusModel1.itemName = @"阶段";
    statusModel1.item = statusArray1;
    [modelArray addObject:statusModel1];
    

    NSMutableArray<LSTCollectionFilterDefaultModelItem *> *statusArray2 = [[NSMutableArray<LSTCollectionFilterDefaultModelItem *> alloc] init];
    [body.segments enumerateObjectsUsingBlock:^(MasterManageActiveItem_Body_Segment *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterDefaultModelItem *model = [[LSTCollectionFilterDefaultModelItem alloc] init];
        model.name = obj.name;
        model.itemID = obj.segmentId;
        [statusArray2 addObject:model];
    }];
    LSTCollectionFilterDefaultModel *statusModel2 = [[LSTCollectionFilterDefaultModel alloc] init];
    statusModel2.defaultSelected = @"0";
    statusModel2.itemName = @"学段";
    statusModel2.item = statusArray2;
    [modelArray addObject:statusModel2];
    
    NSMutableArray<LSTCollectionFilterDefaultModelItem *> *statusArray3 = [[NSMutableArray<LSTCollectionFilterDefaultModelItem *> alloc] init];
    [body.studies enumerateObjectsUsingBlock:^(MasterManageActiveItem_Body_Studie *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterDefaultModelItem *model = [[LSTCollectionFilterDefaultModelItem alloc] init];
        model.name = obj.name;
        model.itemID = obj.studieId;
        [statusArray3 addObject:model];
    }];
    LSTCollectionFilterDefaultModel *statusModel3 = [[LSTCollectionFilterDefaultModel alloc] init];
    statusModel3.defaultSelected = @"0";
    statusModel3.itemName = @"学科";
    statusModel3.item = statusArray3;
    [modelArray addObject:statusModel3];
    return modelArray;
}
@end
