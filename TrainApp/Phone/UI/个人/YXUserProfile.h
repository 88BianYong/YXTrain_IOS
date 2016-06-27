//
//  YXUserProfile.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/9/7.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "JSONModel.h"

@interface YXUserProfile : JSONModel

@property (nonatomic, copy) NSString<Optional> *uid;         //用户id
@property (nonatomic, copy) NSString<Optional> *name;        //用户名（返回昵称）
@property (nonatomic, copy) NSString<Optional> *nickName;    //用户昵称
@property (nonatomic, copy) NSString<Optional> *realName;    //用户真实名
@property (nonatomic, copy) NSString<Optional> *area;        //用户所在地（省市区县）
@property (nonatomic, copy) NSString<Optional> *authentica;  //是否认证
@property (nonatomic, copy) NSString<Optional> *fans;        //粉丝数
@property (nonatomic, copy) NSString<Optional> *gender;      //性别
@property (nonatomic, copy) NSString<Optional> *groups;      //加入组数
@property (nonatomic, copy) NSString<Optional> *head;        //头像链接地址
@property (nonatomic, copy) NSString<Optional> *position;    //职位
@property (nonatomic, copy) NSString<Optional> *school;      //学校
@property (nonatomic, copy) NSString<Optional> *schoolId;    //学校id
@property (nonatomic, copy) NSString<Optional> *stage;       //学段
@property (nonatomic, copy) NSString<Optional> *stageId;     //学段id
@property (nonatomic, copy) NSString<Optional> *subject;     //学科
@property (nonatomic, copy) NSString<Optional> *subjectId;   //学科id
@property (nonatomic, copy) NSString<Optional> *province;    //省份
@property (nonatomic, copy) NSString<Optional> *provinceId;  //省份id
@property (nonatomic, copy) NSString<Optional> *city;        //市
@property (nonatomic, copy) NSString<Optional> *cityId;      //市id
@property (nonatomic, copy) NSString<Optional> *region;      //区县
@property (nonatomic, copy) NSString<Optional> *regionId;    //区县id

//1.5
@property (nonatomic, copy) NSString<Optional> *headDetail;    //大头像

//1.7
@property (nonatomic, copy) NSString<Optional> *vipType;
@property (nonatomic, copy) NSString<Optional> *type;

//- (YXUserIdentityType)userIdentityType;
@end
