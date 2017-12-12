//
//  MasterManageActiveListHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageActiveListHeaderView_17.h"
@interface MasterManageActiveListHeaderView_17 ()
@property (nonatomic, strong) UILabel *segmentNameLabel;
@property (nonatomic, strong) UILabel *segmentContentLabel;
@property (nonatomic, strong) UILabel *studyNameLabel;
@property (nonatomic, strong) UILabel *studyContentLabel;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MasterManageActiveListHeaderView_17
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
    LSTCollectionFilterDefaultModel *model1 = _filterModel[3];
    self.segmentContentLabel.text = model1.item[model1.defaultSelected.integerValue].name;
    LSTCollectionFilterDefaultModel *model2 = _filterModel[4];
    self.studyContentLabel.text = model2.item[model2.defaultSelected.integerValue].name;
}
#pragma mark - setupUI
- (void)setupUI {
    self.segmentNameLabel = [[UILabel alloc] init];
    self.segmentNameLabel.text = @"学段: ";
    self.segmentNameLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.segmentNameLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.segmentNameLabel];
    self.segmentContentLabel = [[UILabel alloc] init];
    self.segmentContentLabel.text = @"初中";
    self.segmentContentLabel.textColor = [UIColor colorWithHexString:@"505f84"];
    self.segmentContentLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.segmentContentLabel];
    
    self.studyNameLabel = [[UILabel alloc] init];
    self.studyNameLabel.text = @"学科: ";
    self.studyNameLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.studyNameLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.studyNameLabel];
    self.studyContentLabel = [[UILabel alloc] init];
    self.studyContentLabel.text = @"数学";
    self.studyContentLabel.textColor = [UIColor colorWithHexString:@"505f84"];
    self.studyContentLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.studyContentLabel];
    
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
    [self addSubview:self.filterButton];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"筛选项目，选择后箭头"]];
    [self addSubview:self.imageView];
}
- (void)setupLayout {
    [self.segmentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15.0f);
    }];
    [self.segmentContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.segmentNameLabel.mas_right);
    }];
    
    [self.studyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.segmentContentLabel.mas_right).offset(15.0f);
    }];
    [self.studyContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.studyNameLabel.mas_right);
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
