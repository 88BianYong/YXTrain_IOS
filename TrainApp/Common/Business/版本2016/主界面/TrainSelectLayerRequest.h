//
//  TrainSelectLayerRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface TrainSelectLayerRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *projectId;
@property (nonatomic, strong) NSString<Optional> *layerId;

@end
