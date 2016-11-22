//
//  ActitvityCommentHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityFirstCommentRequest.h"
typedef void(^ActitvityCommentReplyBlock) (ActivityFirstCommentRequestItem_Body_Replies * replie);
typedef void(^ActitvityCommentFavorBlock) (ActivityFirstCommentRequestItem_Body_Replies * replie);
@interface ActitvityCommentHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) ActivityFirstCommentRequestItem_Body_Replies *replie;
@property (nonatomic, assign) BOOL isFirstBool;

- (void)setActitvityCommentReplyBlock:(ActitvityCommentReplyBlock)block;
- (void)setActitvityCommentFavorBlock:(ActitvityCommentFavorBlock)block;
@end
