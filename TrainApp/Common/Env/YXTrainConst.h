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
#define IS_IPHONE_6P ( fabs( ( double )[ [UIScreen mainScreen] bounds ].size.height - ( double )736 ) < DBL_EPSILON )
#define IS_IPHONE_6  ( fabs( ( double )[ [UIScreen mainScreen] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_5  ( fabs( ( double )[ [UIScreen mainScreen] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_4  ( fabs( ( double )[ [UIScreen mainScreen] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

//视频
#define PATH_OF_DOCUMENT         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_OF_VIDEO   [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"VideoRecord"]
#define PATH_OF_VIDEO_CACHE [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"VideoCache"]
#define PATH_OF_VIDEO_RECORD [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"VideoRecordCache"]


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

//定义key值
/*
 *  播放过片头的课程ID
 */
extern NSString *const kXYTrainChooseProject;
/**
 *  是否第一次进入APP
 */
extern NSString *const kYXTrainFirstLaunch;
/**
 *  是否第一次进入作业界面
 */
extern NSString *const kYXTrainFirstGoInHomeworkList;
/**
 *  是否第一次进入作业界面_17
 */
extern NSString *const kYXTrainFirstGoInHomeworkList_17;
/**
 *  北京项目是否当前账户初次登录
 */
extern NSString *const kYXTrainFirstGoInHomeworkInfo;
/**
 *   push or websocket发送消息
 */
extern NSString *const kYXTrainPushWebSocketReceiveMessage;
/**
 *  视频作业保存
 */
extern NSString *const kYXTrainVideoUserDefaultsKey;
/**
 *  获取学科学段和地区的时间
 */
extern NSString *const kYXTrainGetInfoListTime;
/**
 *  消息动态任务到期提醒
 */
extern NSString *const kYXTrainCurrentProjectIndex;
/**
 *  根据项目列表判断是否显示消息动态
 */
extern NSString *const kYXTrainListDynamic;
/**
 *  显示更新view
 */
extern NSString *const kYXTrainShowUpdate;
/**
 *  北京项目校验信息删除填写信息
 */
extern NSString *const kYXTrainDeleteInfo;
/**
 *  用户身份切换
 */
extern NSString *const kYXTrainUserIdentityChange;
/**
 *  是否显示角色切换界面
 */
extern NSString *const kYXTrainFirstRoleChange;
/**
 *  扫码登录
 */
extern NSString *const kYXTrainScanCodeEntry;
/**
 *  显示学员不参与考核提示
 */
extern NSString *const kYXTrainContainsTeacher;

/**
 *  显示左滑提醒学习
 */
extern NSString *const kYXTrainRemindLeftSlip;

/**
 *  提交随堂练答案
 */
extern NSString *const kYXTrainSubmitQuestionAnswer;
/**
 *  接收到推送通知dismiss界面
 */
extern NSString *const kYXTrainPushNotification;
//2.4.3
/*
*  显示二维码扫描提示
*/
extern NSString *const kYXTrainQRCodePrompt;
/*
 *  开始加载文档与关闭
 */
extern NSString *const kYXTrainStartStopVideo;

/*
 *  播放过片头的课程ID
 */
extern NSString *const kYXTrainPlayBeginningCourse;

//2.5.0

/*
 *  显示查看学习成绩
 */
extern NSString *const kYXTrainAcademicPerformance;
/*
 *  显示查看通知简报
 */
extern NSString *const kYXTrainNoticeBriefing;
/*
 *  显示完成培训学习方法
 */
extern NSString *const kYXTrainCompleteTrainingMethod;
/*
 *  参加活动
 */
extern NSString *const kYXTrainParticipateActivity;
/*
 *  完成课程
 */
extern NSString *const kYXTrainCompleteCourse;
/*
 *  播放课程界面显示和覆盖
 */
extern NSString *const kYXTrainPlayCourseNext;







/**
 *  左划宽度 按屏幕750
 */
extern const CGFloat YXTrainLeftDrawerWidth;
/**
 *  圆角
 */
extern const CGFloat YXTrainCornerRadii;
/**
 *  广告页启动时间
 */
extern const NSInteger YXTrainCornerStartpageTime;
/**
 *  视频说明
 */
extern NSString *const YXTrainUploadDepictionString;
/**
 *  北京项目ID
 */
extern NSString *const YXTrainBeijingProjectId;
/**
 *  德阳项目ID
 */
extern NSString *const YXTrainDeYangProjectId;
/**
 *  定义特殊标记,表示已完成一个课程或者已参加一个活动
 */
extern NSString *const YXTrainSpecialCourseActivity;
/**
 *  需要暂停播放
 */
extern const BOOL YXTrainCourseVideoPause;
/**
 *  需要播放播放
 */
extern const BOOL YXTrainCourseVideoPlay;



