//
//  YXGuideCustomView.m
//  TrainApp
//
//  Created by 李五民 on 16/7/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGuideCustomView.h"

@interface YXGuideCustomView ()

@property (nonatomic, strong) UILabel *titileLabel;
@property (nonatomic, strong) UIButton *startButton;

@end

@implementation YXGuideCustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.titileLabel = [[UILabel alloc] init];
        self.titileLabel.textColor = [UIColor blueColor];
        [self addSubview:self.titileLabel];
        [self.titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
        
        self.startButton = [[UIButton alloc] init];
        self.startButton.backgroundColor = [UIColor redColor];
        [self.startButton addTarget:self action:@selector(startButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.startButton];
        [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)configWithGuideModel:(YXGuideModel *)guideModel {
    self.titileLabel.text = guideModel.guideTitle;
    self.startButton.hidden = !guideModel.isShowButton;
}

- (void)startButtonClicked {
    if (self.startButtonClickedBlock) {
        self.startButtonClickedBlock();
    }
}

@end
