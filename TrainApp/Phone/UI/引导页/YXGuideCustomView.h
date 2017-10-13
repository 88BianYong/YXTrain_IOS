//
//  YXGuideCustomView.h
//  TrainApp
//
//  Created by 李五民 on 16/7/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXGuideModel.h"

@interface YXGuideCustomView : UIView

- (void)configWithGuideModel:(YXGuideModel *)guideModel;

@property (nonatomic, strong) void(^startButtonClickedBlock)(void);

@end
