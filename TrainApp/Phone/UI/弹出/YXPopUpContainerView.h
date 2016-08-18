//
//  YXPopUpContainerView.h
//  TrainApp
//
//  Created by Lei Cai on 8/18/16.
//  Copyright © 2016 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXPopUpViewSetDataAndActionProtocol.h"

@interface YXPopUpContainerView : UIView
@property (nonatomic, strong) UIView<YXPopUpViewSetDataAndActionProtocol> *popView;

- (void)showInView:(UIView *)view;
- (void)hide;
@end
