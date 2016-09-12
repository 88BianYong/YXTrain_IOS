//
//  YXWebViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 16/9/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"

@interface YXWebViewController : YXBaseViewController
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, assign) BOOL isUpdatTitle;//是否更新随着点击网页更新title default NO
@end
