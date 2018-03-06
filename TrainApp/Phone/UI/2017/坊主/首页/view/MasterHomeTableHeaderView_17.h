//
//  MasterHomeTableHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterHomeTableHeaderView_17 : UIView
@property (nonatomic, copy) void(^masterHomeOpenCloseBlock)(BOOL isOpen);
- (void)reloadHeaderViewContent:(NSString *)score withPass:(NSInteger)pass;
@end
