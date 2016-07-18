//
//  YXUploadHeadImgRequest.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/8/27.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

static NSString *const YXUploadUserPicSuccessNotification = @"kYXUploadUserPicSuccessNotification";

@interface YXUploadHeadImgItem : HttpBaseRequestItem

@property (nonatomic, copy) NSString<Optional> *url;
@property (nonatomic, copy) NSString<Optional> *headDetail;

@end

// 修改头像
@interface YXUploadHeadImgRequest : YXPostRequest

@property (nonatomic, strong) NSString<Optional> *width;  //宽
@property (nonatomic, strong) NSString<Optional> *height; //高
@property (nonatomic, strong) NSString<Optional> *left;   //左坐标
@property (nonatomic, strong) NSString<Optional> *top;    //上坐标
@property (nonatomic, strong) NSString<Optional> *rate;   //原图缩小的比率（1表示原图大小）

@end
