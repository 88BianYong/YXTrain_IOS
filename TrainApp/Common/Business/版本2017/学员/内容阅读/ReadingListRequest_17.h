//
//  ReadingListRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface ReadingListRequest_17Item_Scheme_Scheme : JSONModel
@property (nonatomic, copy) NSString<Optional> *toolID;
@property (nonatomic, copy) NSString<Optional> *finishNum;
@property (nonatomic, copy) NSString<Optional> *finishScore;
@property (nonatomic, copy) NSString<Optional> *type;
@end

@interface ReadingListRequest_17Item_Scheme_Process : JSONModel
@property (nonatomic, copy) NSString<Optional> *userFinishNum;
@property (nonatomic, copy) NSString<Optional> *userFinishScore;
@end

@interface ReadingListRequest_17Item_Scheme : JSONModel
@property (nonatomic, strong) ReadingListRequest_17Item_Scheme_Scheme *scheme;
@property (nonatomic, strong) ReadingListRequest_17Item_Scheme_Process *process;
@end
@interface ReadingListRequest_17Item_Objs_Affix : JSONModel
@property (nonatomic, copy) NSString<Optional> *resID;
@property (nonatomic, copy) NSString<Optional> *res_type;
@property (nonatomic, copy) NSString<Optional> *resName;
@property (nonatomic, copy) NSString<Optional> *convertStatus;
@property (nonatomic, copy) NSString<Optional> *previewUrl;
@property (nonatomic, copy) NSString<Optional> *downloadUrl;
@end
@protocol ReadingListRequest_17Item_Objs

@end

@interface ReadingListRequest_17Item_Objs : JSONModel
@property (nonatomic, copy) NSString<Optional> *objID;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *isFinish;
@property (nonatomic, copy) NSString<Optional> *timeLength;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, strong) ReadingListRequest_17Item_Objs_Affix<Optional> *affix;
@end



@interface ReadingListRequest_17Item : HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *descr;
@property (nonatomic, copy) NSString<Optional> *isFinish;
@property (nonatomic, copy) NSString<Optional> *stageStatus;
@property (nonatomic, strong) ReadingListRequest_17Item_Scheme<Optional> *scheme;
@property (nonatomic, strong) NSArray<ReadingListRequest_17Item_Objs, Optional> *objs;
@end

@interface ReadingListRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectID;
@property (nonatomic, copy) NSString<Optional> *stageID;
@property (nonatomic, copy) NSString<Optional> *toolID;
@property (nonatomic, copy) NSString<Optional> *role;
@property (nonatomic, copy) NSString<Optional> *themeID;//主题 id，有主题时必填，默认为0
@property (nonatomic, copy) NSString<Optional> *layerID;//主题 id，有主题时必填，默认为0
@end
