//
//  TestVideoViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"

@interface TestVideoViewController : YXBaseViewController
@property (nonatomic ,strong) NSMutableDictionary *mutableDictionary;
@property (nonatomic, copy) void(^testVideoViewControllerBlock)(BOOL test);
@end
