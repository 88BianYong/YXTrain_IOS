//
//  CommentPagedListFetche.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/14.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^PagedListFetcherCompleteBlock)(int totalPage, int currentPage, NSMutableArray *retItemArray, NSError *error);
@interface CommentPagedListFetcher : NSObject
@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *toolid;
@property (nonatomic, strong) NSString *parentid;
@property (nonatomic, strong) NSString *w;
@property (nonatomic, assign) int  pageIndex;
@property (nonatomic, assign) int  pageSize;

- (void)startWithBlock:(PagedListFetcherCompleteBlock)aCompleteBlock;
- (void)stop;

@end
