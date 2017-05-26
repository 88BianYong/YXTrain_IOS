//
//  VideoCourseCommentsFetcher.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^VideoCourseCommentsCompleteBlock)(BOOL isNext,NSMutableArray *retItemArray, NSError *error);
@interface VideoCourseCommentsFetcher : NSObject
@property (nonatomic, copy) NSString<Optional> *commentID;
@property (nonatomic, copy) NSString<Optional> *courseID;
@property (nonatomic, copy) NSString<Optional> *parentID;

- (void)startWithBlock:(VideoCourseCommentsCompleteBlock)aCompleteBlock;
- (void)stop;
@end
