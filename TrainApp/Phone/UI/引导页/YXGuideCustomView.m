//
//  YXGuideCustomView.m
//  TrainApp
//
//  Created by 李五民 on 16/7/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGuideCustomView.h"

@interface YXGuideCustomView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titileLabel;
@property (nonatomic, strong) UILabel *detailLabel;
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
        
        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.backgroundColor = [UIColor redColor];
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(110);
            make.size.mas_equalTo(CGSizeMake(215, 215));
        }];
        
        self.titileLabel = [[UILabel alloc] init];
        self.titileLabel.textColor = [UIColor colorWithHexString:@"0067be"];
        self.titileLabel.font = [UIFont systemFontOfSize:27];
        [self addSubview:self.titileLabel];
        [self.titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(self.iconImageView.mas_bottom).offset(95);
        }];
        
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.detailLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(self.titileLabel.mas_bottom).offset(23);
        }];
        
        self.startButton = [[UIButton alloc] init];
        self.startButton.backgroundColor = [UIColor whiteColor];
        self.startButton.layer.borderWidth = 2;
        self.startButton.layer.cornerRadius = 2;
        self.startButton.layer.borderColor = [[UIColor redColor] CGColor];
        [self.startButton setTitle:@"开始体验" forState:UIControlStateNormal];
        [self.startButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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
    self.detailLabel.text = guideModel.guideDetail;
    self.startButton.hidden = !guideModel.isShowButton;
}

- (void)startButtonClicked {
    if (self.startButtonClickedBlock) {
        self.startButtonClickedBlock();
    }
}

@end
