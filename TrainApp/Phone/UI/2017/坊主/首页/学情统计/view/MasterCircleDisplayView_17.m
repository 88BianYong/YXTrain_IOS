//
//  MasterCircleDisplayView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterCircleDisplayView_17.h"
@interface MasterCircleDisplayView_17 ()
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation MasterCircleDisplayView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.circleView.progress = _progress;
    self.bgView.titleLabel.text = [NSString stringWithFormat:@"%0.2f%%",_progress *100.0f];
}
- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titleLabel.text = _titleString;
}
#pragma mark - setupUI
- (void)setupUI {
    self.bgView = [[YXBackgroundCircleView alloc] initWithFrame:CGRectMake(0, 0, 75.0f, 75.0f)];
    [self addSubview:self.bgView];
    self.circleView = [[YXCircleView alloc] initWithFrame:CGRectMake(0, 0, 75.0f, 75.0f)];
    [self addSubview:self.circleView];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.titleLabel];
}
- (void)setupLayout {
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(75.0f, 75.0f));
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.circleView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
}
@end
