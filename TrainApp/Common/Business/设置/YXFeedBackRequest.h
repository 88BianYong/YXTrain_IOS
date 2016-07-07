//
//  YXFeedbackRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"
@interface YXFeedBackRequestItem : HttpBaseRequestItem

@end
@interface YXFeedBackRequest : YXPostRequest
@property (nonatomic, strong) NSString *sysver;     //系统版本号
@property (nonatomic, strong) NSString *feedtype;   //0:视频播放卡顿，1:页面加载失败，2:闪退，3:界面错位，4:其他
@property (nonatomic, strong) NSString *content;    //描述内容
@property (nonatomic, strong) NSString<Optional> *phonenumber;//用户手机号
@end
