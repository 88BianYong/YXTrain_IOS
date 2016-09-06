//
//  YXRotateListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/9/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

typedef NS_ENUM(NSInteger, YXHotspotType) {
    YXHotspotTypeTraining = 1,    //国培
    YXHotspotTypeOutLink,         //外跳
    YXHotspotTypeInnerLink,       //内跳（H5）
    YXHotspotTypeTopic,           //话题详情
    YXHotspotTypePersonalHomepage //个人主页
};

@protocol YXRotateListRequestItem_Rotates <NSObject>

@end
@interface YXRotateListRequestItem_Rotates:JSONModel
@property (nonatomic, copy) NSString<Optional> *pid;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *pic; //焦点图片地址
@property (nonatomic, copy) NSString<Optional> *w;
@property (nonatomic, copy) NSString<Optional> *status; //结束状态，1：进行中，0：已结束

//V1.6新加字段
@property (nonatomic, copy) NSString<Optional> *resurl;//链接地址
@property (nonatomic, copy) NSString<Optional> *type;  //轮播种类：1.国培，2.外跳，3.内跳，4.话题，5.个人主页
@property (nonatomic, copy) NSString<Optional> *context;//其他信息

//V1.7
@property (nonatomic, copy) NSString<Optional> *begintime;
@property (nonatomic, copy) NSString<Optional> *endtime;
@property (nonatomic, copy) NSString<Optional> *uid; //个人id
@property (nonatomic, copy) NSString<Optional> *productline;


- (BOOL)isFinished;
@end



@interface YXRotateListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<YXRotateListRequestItem_Rotates, Optional> *rotates;
@end
@interface YXRotateListRequest : YXGetRequest
@property (nonatomic, strong) NSString *type; //1启动图 2轮播图
@end
