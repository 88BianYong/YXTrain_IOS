//
//  LSTAlertButton.h
//  TrainApp
//
//  Created by ZLL on 2016/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LSTAlertActionStyle) {
    LSTAlertActionStyle_Alone = 0,
    LSTAlertActionStyle_Default = 1,
    LSTAlertActionStyle_Cancel = 2,
} ;
@interface LSTAlertButton : UIButton
@property (nonatomic, assign) LSTAlertActionStyle style;
@end
