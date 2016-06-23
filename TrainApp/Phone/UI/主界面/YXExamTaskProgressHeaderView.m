//
//  YXExamTaskProgressHeaderView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamTaskProgressHeaderView.h"
#import "YXExamProgressView.h"

@interface YXExamTaskProgressHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) YXExamProgressView *progressView;
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
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(75);
    }];
    
    self.progressView = [[YXExamProgressView alloc]init];
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(81);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(6);
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(2);
    }];
    
    self.statusLabel = [[UILabel alloc]init];
    self.statusLabel.font = [UIFont systemFontOfSize:11];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.progressView.mas_right).mas_offset(10);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setData:(YXExamineRequestItem_body_bounsVoData *)data{
    _data = data;
    self.titleLabel.text = data.name;
    NSString *lStr = [NSString stringWithFormat:@"已完成%@个",data.finishnum];
    NSString *rStr = [NSString stringWithFormat:@"／%@个",data.totalnum];
    NSString *completeStr = [NSString stringWithFormat:@"%@%@",lStr,rStr];
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc]initWithString:completeStr];
    NSRange range = [completeStr rangeOfString:rStr];
    [mStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"505f84"] range:range];
    self.statusLabel.attributedText = mStr;
    CGFloat progress = data.finishnum.floatValue/data.totalnum.floatValue;
    self.progressView.progress = progress;
}


@end
