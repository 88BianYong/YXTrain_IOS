//
//  YXFileFavorWrapper.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileFavorWrapper.h"

@interface YXFileFavorWrapper()
@property (nonatomic, strong) id data;
@property (nonatomic, weak) UIViewController *baseVC;
@property (nonatomic, strong) UIButton *favorButton;
@end

@implementation YXFileFavorWrapper

- (instancetype)initWithData:(id)data baseVC:(UIViewController *)vc{
    if (self = [super init]) {
        self.data = data;
        self.baseVC = vc;
        [self setupButton];
    }
    return self;
}

- (void)setupButton{
    self.favorButton = [YXNavigationBarController naviButtonForTitle:@"保存"];
    [self.favorButton addTarget:self action:@selector(favorAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)favorAction{
    SAFE_CALL(self.delegate, fileDidFavor);
}


@end
