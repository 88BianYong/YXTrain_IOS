//
//  ActivityListDetailModel.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityListRequest.h"
#import "ActivityStepListRequest.h"
@interface ActivityListDetailModel : NSObject
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *isJoin;//是否参与  0：未参与  1：已参与
@property (nonatomic, copy) NSString *createUsername;
@property (nonatomic, copy) NSString *studyName;
@property (nonatomic, copy) NSString *segmentName;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *status;//0=未开始;2=进行中;3=已完成;4=阶段关闭;-1=关闭;-2=草稿;-5=删除
@property (nonatomic, copy) NSString *source;//活动来源 club或train->研修网;zgjiaoyan->教研网
@property (nonatomic, copy) NSString *joinUserCount;
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, strong) NSMutableArray<__kindof ActivityStepListRequestItem_Body_Active_Steps *> *steps;
//活动详情model转换
+ (ActivityListDetailModel *)modelFromActivityDetailData:(ActivityStepListRequestItem_body_Active *)item ;

//活动详情添加列表数据
- (ActivityListDetailModel *)modelFromActivityListData:(ActivityListRequestItem_body_activity *)item;


@end
