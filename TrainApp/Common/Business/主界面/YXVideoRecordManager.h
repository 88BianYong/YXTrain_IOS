//
//  YXVideoRecordManager.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YXHomeworkInfoRequestItem_Body;

@interface YXVideoRecordManager : NSObject

+ (instancetype)sharedInstance;

+ (BOOL)isEnoughDeviceSpace;

+ (BOOL)isSupportRecordVideoShowView:(UIView *)view;

//保存录像信息。
+ (void)saveVideoArrayWithModel:(YXHomeworkInfoRequestItem_Body *)model;

//获取录像信息
+ (NSArray *)getVideoArrayWithModel;

//删除一个录像信息。
+ (void)deleteVideoWithModel:(YXHomeworkInfoRequestItem_Body *)model;

//清空录像信息
+ (void)clearVideoArray;

+ (void)cleartmpFile;

+ (NSString *)getFileNameWithJobId:(NSString *)jojid;


/* 设备可用容量 */
+ (NSNumber *)freeSpace;

/* 设备总容量 */
+ (NSNumber *)totalSpace;

@end
