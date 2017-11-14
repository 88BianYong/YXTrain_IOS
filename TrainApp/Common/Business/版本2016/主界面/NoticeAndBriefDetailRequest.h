//
//  NoticeAndBriefDetailRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol NoticeAndBriefDetailRequestItem_Body_Affix
@end
@interface NoticeAndBriefDetailRequestItem_Body_Affix : JSONModel
@property (nonatomic, copy) NSString<Optional> *convertstatus;
@property (nonatomic, copy) NSString<Optional> *downloadurl;
@property (nonatomic, copy) NSString<Optional> *previewurl;
@property (nonatomic, copy) NSString<Optional> *res_type;
@property (nonatomic, copy) NSString<Optional> *resid;
@property (nonatomic, copy) NSString<Optional> *resSize;
@property (nonatomic, copy) NSString<Optional> *resSizeFormat;
@property (nonatomic, copy) NSString<Optional> *resname;
@end

@interface NoticeAndBriefDetailRequestItem_Body : JSONModel
@property (nonatomic, strong) NSArray<NoticeAndBriefDetailRequestItem_Body_Affix, Optional>*affix;
@property (nonatomic, copy) NSString<Optional> *barID;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *groupids;
@property (nonatomic, copy) NSString<Optional> *nbID;
@property (nonatomic, copy) NSString<Optional> *isEdit;
@property (nonatomic, copy) NSString<Optional> *isRecommend;
@property (nonatomic, copy) NSString<Optional> *readNum;
@property (nonatomic, copy) NSString<Optional> *time;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *userID;
@end

@interface NoticeAndBriefDetailRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NoticeAndBriefDetailRequestItem_Body<Optional>*body;
@end

@interface NoticeAndBriefDetailRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *nbID;


@end
