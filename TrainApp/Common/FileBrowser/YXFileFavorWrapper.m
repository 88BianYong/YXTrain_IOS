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
@property (nonatomic, weak) YXBaseViewController *baseVC;
@property (nonatomic, strong) UIButton *favorButton;
@end

@implementation YXFileFavorWrapper

- (instancetype)initWithData:(id)data baseVC:(YXBaseViewController *)vc{
    if (self = [super init]) {
        self.data = data;
        self.baseVC = vc;
        [self setupButton];
    }
    return self;
}

- (void)setupButton{
    self.favorButton = [[UIButton alloc]init];
    [self.favorButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.favorButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.favorButton setTitleColor:[[UIColor redColor]colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    self.favorButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.favorButton addTarget:self action:@selector(favorAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)favorAction{
    SAFE_CALL(self.delegate, fileDidFavor);
}


@end
