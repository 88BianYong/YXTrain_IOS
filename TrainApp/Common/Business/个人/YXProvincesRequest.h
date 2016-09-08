//
//  YXProvincesRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/9/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol YXProvincesRequestItem_subArea
@end
@interface YXProvincesRequestItem_subArea:JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *number;
@property (nonatomic ,strong) NSArray<YXProvincesRequestItem_subArea, Optional> *subArea;

@end
@interface YXProvincesRequestItem:HttpBaseRequestItem
@property (nonatomic ,strong)NSArray<YXProvincesRequestItem_subArea, Optional> *data;
@property (nonatomic, copy) NSString<Optional> *version;

@end

@interface YXProvincesRequest : YXGetRequest
@end
