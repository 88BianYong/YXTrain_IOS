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
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"examineVoID"}];
}
@end
@implementation BeijingExamineRequestItem
- (NSArray<BeijingExamineRequestItem_ExamineVoList,Optional> *)examineVoList {
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
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"peixun/bj/examine"];
    }
    return self;
}

@end
