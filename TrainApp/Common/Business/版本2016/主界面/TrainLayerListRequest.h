//
//  TrainLayerListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol TrainLayerListRequestItem_Body
@end
@interface TrainLayerListRequestItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *layerId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *difficulty;
@property (nonatomic, copy) NSString<Optional> *descr;
@property (nonatomic, copy)  NSString<Optional> *isChoose;
@end

@interface TrainLayerListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSMutableArray<TrainLayerListRequestItem_Body,Optional> *body;
@end
@interface TrainLayerListRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@end
