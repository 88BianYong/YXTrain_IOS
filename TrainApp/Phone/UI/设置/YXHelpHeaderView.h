//
//  YXHelpHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/9/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXHelpHeaderView : UITableViewHeaderFooterView
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic ,assign) BOOL isOpen;
@property (nonatomic, copy) void (^openAndClosedHandler)(BOOL boolState) ;
@end
