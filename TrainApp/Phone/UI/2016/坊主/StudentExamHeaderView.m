//
//  StudentExamHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StudentExamHeaderView.h"
#import "YXGradientView.h"
#import "YXExamHelper.h"
static const CGFloat kTotalDuration = 1.f;
@interface StudentExamHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) YXGradientView *progressView;
@property (nonatomic, assign) CGFloat progress;
@end
@implementation StudentExamHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
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
    [self.statusLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.statusLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15).priorityLow();
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(120.f);
    }];
}

- (void)setData:(YXExamineRequestItem_body_bounsVoData *)data{
    _data = data;
    self.titleLabel.text = data.name;
    self.statusLabel.attributedText = [YXExamHelper toolCompleteStatusStringWithID:data.toolid finishNum:data.finishnum totalNum:data.totalnum];
    CGFloat progress = data.finishnum.floatValue/data.totalnum.floatValue;
    self.progress = progress;
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
        [UIView animateWithDuration:kTotalDuration*self->_progress animations:^{
            [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(self.mas_width).multipliedBy(self->_progress);
            }];
            [self layoutIfNeeded];
        }];
    });
}
@end
