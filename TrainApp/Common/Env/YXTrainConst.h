//
//  YXTrainConst.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
//屏幕
#define kScreenHeightScale(f) [UIScreen mainScreen].bounds.size.height / 667.0f * f
#define kScreenWidthScale(f) [UIScreen mainScreen].bounds.size.width / 375.0f * f
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define IS_IPHONE_6P ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

//视频
#define PATH_OF_DOCUMENT         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_OF_VIDEO   [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"VideoRecord"]
#define PATH_OF_VIDEO_CACHE [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"VideoCache"]
#define kVideoUserDefaultsKey @"kVideoUserDefaultsKey"

#define kGetInfoListTime @"get_Info_List_time"//获取学科学段地区列表


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
    YXVideoLessonStatus_Finish = -1,//作业完成 本地没有视频
    YXVideoLessonStatus_NoRecord = 0, //未录制
    YXVideoLessonStatus_AlreadyRecord = 1, //已经录制未上传 未创建作业
    YXVideoLessonStatus_Uploading = 2,//上传中 已经创建作业 暂不用
    YXVideoLessonStatus_UploadPause = 3, //暂停上传。  暂不用
    YXVideoLessonStatus_UploadComplete = 4, //上传完成。
};


typedef NS_ENUM (NSInteger, YXRecordVideoInterfaceStatus) {
    YXRecordVideoInterfaceStatus_Record = 1, //录制 YXVideoRecordViewController
    YXRecordVideoInterfaceStatus_Depiction = 2, //说明 YXUploadDepictionViewController
    YXRecordVideoInterfaceStatus_Write = 3,// 填写 YXWriteHomeworkInfoViewController
    YXRecordVideoInterfaceStatus_Play = 4,//播放   YXPlayerViewController
    YXRecordVideoInterfaceStatus_Change = 5,//修改 YXWriteHomeworkInfoViewController
    
};

typedef NS_ENUM (NSInteger ,YXWriteHomeworkListStatus) {
    YXWriteHomeworkListStatus_Title = -1,//标题
    YXWriteHomeworkListStatus_SchoolSection = 0,//学段
    YXWriteHomeworkListStatus_Subject = 1,//学科
    YXWriteHomeworkListStatus_Version = 2,//版本
    YXWriteHomeworkListStatus_Grade = 3,//书册
    YXWriteHomeworkListStatus_Menu = 4,//目录
    YXWriteHomeworkListStatus_Topic = 5,//重难点题目
};

extern const CGFloat YXTrainLeftDrawerWidth;

extern const CGFloat YXTrainCornerRadii;

extern const NSInteger YXTrainCornerStartpageTime;

extern NSString *const YXTrainUploadDepictionString;

extern NSString *const YXTrainFirstGoInHomeworkList;
