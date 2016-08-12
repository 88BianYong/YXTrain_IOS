//
//  YXWriteHomeworkInfoHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXWriteHomeworkInfoTitleView : UITableViewHeaderFooterView
@property (nonatomic, copy) void (^titleStringHandler)(NSString *title);
@end
