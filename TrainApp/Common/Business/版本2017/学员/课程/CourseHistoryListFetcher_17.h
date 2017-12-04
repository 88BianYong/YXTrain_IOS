//
//  CourseHistoryListFetcher_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "CourseListRequest_17.h"
@interface CourseHistoryListFetcher_17 : PagedListFetcherBase
@property (nonatomic, copy) NSString<Optional> *stageID;
@property (nonatomic, copy) void(^masterCourseHistoryBlock)(CourseListRequest_17Item_Scheme *scheme);

@end
