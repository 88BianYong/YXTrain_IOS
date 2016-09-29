//
//  YXRotateListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/9/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol YXRotateListRequestItem_Rotates <NSObject>
@end
@interface YXRotateListRequestItem_Rotates:JSONModel
@property (nonatomic, copy) NSString<Optional> *BaseBeanCreateTime;
@property (nonatomic, copy) NSString<Optional> *begintime;
@property (nonatomic, copy) NSString<Optional> *endtime;
@property (nonatomic, copy) NSString<Optional> *rotateId;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *resurl;
@property (nonatomic, copy) NSString<Optional> *startpageurl;
@property (nonatomic, copy) NSString<Optional> *typelink;
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *seconds;
- (UIImage *)localImage;
- (void)saveImageToDisk:(UIImage *)image;
@end


@interface YXRotateListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<YXRotateListRequestItem_Rotates, Optional> *rotates;
@end
@interface YXRotateListRequest : YXGetRequest
//@property (nonatomic, strong) NSString *type; //1启动图 2轮播图
@end
