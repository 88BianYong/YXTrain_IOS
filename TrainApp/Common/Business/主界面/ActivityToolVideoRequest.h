//
//  ActivityToolVideoRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface ActivityToolVideoRequestItem_Body : JSONModel
@property (nonatomic, copy) NSString *tool;
@property (nonatomic, copy) NSString *toolid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *topicid;
@property (nonatomic, copy) NSString *tooltype;
@end

@interface ActivityToolVideoRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ActivityToolVideoRequestItem_Body *body;
@end

@interface ActivityToolVideoRequest : YXGetRequest
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *toolId;
@end
