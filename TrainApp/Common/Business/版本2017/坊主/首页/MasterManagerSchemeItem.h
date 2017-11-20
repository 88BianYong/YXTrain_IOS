//
//  MasterManagerSchemeItem.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol MasterManagerSchemeItem @end
@interface MasterManagerSchemeItem : JSONModel
@property (nonatomic, copy) NSString<Optional> *typecode;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *amount;
@property (nonatomic, copy) NSString<Optional> *score;
@property (nonatomic, copy) NSString<Optional> *descripe;
@property (nonatomic, copy) NSString<Optional> *userscore;
@property (nonatomic, copy) NSString<Optional> *userfinishnum;
@property (nonatomic, copy) NSString<Optional> *isfinish;
@end
