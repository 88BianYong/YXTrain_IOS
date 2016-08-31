//
//  YXPopUpContainerView.m
//  TrainApp
//
//  Created by Lei Cai on 8/18/16.
//  Copyright © 2016 niuzhaowang. All rights reserved.
//

#import "YXPopUpContainerView.h"

@implementation YXPopUpContainerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
}

- (void)showInView:(UIView *)view {
    if (view == nil){
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [window addSubview:self];
    }
    else{
        [view addSubview:self];
    }
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.popView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.4
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.popView.transform = CGAffineTransformMakeScale(1, 1);
                     }
                     completion:nil
     ];
}

- (void)hide {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }
     ];
}

@end
