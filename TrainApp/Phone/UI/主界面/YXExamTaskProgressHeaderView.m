//
//  YXExamTaskProgressHeaderView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamTaskProgressHeaderView.h"
#import "YXGradientView.h"
#import "YXExamHelper.h"
static const CGFloat kTotalDuration = 1.f;

@interface YXExamTaskProgressHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) YXGradientView *progressView;
@property (nonatomic, strong) UIButton *markButton;
@property (nonatomic, assign) CGFloat progress;
@end

@implementation YXExamTaskProgressHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIButton *bgButton = [[UIButton alloc]init];
    [bgButton addTarget:self action:@selector(bgButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:bgButton];
    [bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.progressView = [[YXGradientView alloc]initWithStartColor:[UIColor colorWithHexString:@"f0feff"] endColor:[UIColor colorWithHexString:@"f0f6ff"] orientation:YXGradientLeftToRight];
    self.progressView.userInteractionEnabled = NO;
    [self.contentView addSubview:self.progressView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(75).priorityHigh();
    }];
    
    self.statusLabel = [[UILabel alloc]init];
    self.statusLabel.font = [UIFont systemFontOfSize:11];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    [self.contentView addSubview:self.statusLabel];
    
    self.markButton = [[UIButton alloc]init];
//    self.markButton.backgroundColor = [UIColor redColor];
    [self.markButton setImage:[UIImage imageNamed:@"点评icon-默认状态"] forState:UIControlStateNormal];
    [self.markButton setImage:[UIImage imageNamed:@"点评icon-点击状态"] forState:UIControlStateHighlighted];
    [self.markButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.statusLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.statusLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setData:(YXExamineRequestItem_body_bounsVoData *)data{
    _data = data;
    self.titleLabel.text = data.name;
    self.statusLabel.attributedText = [YXExamHelper toolCompleteStatusStringWithID:data.toolid finishNum:data.finishnum totalNum:data.totalnum];
    CGFloat progress = data.finishnum.floatValue/data.totalnum.floatValue;
    self.progress = progress;

    if (data.isneedmark.boolValue) {
        [self.contentView addSubview:self.markButton];
        [self.markButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-27.0f);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-51.0f).priorityLow();
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(120.f);
        }];
    }else{
        [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15).priorityLow();
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(120.f);
        }];
        [self.markButton removeFromSuperview];
    }
}
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    _progress = MAX(_progress, 0);
    _progress = MIN(_progress, 1);
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_offset(0.0f);
    }];
    [self layoutIfNeeded];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kTotalDuration*_progress animations:^{
            [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(self.mas_width).multipliedBy(_progress);
            }];
            [self layoutIfNeeded];
        }];
    });
}

- (void)btnAction:(UIButton *)sender{
    BLOCK_EXEC(self.markAction,sender);
}

- (void)bgButtonAction{
    BLOCK_EXEC(self.clickAction);
}

@end
