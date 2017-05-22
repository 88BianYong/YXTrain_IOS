//
//  PopUpFloatingViewManager.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopUpFloatingViewManager : NSObject
@property (nonatomic, copy) void(^popUpFloatingViewManagerCompleteBlock)(BOOL isShow);
+ (instancetype)sharedInstance;
/**
 * @brief 浮层显示顺序 1.广告页 2.升级界面 3.项目切换 4.角色切换  其中任何一个需要显示时调用该方法内部自动判断
 */
- (void)showPopUpFloatingView;
@end
