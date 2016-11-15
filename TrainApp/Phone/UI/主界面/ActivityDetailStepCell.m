//
//  ActivityDetailStepCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/10.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityDetailStepCell.h"
@interface ActivityDetailStepCell ()
@property (nonatomic, strong) UILabel *stepLabel;
@property (nonatomic, strong) UIView *pointView;
@property (nonatomic, strong) UIImageView *nextImageView;
@end

@implementation ActivityDetailStepCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        UIView *selectedBgView = [[UIView alloc] init];
        selectedBgView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 0.0f, kScreenWidth - 30.0f, 45.0f)];
        backgroundView.backgroundColor = [UIColor colorWithHexString:@"0070c9"];
        backgroundView.layer.cornerRadius = YXTrainCornerRadii;
        [selectedBgView addSubview:backgroundView];
        self.selectedBackgroundView = selectedBgView;
        [self setupUI];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.stepLabel.textColor = [UIColor whiteColor];
        self.pointView.backgroundColor = [UIColor colorWithHexString:@"334466"];
        self.nextImageView.image = [UIImage imageNamed:@"意见反馈展开箭头点击态"];
    }
    else{
        self.stepLabel.textColor = [UIColor colorWithHexString:@"334466"];
        self.pointView.backgroundColor = [UIColor colorWithHexString:@"334466"];
        self.nextImageView.image = [UIImage imageNamed:@"意见反馈展开箭头"];
    }
}

#pragma mark - setupUI
- (void)setupUI {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 0.0f, kScreenWidth - 30.0f, 45.0f)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backgroundView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backgroundView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(YXTrainCornerRadii, YXTrainCornerRadii)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = backgroundView.bounds;
    maskLayer.path = maskPath.CGPath;
    backgroundView.layer.mask = maskLayer;
    
    self.pointView = [[UIView alloc] init];
    self.pointView.layer.cornerRadius = 1.5f;
    self.pointView.backgroundColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.pointView];
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(3.0f, 3.0f));
        make.left.equalTo(self.mas_left).offset(30.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    self.nextImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.nextImageView];
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f - 11.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(16.0f, 16.0f));
    }];
    
    self.stepLabel = [[UILabel alloc] init];
    self.stepLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.stepLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.contentView addSubview:self.stepLabel];
    [self.stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pointView.mas_left).offset(9.0f);
        make.centerY.equalTo(self.mas_centerY);
        make.right.lessThanOrEqualTo(self.nextImageView.mas_left).offset(-15.0f);
    }];
}
#pragma mark - set
- (void)setSteps:(ActivityListRequestItem_Body_Activity_Steps *)steps {
    _steps = steps;
    self.stepLabel.text = steps.title;
}
@end
