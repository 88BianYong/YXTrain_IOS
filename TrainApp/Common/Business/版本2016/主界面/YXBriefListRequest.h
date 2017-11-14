//
//  YXBriefListRequest.h
//  TrainApp
//
//  Created by 李五民 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXNoticeListRequest.h"

@interface YXBriefListRequestItem_body : JSONModel

@property (nonatomic ,strong) NSArray<YXNoticeAndBulletinItem,Optional> *briefs;

@end

@interface YXBriefListRequestItem : HttpBaseRequestItem

@property (nonatomic, strong)YXBriefListRequestItem_body<Optional> *body;

@end

@interface YXBriefListRequest : YXGetRequest

@property (nonatomic, strong) NSString *pid;

@end
