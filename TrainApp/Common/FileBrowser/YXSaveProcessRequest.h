//
//  YXSaveProcessRequest.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"

@interface YXSaveProcessRequest : YXPostRequest
@property (nonatomic, strong) NSString<Optional> *w;
@property (nonatomic, strong) NSString<Optional> *cid;
@property (nonatomic, strong) NSString<Optional> *pid;
@property (nonatomic, strong) NSString<Optional> *content;
@end
