//
//  YXFileFavorWrapper.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXBaseViewController.h"

@protocol YXFileFavorDelegate <NSObject>
- (void)fileDidFavor;
@end

@interface YXFileFavorWrapper : NSObject

@property (nonatomic, strong, readonly) UIButton *favorButton;
@property (nonatomic, weak) id<YXFileFavorDelegate> delegate;

- (instancetype)initWithData:(id)data baseVC:(YXBaseViewController *)vc;

@end
