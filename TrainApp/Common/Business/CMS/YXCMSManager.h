//
//  YXCMSManager.h
//  TrainApp
//
//  Created by 郑小龙 on 16/9/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXRotateListRequest.h"
@interface YXCMSModel : JSONModel
@property (nonatomic, assign) YXHotspotType type;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *resurl;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *topicId;

- (UIImage *)localImage;
- (void)saveImageToDisk:(UIImage *)image;

+ (instancetype)modelWithItem:(YXRotateListRequestItem_Rotates *)item;

@end

@interface YXCMSManager : NSObject

+ (instancetype)sharedManager;

///type:1启动图 2轮播图
- (void)requestWithType:(NSString *)type
             completion:(void(^)(NSArray *rotates, NSError *error))completion;

#pragma mark - mock data

+ (YXCMSModel *)mockData;

@end
