//
//  YXTrainConst.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
#define kScreenHeightScale(f) [UIScreen mainScreen].bounds.size.height / 667.0f * f
#define kScreenWidthScale(f) [UIScreen mainScreen].bounds.size.width / 375.0f * f

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width



#define PATH_OF_DOCUMENT         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_OF_VIDEO   [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"VideoRecord"]
#define PATH_OF_VIDEO_CACHE [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"VideoCache"]
#define kVideoUserDefaultsKey @"kVideoUserDefaultsKey"

typedef NS_ENUM (NSInteger, YXVideoRecordStatus) {
    YXVideoRecordStatus_Ready = 0,
    YXVideoRecordStatus_Recording = 1,
    YXVideoRecordStatus_Pause = 2,
    YXVideoRecordStatus_Stop = 3,
    YXVideoRecordStatus_StopMax = 4,
    YXVideoRecordStatus_Save = 5,
    YXVideoRecordStatus_Delete = 6,
};//录制视频状态

typedef NS_ENUM (NSInteger, YXVideoLessonStatus) {
    YXVideoLessonStatus_NoRecord = 0, //未录制
    YXVideoLessonStatus_AlreadyRecord = 1, //已经录制未上传 未创建作业
    YXVideoLessonStatus_Uploading = 2,//上传中 已经创建作业
    YXVideoLessonStatus_UploadPause = 3, //暂停上传。
    YXVideoLessonStatus_UploadComplete = 4, //上传完成。
};


extern const CGFloat YXTrainCornerRadii;
