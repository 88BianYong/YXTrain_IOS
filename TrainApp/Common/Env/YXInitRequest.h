//
//  YXInitRequest.h
//  YanXiuApp
//
//  Created by Lei Cai on 6/1/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

extern NSString *const YXInitSuccessNotification;

@interface YXInitRequestItem_Property : JSONModel

@property (nonatomic, copy) NSString<Optional> *isAppleChecking; //苹果审核

@end

@interface YXInitRequestItem_Body : JSONModel

@property (nonatomic, copy) NSString<Optional> *iid;          //啥玩意儿？
@property (nonatomic, copy) NSString<Optional> *version;      //新版本号
@property (nonatomic, copy) NSString<Optional> *title;        //升级提示标题
@property (nonatomic, copy) NSString<Optional> *resid;        //
@property (nonatomic, copy) NSString<Optional> *ostype;       //操作系统类型
@property (nonatomic, copy) NSString<Optional> *upgradetype;  //升级类型（1：强制升级，2：不限制）
@property (nonatomic, copy) NSString<Optional> *upgradeswitch;//是否开始升级（0：关闭升级，1：开始升级）
@property (nonatomic, copy) NSString<Optional> *targetenv;    //0正式，1测试
@property (nonatomic, copy) NSString<Optional> *uploadtime;   //版本上传时间
@property (nonatomic, copy) NSString<Optional> *modifytime;   //版本修改时间
@property (nonatomic, copy) NSString<Optional> *content;      //升级内容说明
@property (nonatomic, copy) NSString<Optional> *fileURL;      //app下载地址
@property (nonatomic, copy) NSString<Optional> *fileLocalPath;//
@property (nonatomic, copy) NSString<Optional> *versionStr;   //版本号
@property (nonatomic, copy) NSString<Optional> *productName;  //产品名称

// 是否为测试环境
- (BOOL)isTest;
// 是否强制升级
- (BOOL)isForce;

@end

@protocol YXInitRequestItem_Body @end
@interface YXInitRequestItem : HttpBaseRequestItem

@property (nonatomic, copy) YXInitRequestItem_Property<Optional> *property;
@property (nonatomic, copy) NSArray<YXInitRequestItem_Body, Optional> *body;

@end

@interface YXInitRequest : GetRequest

@property (nonatomic, strong) NSString<Optional> *did;        //设备编号
@property (nonatomic, strong) NSString<Optional> *brand;      //手机品牌
@property (nonatomic, strong) NSString<Optional> *nettype;    //网络类型，0:mobile，1:wifi
@property (nonatomic, strong) NSString<Optional> *osType;     //操作系统类型，0:Android，1:IOS，100:Others
@property (nonatomic, strong) NSString<Optional> *appVersion; //当前使用的应用的版本号
@property (nonatomic, strong) NSString<Optional> *content;    //上报log的内容，可定义富文本
@property (nonatomic, strong) NSString<Optional> *operType;   //操作类型，以自行定义标示
@property (nonatomic, strong) NSString<Optional> *phone;      //手机号码
@property (nonatomic, strong) NSString<Optional> *remoteIp;   //客户端IP
@property (nonatomic, strong) NSString<Optional> *mode;       //正式环境、测试环境
@property (nonatomic, strong) NSString<Optional> *token;

@end

@interface YXInitHelper : NSObject
@property (nonatomic, strong) YXInitRequestItem *item;
@property (nonatomic, assign) BOOL isShowUpgrade;//
@property (nonatomic, assign) BOOL showUpgradeFlag;//显示项目切换引导页时用来判断

+ (instancetype)sharedHelper;

- (void)requestCompeletion:(void(^)(BOOL))completion;
- (void)requestLoginCompeletion:(void (^)(YXInitRequestItem *, NSError *))completion;
- (BOOL)isAppleChecking;
- (void)showNoRestraintUpgrade;

@end
