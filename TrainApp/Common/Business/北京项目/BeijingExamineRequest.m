//
//  BeijingExamineRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/1.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingExamineRequest.h"
@implementation BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList
@end
@implementation BeijingExamineRequestItem_ExamineVoList
- (NSMutableArray<BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList,Optional> *)toolExamineVoList {//TD: 12-08 产品要求写死,按产品设计 技术素养->专题->综合->专业发展->案例 排序 诡异这需求居然前端做
    _toolExamineVoList = (NSMutableArray<BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList,Optional> *)[NSMutableArray arrayWithArray:[_toolExamineVoList sortedArrayUsingComparator:
                           ^(BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *obj1, BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *obj2){
                               if(obj1.toolid.integerValue < obj2.toolid.integerValue) {
                                   return(NSComparisonResult)NSOrderedAscending;
                               }else {
                                   return(NSComparisonResult)NSOrderedDescending;
                               }
                           }]];
    for (int i = 0; i < _toolExamineVoList.count; i ++) {
        BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *tool = _toolExamineVoList[i];
        if (tool.toolid.integerValue == 2179) {
            tool.name = @"专业发展类";
        }
    }
    if (_toolExamineVoList.count >= 5){
        [_toolExamineVoList exchangeObjectAtIndex:1 withObjectAtIndex:2];
    }
//
//    if ([self formatToolExamineVoList]) {
//        [_toolExamineVoList exchangeObjectAtIndex:1 withObjectAtIndex:2];
//
//    }
//
//    
    return _toolExamineVoList;
}
- (BOOL)formatToolExamineVoList {
    if (_toolExamineVoList.count >= 5) {
        BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *tool1 = _toolExamineVoList[1];
        BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *tool2 = _toolExamineVoList[2];
        if (tool1.toolid.integerValue < tool2.toolid.integerValue) {
            return YES;
        }
    }
    return NO;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"examineVoID"}];
}
@end
@implementation BeijingExamineRequestItem
- (NSArray<BeijingExamineRequestItem_ExamineVoList,Optional> *)examineVoList {//TD: 12-08 产品要求写死,按产品设计 课程->活动->作业->校本实践   因产品确定ID不会改变所以按工具ID小->大排序
    return (NSArray<BeijingExamineRequestItem_ExamineVoList,Optional> *)
    [_examineVoList sortedArrayUsingComparator:
     ^(BeijingExamineRequestItem_ExamineVoList *obj1, BeijingExamineRequestItem_ExamineVoList *obj2){
         if(obj1.examineVoID.integerValue < obj2.examineVoID.integerValue) {
             return(NSComparisonResult)NSOrderedAscending;
         }else {
             return(NSComparisonResult)NSOrderedDescending;
         }
     }];
}
@end
@implementation BeijingExamineRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"peixun/bj/examine"];
    }
    return self;
}

@end
