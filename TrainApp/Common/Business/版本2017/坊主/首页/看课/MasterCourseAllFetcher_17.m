//
//  MasterCourseAllFetcher_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/4.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterCourseAllFetcher_17.h"
#import "CourseListRequest_17.h"
@interface MasterCourseAllFetcher_17 ()
@property (nonatomic, strong) CourseListRequest_17 *listRequest;
@end

@implementation MasterCourseAllFetcher_17
- (void)startWithBlock:(void (^)(NSInteger, NSArray *, NSError *))aCompleteBlock
{
    [self.listRequest stopRequest];
    CourseListRequest_17 *request = [[CourseListRequest_17 alloc] init];
    request.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.page = [NSString stringWithFormat:@"%d",self.pageindex + 1];
    request.limit = [NSString stringWithFormat:@"%d",self.pagesize];
    request.stageID = self.stageID;
    request.study =  self.study;
    request.segment = self.segment;
    request.type =  self.type;
    request.status = self.status;
    request.themeID =[LSTSharedInstance sharedInstance].trainManager.currentProject.themeId;
    request.layerID = [LSTSharedInstance sharedInstance].trainManager.currentProject.layerId;
    WEAK_SELF
    [request startRequestWithRetClass:[CourseListRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(aCompleteBlock,0,nil,error);
            return;
        }
        CourseListRequest_17Item *item = (CourseListRequest_17Item *)retItem;
        [self fomartCollectionFilterModel:item.searchTerm];
        BLOCK_EXEC(aCompleteBlock,item.count.integerValue,item.objs,nil);
        BLOCK_EXEC(self.masterCourseFilterBlock,[self fomartCollectionFilterModel:item.searchTerm]);
    }];
    self.listRequest = request;
}
- (LSTCollectionFilterModel *)fomartCollectionFilterModel:(id)item {
    CourseListRequest_17Item_SearchTerm *searchTerm = item;
    //顺序：阶段、状态、类型、学段、学科
    LSTCollectionFilterModel_ItemName *studyName = [[LSTCollectionFilterModel_ItemName alloc] init];
    studyName.name = @"学科";
    LSTCollectionFilterModel_ItemName *segmentName = [[LSTCollectionFilterModel_ItemName alloc] init];
    segmentName.name = @"学段";
    segmentName.itemName = studyName;
    LSTCollectionFilterModel_ItemName *typeName = [[LSTCollectionFilterModel_ItemName alloc] init];
    typeName.name = @"类型";
    typeName.itemName = segmentName;
    typeName.defaultSelected = @"0";
    typeName.defaultSelectedID = @"0";
    LSTCollectionFilterModel_ItemName *statusName = [[LSTCollectionFilterModel_ItemName alloc] init];
    statusName.name = @"状态";
    statusName.defaultSelected = @"0";
    statusName.defaultSelectedID = @"0";
    statusName.itemName = typeName;
    LSTCollectionFilterModel_ItemName *stageName = [[LSTCollectionFilterModel_ItemName alloc] init];
    stageName.name = @"阶段";
    stageName.defaultSelected = @"0";
    stageName.defaultSelectedID = @"0";
    stageName.itemName = statusName;

    //学段
    NSMutableArray<LSTCollectionFilterModel_Item> *segmentMutableArray = [[NSMutableArray<LSTCollectionFilterModel_Item> alloc] init];
    NSArray *segmentArray = [searchTerm.segments.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    [segmentArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterModel_Item *item = [[LSTCollectionFilterModel_Item alloc] init];
        item.name = searchTerm.segments[obj];
        item.itemID = obj;
        NSMutableArray<LSTCollectionFilterModel_Item> *studyMutableArray = [[NSMutableArray<LSTCollectionFilterModel_Item> alloc] init];
        NSDictionary *studyDictionary = searchTerm.studys[obj][@"c"];
        NSArray *studyArray = [studyDictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        [studyArray enumerateObjectsUsingBlock:^(NSString *obj1, NSUInteger idx1, BOOL * _Nonnull stop) {
            LSTCollectionFilterModel_Item *item = [[LSTCollectionFilterModel_Item alloc] init];
            item.name = studyDictionary[obj1];
            item.itemID = obj1;
            [studyMutableArray addObject:item];
            if (searchTerm.defaultValue.study.integerValue == obj1.integerValue) {
                studyName.defaultSelected = [NSString stringWithFormat:@"%lu",(unsigned long)idx1];
                studyName.defaultSelectedID = obj1;
            }
        }];
        item.item = studyMutableArray;
        [segmentMutableArray addObject:item];
        if (searchTerm.defaultValue.segment.integerValue == obj.integerValue) {
            segmentName.defaultSelected = [NSString stringWithFormat:@"%lu",(unsigned long)idx];
            segmentName.defaultSelectedID = obj;
        }
    }];
    
    //类型
      NSMutableArray<LSTCollectionFilterModel_Item> *typeMutableArray = [[NSMutableArray<LSTCollectionFilterModel_Item> alloc] init];
    NSArray *typeArray = @[@{@"name":@"全部",@"id":@"0"},@{@"name":@"选修课程",@"id":@"101"},@{@"name":@"必修课程",@"id":@"102"}];
    [typeArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterModel_Item *item = [[LSTCollectionFilterModel_Item alloc] init];
        item.name = obj[@"name"];
        item.itemID = obj[@"id"];
        item.item = segmentMutableArray;
        [typeMutableArray addObject:item];
    }];
    
    //状态
    NSMutableArray<LSTCollectionFilterModel_Item> *statusMutableArray = [[NSMutableArray<LSTCollectionFilterModel_Item> alloc] init];
    NSArray *statusArray = @[@"全部",@"已看",@"未看"];
    [statusArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterModel_Item *item = [[LSTCollectionFilterModel_Item alloc] init];
        item.name = obj;
        item.itemID = [NSString stringWithFormat:@"%lu",(unsigned long)idx];
        item.item = typeMutableArray;
        [statusMutableArray addObject:item];
    }];

    //阶段
    NSMutableArray<LSTCollectionFilterModel_Item> *stageMutableArray = [[NSMutableArray<LSTCollectionFilterModel_Item> alloc] init];
    [searchTerm.stages enumerateObjectsUsingBlock:^(CourseListRequest_17Item_SearchTerm_Stage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterModel_Item *item = [[LSTCollectionFilterModel_Item alloc] init];
        item.name = obj.stageName;
        item.itemID = obj.stageID;
        item.item = statusMutableArray;
        [stageMutableArray addObject:item];
    }];
    LSTCollectionFilterModel_Item *stageItem = [[LSTCollectionFilterModel_Item alloc] init];
    stageItem.name = @"全部";
    stageItem.itemID = @"0";
    stageItem.item = statusMutableArray;
    [stageMutableArray insertObject:stageItem atIndex:0];
    LSTCollectionFilterModel *model = [[LSTCollectionFilterModel alloc] init];
    model.itemName = stageName;
    model.item = stageMutableArray;
    return model;
}
@end
