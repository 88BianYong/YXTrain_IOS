//
//  YXHomeworkUploadCompleteView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXHomeworkInfoRequest.h"
@interface YXHomeworkUploadCompleteView : UIView
@property (nonatomic,strong) YXHomeworkInfoRequestItem_Body_Detail *detail;
@property (nonatomic ,copy) void(^buttonActionHandler)(YXRecordVideoInterfaceStatus  type);
@end
