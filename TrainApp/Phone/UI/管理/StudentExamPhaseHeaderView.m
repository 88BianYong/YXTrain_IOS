//
//  StudentExamPhaseHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StudentExamPhaseHeaderView.h"
#import "YXGradientView.h"
@interface StudentExamPhaseHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) YXGradientView *gradientView;
@end
@implementation StudentExamPhaseHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.clipsToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15).priorityHigh();
        make.top.mas_equalTo(15.0f);
        make.right.mas_equalTo(-40).priorityHigh();
    }];
    self.statusImageView = [[UIImageView alloc]init];
    self.statusImageView.image = [UIImage imageNamed:@"完成学习任务标签"];
    UIColor *color = [UIColor colorWithHexString:@"f1f1f1"];
    self.gradientView = [[YXGradientView alloc]initWithStartColor:color endColor:[color colorWithAlphaComponent:0] orientation:YXGradientTopToBottom];
    [self.contentView addSubview:self.gradientView];
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(45.0f);
        make.left.right.equalTo(self.contentView);
        make.height.mas_offset(25.0f);
    }];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}
- (void)setIsFinished:(BOOL)isFinished{
    _isFinished = isFinished;
    if (isFinished) {
        [self.contentView addSubview:self.statusImageView];
        [self.statusImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.size.mas_equalTo(CGSizeMake(46, 38));
            make.right.mas_equalTo(self.contentView).mas_offset(-30);
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.statusImageView.mas_left).mas_offset(-10).priorityHigh();
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(15);
        }];
    }else{
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15).priorityHigh();
            make.top.mas_equalTo(15);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-20).priorityHigh();
        }];
        [self.statusImageView removeFromSuperview];
    }
}
@end
