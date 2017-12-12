//
//  MasterHomeworkHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkHeaderView_17.h"
@interface MasterHomeworkHeaderView_17 ()
@property (nonatomic, strong) UILabel *readNameLabel;
@property (nonatomic, strong) UILabel *readContentLabel;

@property (nonatomic, strong) UILabel *commendNameLabel;
@property (nonatomic, strong) UILabel *commendContetntLabel;

@property (nonatomic, strong) UILabel *recommendNameLabel;
@property (nonatomic, strong) UILabel *recommendContentLabel;

@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIImageView *imageView;

@end
@implementation MasterHomeworkHeaderView_17
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setFilterModel:(NSArray<LSTCollectionFilterDefaultModel *> *)filterModel {
    _filterModel = filterModel;
    LSTCollectionFilterDefaultModel *model1 = _filterModel[1];
    self.readContentLabel.text = model1.item[model1.defaultSelected.integerValue].name;
    LSTCollectionFilterDefaultModel *model2 = _filterModel[2];
    self.commendContetntLabel.text = model2.item[model2.defaultSelected.integerValue].name;
    LSTCollectionFilterDefaultModel *model3 = _filterModel[3];
    self.recommendContentLabel.text = model3.item[model3.defaultSelected.integerValue].name;
}
#pragma mark - setupUI
- (void)setupUI {
    self.readNameLabel = [[UILabel alloc] init];
    self.readNameLabel.text = @"状态: ";
    self.readNameLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.readNameLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:self.readNameLabel];
    self.readContentLabel = [[UILabel alloc] init];
    self.readContentLabel.text = @"全部";
    self.readContentLabel.textColor = [UIColor colorWithHexString:@"85898f"];
    self.readContentLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:self.readContentLabel];
    
    self.commendNameLabel = [[UILabel alloc] init];
    self.commendNameLabel.text = @"点评: ";
    self.commendNameLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.commendNameLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:self.commendNameLabel];
    self.commendContetntLabel = [[UILabel alloc] init];
    self.commendContetntLabel.text = @"全部";
    self.commendContetntLabel.textColor = [UIColor colorWithHexString:@"85898f"];
    self.commendContetntLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:self.commendContetntLabel];
    
    
    self.recommendNameLabel = [[UILabel alloc] init];
    self.recommendNameLabel.text = @"推优: ";
    self.recommendNameLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.recommendNameLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:self.recommendNameLabel];
    self.recommendContentLabel = [[UILabel alloc] init];
    self.recommendContentLabel.text = @"全部";
    self.recommendContentLabel.textColor = [UIColor colorWithHexString:@"85898f"];
    self.recommendContentLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:self.recommendContentLabel];

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
        BLOCK_EXEC(self.masterHomeworkFilterButtonBlock);
    }];
    [self.filterButton setTitle:@"筛选" forState:UIControlStateNormal];
    [self.filterButton.titleLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
    [self.contentView addSubview:self.filterButton];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"筛选项目，选择后箭头"]];
    [self.contentView addSubview:self.imageView];
    
}
- (void)setupLayout {
    [self.readNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
    }];
    [self.readContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.readNameLabel.mas_right);
    }];
    
    [self.commendNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.readContentLabel.mas_right).offset(15.0f);
    }];
    [self.commendContetntLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.commendNameLabel.mas_right);
    }];
    
    [self.recommendNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.commendContetntLabel.mas_right).offset(15.0f);
    }];
    [self.recommendContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.recommendNameLabel.mas_right);
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
