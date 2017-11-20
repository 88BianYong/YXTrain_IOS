//
//  MasterHomeworkTableHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkTableHeaderView_17.h"
#import "MasterCircleDisplayView_17.h"
#define kCircleWidth 80.0f
@interface MasterHomeworkTableHeaderView_17 ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *explainButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) CGFloat spacingFloat;
@end
@implementation MasterHomeworkTableHeaderView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.spacingFloat = (kScreenWidth - (kCircleWidth * 3.5f))/4.0f;
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (NSString *)descripe {
    __block NSString *string = @"";
    [self.schemes enumerateObjectsUsingBlock:^(MasterManagerSchemeItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        string = [string stringByAppendingString:obj.descripe];
    }];
    return string;
}
- (void)setSchemes:(NSArray<MasterManagerSchemeItem *> *)schemes {
    _schemes = schemes;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MasterCircleDisplayView_17 class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    [_schemes enumerateObjectsUsingBlock:^(MasterManagerSchemeItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MasterCircleDisplayView_17 *circleDisplayView = [[MasterCircleDisplayView_17 alloc] init];
        circleDisplayView.titleString = obj.typecode;
        circleDisplayView.progress = obj.userfinishnum.floatValue/obj.amount.floatValue;
        [self.scrollView addSubview:circleDisplayView];
        [circleDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(80.0f, 97.0f));
            make.left.equalTo(self.scrollView.mas_left).offset((self.spacingFloat + 80.0f) *idx + self.spacingFloat);
            make.top.equalTo(self.scrollView.mas_top).offset(25.0f);
        }];
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.text = @"考核说明";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self addSubview:self.titleLabel];
    
    self.explainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标正常态"]
                        forState:UIControlStateNormal];
    [self.explainButton setImage:[UIImage imageNamed:@"解释说明图标点击态"]
                        forState:UIControlStateHighlighted];
    WEAK_SELF
    [[self.explainButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.masterHomeworkButtonBlock,self.explainButton);
        
    }];
    [self addSubview:self.explainButton];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self addSubview:self.lineView];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth + kCircleWidth/2.0f + self.spacingFloat, 100.0f);
    [self addSubview:self.scrollView];
}
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15.0f);
        make.top.equalTo(self.mas_top);
        make.height.mas_offset(45.0f);
    }];
    
    [self.explainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10.0f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.size.mas_offset(CGSizeMake(19.0f, 19.0f));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
}
@end
