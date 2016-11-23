//
//  ActitvityCommentCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityFirstCommentRequest.h"
typedef void (^ActitvityCommentCellFavorBlock) ();
typedef NS_OPTIONS(NSInteger, ActitvityCommentCellStatus) {
    ActitvityCommentCellStatus_Top = 1<<0,
    ActitvityCommentCellStatus_Middle = 1<<1,
    ActitvityCommentCellStatus_Bottom = 1<<2,
};
@interface ActitvityCommentCell : UITableViewCell
@property (nonatomic, strong) ActivityFirstCommentRequestItem_Body_Replies *reply;
@property (nonatomic, assign) ActitvityCommentCellStatus cellStatus;

- (void)setActitvityCommentCellFavorBlock:(ActitvityCommentCellFavorBlock)block;
@end
