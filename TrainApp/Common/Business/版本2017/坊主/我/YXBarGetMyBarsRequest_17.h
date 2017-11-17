//
//  YXBarGetMyBarsRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol YXBarGetMyBarsRequestItem_Body_Bar @end
@interface YXBarGetMyBarsRequestItem_Body_Bar : JSONModel
@property (nonatomic, strong) NSString<Optional> *barId;
@property (nonatomic, strong) NSString<Optional> *name;
@end

@interface YXBarGetMyBarsRequestItem_Body : JSONModel
@property (nonatomic, strong) NSArray<YXBarGetMyBarsRequestItem_Body_Bar, Optional> *bars;
@end

@interface YXBarGetMyBarsRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXBarGetMyBarsRequestItem_Body *body;
@end

@interface YXBarGetMyBarsRequest_17 : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *roleId;
@end
