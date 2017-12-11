//
//  MasterLearningInfoFetcher_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterLearningInfoFetcher_17.h"

@interface MasterLearningInfoFetcher_17 ()
@property (nonatomic, strong) MasterLearningInfoRequest_17 *infoRequest;
@end
@implementation MasterLearningInfoFetcher_17
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock {
    [self.infoRequest stopRequest];
    MasterLearningInfoRequest_17 *request = [[MasterLearningInfoRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.page = [NSString stringWithFormat:@"%d",self.pageindex + 1];
    request.pageSize = [NSString stringWithFormat:@"%d",self.pagesize];
    request.status = self.status;
    request.barId =  self.barId;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterLearningInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        MasterLearningInfoRequestItem *item = retItem;
    BLOCK_EXEC(self.masterLearningInfoBlock,[self fomartCollectionFilterModel:item.body],item.body);
    BLOCK_EXEC(aCompleteBlock,item.body.xueQing.total.integerValue,item.body.xueQing.learningInfoList,nil);
        
    }];
    self.infoRequest = request;
}
- (NSMutableArray<LSTCollectionFilterDefaultModel *> *)fomartCollectionFilterModel:(id)item {
    MasterLearningInfoRequestItem_Body *body = item;
    NSMutableArray<LSTCollectionFilterDefaultModel *> *modelArray = [[NSMutableArray<LSTCollectionFilterDefaultModel *> alloc] initWithCapacity:2];
    if (body.bars.count > 0) {
        NSMutableArray<LSTCollectionFilterDefaultModelItem *> *barArray = [[NSMutableArray<LSTCollectionFilterDefaultModelItem *> alloc] init];
        [body.bars enumerateObjectsUsingBlock:^(MasterLearningInfoRequestItem_Body_Bars *obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
        
    }
    
    
    //1：未参训，2：已参训，3：未学习，4：已学习，5：未通过，6：已通过，0默认
    NSArray<NSString *> *array = @[@"全部",@"未参训",@"已参训",@"未学习",@"已学习",@"未通过",@"已通过"];
    NSMutableArray<LSTCollectionFilterDefaultModelItem *> *statusArray = [[NSMutableArray<LSTCollectionFilterDefaultModelItem *> alloc] init];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterDefaultModelItem *model = [[LSTCollectionFilterDefaultModelItem alloc] init];
        model.name = obj;
        model.itemID = [NSString stringWithFormat:@"%ld",idx];
        [statusArray addObject:model];
    }];
    LSTCollectionFilterDefaultModel *statusModel = [[LSTCollectionFilterDefaultModel alloc] init];
    statusModel.defaultSelected = @"0";
    statusModel.itemName = @"状态";
    statusModel.item = statusArray;
    [modelArray addObject:statusModel];
    return modelArray;
}
@end
