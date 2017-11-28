//
//  MasterDetailActiveTableHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, MasterManageActiveType) {
    MasterManageActiveType_Tool = 1,
    MasterManageActiveType_Member = 2
};
@interface MasterDetailActiveTableHeaderView_17 : UIView
- (CGFloat)relodDetailActiveHeader:(NSString *)contentString withMySelf:(BOOL)isMy;
@property (nonatomic, copy) void(^masterDetailActiveBlock)(MasterManageActiveType type);
@end
