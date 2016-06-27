//
//  YXExamPhaseHeaderView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamPhaseHeaderView.h"

@interface YXExamPhaseHeaderView()
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UIImageView *enterImageView;
@end

@implementation YXExamPhaseHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.bgButton = [[UIButton alloc]init];
    [self.bgButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.bgButton];
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15).priorityHigh();
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-40).priorityHigh();
    }];
    self.enterImageView = [[UIImageView alloc]init];
    self.enterImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.enterImageView];
    [self.enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    self.statusImageView = [[UIImageView alloc]init];
    self.statusImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.statusImageView];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.enterImageView.mas_left).mas_offset(-10);
        make.width.mas_equalTo(60);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)btnAction{
    BLOCK_EXEC(self.actionBlock);
}

@end
