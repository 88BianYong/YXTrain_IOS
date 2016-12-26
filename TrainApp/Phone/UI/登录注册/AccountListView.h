//
//  AccountListView.h
//  TrainApp
//
//  Created by niuzhaowang on 2016/12/26.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountListView : UIView
@property (nonatomic, copy) void(^accountSelectBlock)(NSString *name,NSString *password);
@end
