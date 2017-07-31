//
//  ActivityListHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ActivityListHeaderView_17.h"
#import "YXExamProgressView.h"
@interface ActivityListHeaderView_17 ()
@property (nonatomic, strong) UILabel *mainPointLabel;
@property (nonatomic, strong) UILabel *scheduleLabel;
@property (nonatomic, strong) YXExamProgressView *progressView;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation ActivityListHeaderView_17

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setScheme:(ActivityListRequestItem_body_scheme<Optional> *)scheme {
    _scheme = scheme;
    self.mainPointLabel.text = [NSString stringWithFormat:@"需要参加%@个活动",_scheme.scheme.finishNum];
    self.progressView.progress = _scheme.process.userFinishNum.floatValue / _scheme.scheme.finishNum.floatValue;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ / %@",_scheme.scheme.finishNum,_scheme.process.userFinishNum]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0070c9"] range:NSMakeRange(0, _scheme.process.userFinishNum.length)];
    self.scheduleLabel.attributedText = attributedString;
}
#pragma mark - setupUI
- (void)setupUI {
    self.mainPointLabel = [[UILabel alloc] init];
    self.mainPointLabel.font = [UIFont systemFontOfSize:14.0f];
    self.mainPointLabel.text = @"你熟练度会计分录卡迪夫;拉的屎啦咖啡";
    self.mainPointLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.mainPointLabel];
    
    self.scheduleLabel = [[UILabel alloc] init];
    self.scheduleLabel.font = [UIFont fontWithName:YXFontMetro_DemiBold size:13];
    self.scheduleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.scheduleLabel.text = @"1/2";
    [self.contentView addSubview:self.scheduleLabel];
    
    self.progressView = [[YXExamProgressView alloc]init];
    self.progressView.progress = 0.5f;
    [self.contentView addSubview:self.progressView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.contentView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.mainPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(16.0f);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.mainPointLabel.mas_bottom).offset(15.0f);
        make.height.mas_offset(6.0f);
        make.right.equalTo(self.scheduleLabel.mas_left).offset(-20.0f);
    }];
    [self.scheduleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.centerY.equalTo(self.progressView.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
}
@end
