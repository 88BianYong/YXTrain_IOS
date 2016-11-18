//
//  YXDatumCellModel.h
//  YanXiuApp
//
//  Created by niuzhaowang on 15/8/28.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDownloader.h"
#import "YXDatumSearchRequest.h"
#import "YXMyDatumRequest.h"
#import "ShareResourcesRequest.h"
extern NSString *const YXFavorSuccessNotification;
@interface YXDatumCellModel : NSObject
@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) unsigned long long size;
@property (nonatomic, assign) BOOL isFavor;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *previewUrl;//资源预览的预览和下载分两个url
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *type;
// 下载
@property (nonatomic, assign) unsigned long long downloadedSize;
@property (nonatomic, assign) DownloaderState downloadState;

@property (nonatomic, strong) YXDatumSearchRequestItem_data *rawData;
+ (YXDatumCellModel *)modelFromSearchRequestItemData:(YXDatumSearchRequestItem_data *)data;
+ (YXDatumCellModel *)modelFromMyDatumRequestResultList:(YXMyDatumRequestItem_result_list *)list;
+ (YXDatumCellModel *)modelFromShareResourceRequestItemBodyResource:(ShareResourcesRequestItem_body_resource *)resource;
@end
