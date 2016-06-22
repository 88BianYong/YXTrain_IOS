//
//  YXDatumOrderView.h
//  TrainApp
//
//  Created by 李五民 on 16/6/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXDatumOrderModel.h"

@interface YXDatumOrderView : UIView

@property (nonatomic, strong) YXDatumOrderModel *orderModel;
@property (nonatomic, copy) void(^didSeletedDatumOrderItem)();

@end
