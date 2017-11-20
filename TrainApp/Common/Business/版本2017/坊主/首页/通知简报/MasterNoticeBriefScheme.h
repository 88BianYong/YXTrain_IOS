//
//  MasterNoticeBriefScheme.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol MasterNoticeBriefItem @end
@interface MasterNoticeBriefItem : JSONModel
@property (nonatomic, copy) NSString<Optional> *nbId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *time;
@property (nonatomic, copy) NSString<Optional> *readNum;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *projectId;
@end

@interface MasterNoticeBriefScheme : JSONModel
@property (nonatomic, copy) NSString<Optional> *typecode;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *amount;
@property (nonatomic, copy) NSString<Optional> *score;
@property (nonatomic, copy) NSString<Optional> *descripe;
@property (nonatomic, copy) NSString<Optional> *userscore;
@property (nonatomic, copy) NSString<Optional> *userfinishnum;
@end
