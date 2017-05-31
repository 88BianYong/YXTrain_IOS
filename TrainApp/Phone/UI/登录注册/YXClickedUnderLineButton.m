//
//  YXClickedUnderLineButton.m
//  TrainApp
//
//  Created by 李五民 on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXClickedUnderLineButton.h"

@interface YXClickedUnderLineButton ()

@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIView *bottomView;

@end

@implementation YXClickedUnderLineButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.button = [[UIButton alloc] init];
    [self.button setTitle:@"忘记密码" forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.button setTitleColor:[UIColor colorWithHexString:@"cf2627"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonClickedOut) forControlEvents:UIControlEventTouchUpInside];
    [self.button addTarget:self action:@selector(buttonClickedIn) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.button];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"cf2627"];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).offset(-6.5);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.bottomView.hidden = YES;
}

- (void)buttonClickedIn {
    self.bottomView.hidden = NO;
}

- (void)buttonClickedOut {
    self.bottomView.hidden = YES;
    if (self.buttonClicked) {
        self.buttonClicked();
    }
}

- (void)buttonTitileWithName:(NSString *)name {
    [self.button setTitle:name forState:UIControlStateNormal];
}



@end
