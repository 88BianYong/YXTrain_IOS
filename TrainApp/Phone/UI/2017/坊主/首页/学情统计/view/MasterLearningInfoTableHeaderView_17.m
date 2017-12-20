//
//  MasterLearningInfoTableHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterLearningInfoTableHeaderView_17.h"

@interface MasterLearningInfoTableHeaderView_17 ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIButton *filterButton;

@end
@implementation MasterLearningInfoTableHeaderView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.text = @"考核说明";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.titleLabel];
    
    self.totalLabel = [[UILabel alloc] init];
    self.totalLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.totalLabel.text = @"考核说明";
    self.totalLabel.textAlignment = NSTextAlignmentRight;
    self.totalLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.totalLabel];
    
    self.filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.filterButton setImage:[UIImage imageNamed:@"筛选"]
                        forState:UIControlStateNormal];
    WEAK_SELF
    [[self.filterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.filterButton.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.filterButton.enabled = YES;
        });
        self.filterButton.selected = !self.filterButton.selected;
        BLOCK_EXEC(self.masterLearningInfoButtonBlock,self.filterButton.selected);
        
    }];
    [self addSubview:self.filterButton];
}
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.right.equalTo(self.totalLabel.mas_left).offset(-15.0f);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.filterButton.mas_left).offset(-15.0f);
        make.centerY.equalTo(self.mas_centerY);
        make.width.offset(70.0f);
    }];

    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.size.mas_offset(CGSizeMake(25.0f, 25.0f));
    }];
}
- (void)reloadMasterLearningInfo:(NSString *)title withNumber:(NSString *)total {
    self.titleLabel.text = title;
    self.totalLabel.text = [NSString stringWithFormat:@"共 %@ 人",total];
}

@end
