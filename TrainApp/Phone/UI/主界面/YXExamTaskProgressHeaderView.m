//
//  YXExamTaskProgressHeaderView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamTaskProgressHeaderView.h"
#import "YXExamProgressView.h"
#import "YXExamHelper.h"

@interface YXExamTaskProgressHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) YXExamProgressView *progressView;
@property (nonatomic, strong) UIButton *markButton;
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
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(160);
    }];
    
    self.progressView = [[YXExamProgressView alloc]init];
    self.progressView.userInteractionEnabled = NO;
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.statusLabel.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(6);
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(2).priorityHigh();
    }];
    
    self.markButton = [[UIButton alloc]init];
    self.markButton.backgroundColor = [UIColor redColor];
    [self.markButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.statusLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.statusLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setData:(YXExamineRequestItem_body_bounsVoData *)data{
    _data = data;
    self.titleLabel.text = data.name;
    self.statusLabel.attributedText = [YXExamHelper toolCompleteStatusStringWithID:data.toolid finishNum:data.finishnum totalNum:data.totalnum];
    CGFloat progress = data.finishnum.floatValue/data.totalnum.floatValue;
    self.progressView.progress = progress;

    if (data.isneedmark.boolValue) {
        [self.contentView addSubview:self.markButton];
        [self.markButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.markButton.mas_left).mas_offset(-10);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(125);
        }];
    }else{
        [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(160);
        }];
        [self.markButton removeFromSuperview];
    }
}

- (void)btnAction:(UIButton *)sender{
    BLOCK_EXEC(self.markAction,sender);
}

- (void)bgButtonAction{
    BLOCK_EXEC(self.clickAction);
}

@end
