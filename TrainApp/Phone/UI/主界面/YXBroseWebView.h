//
//  YXBroseWebView.h
//  TrainApp
//
//  Created by 李五民 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXBrowserExitDelegate.h"
#import "YXBrowseTimeDelegate.h"

@interface YXBroseWebView : YXBaseViewController
@property (nonatomic, copy) NSString *sourceControllerTitile;//此属性只作为数据上报时使用(区分控制器跳转来源)
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, weak) id<YXBrowserExitDelegate> exitDelegate;
@property (nonatomic, weak) id<YXBrowseTimeDelegate> browseTimeDelegate;

@end
