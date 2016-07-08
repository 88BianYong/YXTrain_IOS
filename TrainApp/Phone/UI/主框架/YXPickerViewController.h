//
//  YXPickerViewController.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/12.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXBaseViewController.h"

@interface YXPickerViewController : YXBaseViewController

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy) void(^confirmBlock)();

// 显示PickerView并展示数据
- (void)reloadPickerView;

@end
