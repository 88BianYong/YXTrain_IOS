//
//  ActitvityCommentHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityFirstCommentRequest.h"
static NSString *kContentSeparator = @"<br />";
static NSString *kNameSeparator = @"：";
static CGFloat kDistanceTopLong = 30.0f;
static CGFloat kDistanceTopMiddle = 15.0f;
static CGFloat kDistanceTopShort = 10.0f;

typedef void(^ActitvityCommentReplyBlock) (ActivityFirstCommentRequestItem_Body_Replies * replie);
typedef void(^ActitvityCommentFavorBlock) ();
@interface ActitvityCommentHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) ActivityFirstCommentRequestItem_Body_Replies *replie;
@property (nonatomic, assign) CGFloat distanceTop;
@property (nonatomic, assign) BOOL isFontBold;

- (void)setActitvityCommentReplyBlock:(ActitvityCommentReplyBlock)block;
- (void)setActitvityCommentFavorBlock:(ActitvityCommentFavorBlock)block;
@end
