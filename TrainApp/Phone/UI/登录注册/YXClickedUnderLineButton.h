//
//  YXClickedUnderLineButton.h
//  TrainApp
//
//  Created by 李五民 on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXClickedUnderLineButton : UIView

@property (nonatomic, copy) void(^buttonClicked)();
- (void)buttonTitileWithName:(NSString *)name;

@end
