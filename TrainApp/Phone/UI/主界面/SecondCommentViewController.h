//
//  SecondCommentViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "CommentPageListViewController.h"

@interface SecondCommentViewController : CommentPageListViewController
@property (nonatomic, strong) NSString *parentID;
@property (nonatomic, strong) ActivityFirstCommentRequestItem_Body_Replies *replie;
@end
