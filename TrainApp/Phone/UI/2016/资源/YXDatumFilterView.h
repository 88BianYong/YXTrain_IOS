//
//  YXDatumFilterView.h
//  TrainApp
//
//  Created by 李五民 on 16/6/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXDatumFilterModel.h"

@interface YXDatumFilterView : UIView

@property (nonatomic, strong) YXDatumFilterModel *filterModel;
@property (nonatomic, copy) void(^didSeletedFilterItem)(void);

@end
