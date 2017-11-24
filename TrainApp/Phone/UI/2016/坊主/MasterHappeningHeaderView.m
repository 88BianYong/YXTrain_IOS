//
//  MasterHappeningHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHappeningHeaderView.h"
@interface MasterHappeningHeaderView ()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIView *lineView;

@end
@implementation MasterHappeningHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.typeImageView = [[UIImageView  alloc] init];
    [self.contentView addSubview:self.typeImageView];
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.typeLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.typeLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"e7e8ec"];
    [self.contentView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.0f);
        make.size.mas_offset(CGSizeMake(24.0f, 24.0f));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeImageView.mas_right).offset(3.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
}
#pragma mark - set
- (void)setPowerInteger:(NSInteger)powerInteger {
    _powerInteger = powerInteger;
    switch (_powerInteger) {
        case 1:
        {
            self.typeImageView.image = [UIImage imageNamed:@"组织力icon"];
            self.typeLabel.text = @"研修组织力";
            [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.typeImageView.mas_right).offset(3.0f);
            }];
        }
            break;
        case 2:
        {
            self.typeImageView.image = [UIImage imageNamed:@"研修指导力icon"];
            self.typeLabel.text = @"研修指导力";
            [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.typeImageView.mas_right).offset(3.0f);
            }];
        }
            break;
        case 3:
        {
            self.typeImageView.image = [UIImage imageNamed:@"学习力icon"];
            self.typeLabel.text = @"学习力";
            [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.typeImageView.mas_right).offset(3.0f);
            }];
        }
            break;
        case 4:
        {
            self.typeImageView.image = [UIImage imageNamed:@"学习力icon"];
            self.typeLabel.text = @"在线考试";
            [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.typeImageView.mas_right).offset(3.0f);
            }];
        }
            break;
        case 5:
        {
            self.typeImageView.image = [UIImage imageNamed:@"策划力-培训力"];
            self.typeLabel.text = @"研修策划力";
            [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.typeImageView.mas_right).offset(4.0f);
            }];
        }
            break;
        case 6:
        {
            self.typeImageView.image = [UIImage imageNamed:@"策划力-培训力"];
            self.typeLabel.text = @"研修培训力";
            [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.typeImageView.mas_right).offset(4.0f);
            }];
        }
            break;
            
        default:
            break;
    }
}
@end
