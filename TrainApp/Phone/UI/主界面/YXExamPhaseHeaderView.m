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
    [self.bgButton addTarget:self action:@selector(btnTouchDownAction) forControlEvents:UIControlEventTouchDown];
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
//    self.enterImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.enterImageView];
    [self.enterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    self.statusImageView = [[UIImageView alloc]init];
    self.statusImageView.image = [UIImage imageNamed:@"完成学习任务标签"];
//    self.statusImageView.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:self.statusImageView];
//    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.mas_equalTo(0);
//        make.right.mas_equalTo(self.enterImageView.mas_left).mas_offset(-10);
//        make.width.mas_equalTo(60);
//    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setIsFold:(BOOL)isFold{
    _isFold = isFold;
    if (isFold) {
        self.enterImageView.image = [UIImage imageNamed:@"第一阶段展开箭头"];
    }else{
        self.enterImageView.image = [UIImage imageNamed:@"第二阶段收起箭头"];
    }
}

- (void)setIsFinished:(BOOL)isFinished{
    _isFinished = isFinished;
    if (isFinished) {
        [self.contentView addSubview:self.statusImageView];
        [self.statusImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(46, 38));
            make.right.mas_equalTo(self.enterImageView.mas_left).mas_offset(-10);
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.statusImageView.mas_left).mas_offset(-10).priorityHigh();
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
    }else{
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15).priorityHigh();
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(self.enterImageView.mas_left).mas_offset(-10).priorityHigh();
        }];
        [self.statusImageView removeFromSuperview];
    }
}

- (void)btnAction{
    self.isFold = !self.isFold;
    BLOCK_EXEC(self.actionBlock);
}

- (void)btnTouchDownAction{
    if (self.isFold) {
        self.enterImageView.image = [UIImage imageNamed:@"第一阶段展开箭头"];
    }else{
        self.enterImageView.image = [UIImage imageNamed:@"第二阶段收起箭头"];
    }
}

@end
