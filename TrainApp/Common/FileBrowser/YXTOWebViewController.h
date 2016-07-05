//
//  YXTOWebViewController.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <TOWebViewController/TOWebViewController.h>
#import "YXBrowserExitDelegate.h"
#import "YXBrowseTimeDelegate.h"

@interface YXTOWebViewController : TOWebViewController
@property (nonatomic, weak) id<YXBrowserExitDelegate> exitDelegate;
@property (nonatomic, weak) id<YXBrowseTimeDelegate> browseTimeDelegate;
@end
