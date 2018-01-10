//
//  PushContentModel.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@interface PushContentModelItem : JSONModel
@property (nonatomic, copy) NSString<Optional> *baseUrl;

@end
@interface PushContentModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *projectId; //备用
@property (nonatomic, copy) NSString<Optional> *module; //模块   1消息动态  2热点
@property (nonatomic, copy) NSString<Optional> *type; //消息类型
//0通用类型
//消息动态：1-通知  2-简报  3-打分  4-推优  5-任务到期提醒   6-坊主提醒
@property (nonatomic, copy) NSString<Optional> *objectId;//备用，具体的业务id
@property (nonatomic, copy) NSString<Optional> *msg;    //显示的内容
@property (nonatomic, copy) NSString<Optional> *title; //备用
@property (nonatomic, strong) PushContentModelItem<Optional> *extendInfo;
@end
