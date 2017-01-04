//
//  SecondCommentViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "CommentPageListViewController.h"
typedef void(^SecondCommentViewControllerRefreshBlock) (NSInteger integer, NSString *isRanked);
@interface SecondCommentViewController : CommentPageListViewController
@property (nonatomic, strong) NSString *parentID;
@property (nonatomic, strong) ActivityFirstCommentRequestItem_Body_Replies *replie;
@property (nonatomic, assign) NSInteger chooseInteger;
@property (nonatomic, copy) void(^refreshBlock) (NSInteger integer, NSString *isRanked , NSInteger totalInteger);

@end
