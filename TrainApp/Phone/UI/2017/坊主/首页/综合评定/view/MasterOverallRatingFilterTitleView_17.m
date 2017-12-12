//
//  MasterOverallRatingFilterTitleView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOverallRatingFilterTitleView_17.h"
@interface MasterOverallRatingFilterTitleView_17 ()
@property (nonatomic, strong) UILabel *statusNameLabel;
@property (nonatomic, strong) UILabel *statusContentNameLabel;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation MasterOverallRatingFilterTitleView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setFilterModel:(NSArray<LSTCollectionFilterDefaultModel *> *)filterModel {
    _filterModel = filterModel;
    LSTCollectionFilterDefaultModel *model1 = _filterModel[1];
    self.statusContentNameLabel.text = model1.item[model1.defaultSelected.integerValue].name;
}
#pragma mark - setupUI
- (void)setupUI {
    self.statusNameLabel = [[UILabel alloc] init];
    self.statusNameLabel.text = @"状态: ";
    self.statusNameLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.statusNameLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.statusNameLabel];
    self.statusContentNameLabel = [[UILabel alloc] init];
    self.statusContentNameLabel.text = @"全部";
    self.statusContentNameLabel.textColor = [UIColor colorWithHexString:@"505f84"];
    self.statusContentNameLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.statusContentNameLabel];
    
    self.filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.filterButton setTitleColor:[UIColor colorWithHexString:@"505f84"] forState:UIControlStateNormal];
    WEAK_SELF
    [[self.filterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.filterButton.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.filterButton.enabled = YES;
        });
        BLOCK_EXEC(self.masterOverallRatingFilterButtonBlock);
    }];
    [self.filterButton setTitle:@"筛选" forState:UIControlStateNormal];
    [self.filterButton.titleLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
    [self addSubview:self.filterButton];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"筛选项目，选择后箭头"]];
    [self addSubview:self.imageView];
}
- (void)setupLayout {
    [self.statusNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15.0f);
    }];
    [self.statusContentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.statusNameLabel.mas_right);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10.0f);
        make.size.mas_offset(CGSizeMake(10.0f, 10.0f));
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_offset(CGSizeMake(48.0f, 30.0f));
    }];
}
@end
