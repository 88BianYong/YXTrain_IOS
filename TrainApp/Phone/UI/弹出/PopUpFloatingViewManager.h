//
//  PopUpFloatingViewManager.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,PopUpFloatingLoginStatus) {
    PopUpFloatingLoginStatus_Already,//已经登录
    PopUpFloatingLoginStatus_Default,//普通登录
    PopUpFloatingLoginStatus_QRCode//扫码带课程登录
};
@interface PopUpFloatingViewManager : NSObject
@property (nonatomic, assign) PopUpFloatingLoginStatus loginStatus;//区分登录进入
@property (nonatomic, copy) void(^popUpFloatingViewManagerCompleteBlock)(BOOL isShow);//区分是否可以进入动态
+ (instancetype)sharedInstance;
/**
 * @brief 浮层显示顺序 1.广告页 2.升级界面 3.项目切换 4.角色切换  5.二维码扫描 其中任何一个需要显示时调用该方法内部自动判断
 */
- (void)startPopUpFloatingView;

- (void)showPopUpFloatingView;
- (void)hiddenPopUpFloatingView;
@end
