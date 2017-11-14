//
//  YXWriteHomeworkInfoCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXWriteHomeworkInfoCell : UITableViewCell
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *contentString;
@property (nonatomic, assign)YXWriteHomeworkListStatus status;
@property (nonatomic, copy) void (^openCloseHandler)(UIView *sender, YXWriteHomeworkListStatus status);
@property (nonatomic, assign) BOOL isEnabled;
@end
