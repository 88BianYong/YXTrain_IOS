//
//  DataErrorView.m
//  TrainApp
//
//  Created by ZLL on 2016/11/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "DataErrorView.h"

@interface DataErrorView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *refreshButton;
@end

@implementation DataErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.imageView = [[UIImageView alloc]init];
    self.imageView.image = [UIImage imageNamed:@"数据错误"];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = @"数据错误";
    
    self.subTitleLabel = [[UILabel alloc]init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:12];
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.text = @"刷新重试";
    
    self.refreshButton = [[UIButton alloc]init];
    self.refreshButton.backgroundColor = [UIColor colorWithHexString:@"2585d6"];
    [self.refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    [self.refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    self.refreshButton.layer.cornerRadius = YXTrainCornerRadii;
    self.refreshButton.clipsToBounds = YES;
}
- (void)setupLayout {
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.refreshButton];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-110);
        make.size.mas_equalTo(CGSizeMake(202, 202));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(5);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
    }];
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(115, 33));
    }];
}
- (void)refreshAction {
    BLOCK_EXEC(self.refreshBlock);
}
@end
