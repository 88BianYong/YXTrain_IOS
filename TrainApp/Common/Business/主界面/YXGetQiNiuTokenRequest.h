//
//  YXGetQiNiuTokenRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface YXGetQiNiuTokenRequestItem : HttpBaseRequestItem

@property (nonatomic, copy) NSString *uploadToken;
@end

@interface YXGetQiNiuTokenRequest : YXGetRequest

@end
