//
//  YXTrainConst.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifdef TianjinApp
NSString *const YXTrainWechatName = @"zgjsyxw";
NSString *const YXTrainServiceTelephone = @"400-7799-010";
NSString *const YXTrainProtocolAddress= @"http://www.yanxiu.com/common/agreement.html";
NSString *const YXTrainShowAPPName = @"心里教师";
NSString *const YXTrainURLSchemes = @"com.yanxiu.tianjin";
#else
NSString *const YXTrainWechatName = @"zgjsyxw";
NSString *const YXTrainServiceTelephone = @"400-7799-010";
NSString *const YXTrainProtocolAddress= @"http://www.yanxiu.com/common/agreement.html";
NSString *const YXTrainShowAPPName= @"手机研修";
NSString *const YXTrainURLSchemes = @"com.yanxiu.lst";
#endif


const CGFloat YXTrainLeftDrawerWidth = 600.0f;

const CGFloat YXTrainCornerRadii = 2.0f;

const NSInteger YXTrainCornerStartpageTime = 3;

const BOOL YXTrainCourseVideoPause = YES;

const BOOL YXTrainCourseVideoPlay = NO;

NSString *const YXTrainSpecialCourseActivity = @"special course and activity";
NSString *const YXTrainBeijingProjectId = @"1639";
NSString *const YXTrainDeYangProjectId =  @"2286,2287,2288";
NSString *const YXTrainUploadDepictionString = @"1.视频时间控制在15-40分钟，建议上传最能体现信息技术应用的视频课例片段\n2.视频主要是记录应用信息技术的过程和设计思想，设备薄弱地区的参训教师可用手机进行拍摄\n3.每位教师都必须上传视频\n4.视频格式建议为MP4，分辨率在720*576左右（考虑到清晰度和文件大小，其他格式的视频，如AVI、MPEG、WMV等，请转换为MP4格式再上传）\n5.单个视频文件的大小建议在600M以内（600M以内的视频文件，上传后可直接在线观看；600M以上的视频文件，只可下载观看，不能在线播放）\n6.上传的视频资源应为原创，符合国家知识产权、著作权及网络安全等相关法律法规，上传者为相应资源的开发主体，拥有相应的知识产权和所有权\n7.上传者享有成果的著作权，须同意授权中国教师研修网和区域教育行政部门享有网络传播权\n8.优秀作品将在中国教师研修网信息技术应用竞品成果展示专区进行展示交流，并获得相应的荣誉证书";

NSString *const kXYTrainChooseProject =  @"train list choose project";

NSString *const kXYTrainChangeProject =  @"train list change project";

NSString *const kYXTrainFirstLaunch = @"the first to enter the TrainApp";

NSString *const kYXTrainFirstGoInHomeworkList = @"the first to enter the work list interface";
NSString *const kYXTrainFirstGoInHomeworkList_17 = @"the first to enter the work list interface 17";

NSString *const kYXTrainFirstGoInHomeworkInfo = @"the first to enter the homework info interface";

NSString *const kYXTrainPushWebSocketReceiveMessage = @"the push or websocket receive message for hotspot and dynamic";

NSString *const kYXTrainVideoUserDefaultsKey = @"kVideoUserDefaultsKey";

NSString *const kYXTrainGetInfoListTime = @"get_Info_List_time";

NSString *const kYXTrainCurrentProjectIndex = @"project transition jump";

NSString *const kYXTrainListDynamic = @"according to the list of items to determine whether the message is displayed dynamic";

NSString *const kYXTrainShowUpdate = @"show optional update interface";

NSString *const kYXTrainDeleteInfo = @"bei jing project delete all information";

NSString *const kYXTrainUserIdentityChange = @"user change identity master or student";

NSString *const kYXTrainFirstRoleChange = @"the first show role view";

NSString *const kYXTrainScanCodeEntry = @"Scan code entry";

NSString *const kYXTrainContainsTeacher = @"contains teacher not involved in the assessment";

NSString *const kYXTrainRemindLeftSlip = @"Show left sliding reminder learning";

NSString *const kYXTrainSubmitQuestionAnswer = @"submit video question answer";

NSString *const kYXTrainPushNotification = @"push Notification dismiss view controller";

NSString *const kYXTrainQRCodePrompt = @"Show QR code prompt view";

NSString *const kYXTrainStartStopVideo = @"The document is loaded and stopped";

NSString *const kYXTrainPlayBeginningCourse = @"Play beginning Course Id";

NSString *const kYXTrainAcademicPerformance = @"examine academic performance";

NSString *const kYXTrainNoticeBriefing = @"examine notification briefing";

NSString *const kYXTrainCompleteTrainingMethod = @"complete the training method";

NSString *const kYXTrainParticipateActivity = @"participate in activities";

NSString *const kYXTrainCompleteCourse = @"complete the course";

NSString *const kYXTrainPlayCourseNext = @"Play the course interface to show and overwrite";

NSString *const kYXTrainDocumentRetryTimer = @"Used to watch documents in video playback to increase video start time";

NSString *const kYXTrainRefreshHomeworkList = @"Refresh homework list for comment recomend";

NSString *const kYXTrainRefreshHomeworkSet = @"Refresh master homework set";

NSString *const kYXTrainReadingClassRecordsCleared = @"DeYang Reading class records cleared";

NSString *const kYXTrainAccountNumber = @"Store the login account";


NSString *const kYXTrainChoosePid = @"Manual choose pid";

