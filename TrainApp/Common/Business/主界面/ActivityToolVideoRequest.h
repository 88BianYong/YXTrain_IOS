//
//  ActivityToolVideoRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol ActivityToolVideoRequestItem_Body_Content <NSObject>
@end

@interface ActivityToolVideoRequestItem_Body_Content : JSONModel
@property (nonatomic, copy) NSString<Optional> *resid;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *resname;
@property (nonatomic, copy) NSString<Optional> *createUsername;
@property (nonatomic, copy) NSString<Optional> *publishTime;
@property (nonatomic, copy) NSString<Optional> *convertstatus;
@property (nonatomic, copy) NSString<Optional> *previewurl;
@property (nonatomic, copy) NSString<Optional> *downloadurl;
@property (nonatomic, copy) NSString<Optional> *res_type;
@property (nonatomic, copy) NSString<Optional> *res_size;
@end

@interface ActivityToolVideoRequestItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *tool;
@property (nonatomic, copy) NSString<Optional> *toolid;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *topicid;
@property (nonatomic, copy) NSString<Optional> *tooltype;
@property (nonatomic, strong) NSArray<ActivityToolVideoRequestItem_Body_Content,Optional> *content;
- (ActivityToolVideoRequestItem_Body_Content *)formatToolVideo;
- (ActivityToolVideoRequestItem_Body_Content *)formatToolEnclosure;
@end

@interface ActivityToolVideoRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ActivityToolVideoRequestItem_Body<Optional> *body;
@end

@interface ActivityToolVideoRequest : YXGetRequest
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *toolId;
@property (nonatomic, copy) NSString *w;
@end
