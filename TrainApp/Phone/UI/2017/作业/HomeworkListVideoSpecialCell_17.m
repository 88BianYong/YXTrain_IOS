//
//  HomeworkListVideoSpecialCell.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "HomeworkListVideoSpecialCell_17.h"
@interface HomeworkListVideoSpecialCell_17 ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *submitTimeLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *nextImageView;

@end
@implementation HomeworkListVideoSpecialCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!selected) {
        self.nextImageView.image = [UIImage imageNamed:@"意见反馈展开箭头"];
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.nextImageView.image = [UIImage imageNamed:@"意见反馈展开箭头点击态"];
    }
    else{
        self.nextImageView.image = [UIImage imageNamed:@"意见反馈展开箭头"];
    }
}
#pragma mark - set
- (void)setHomework:(HomeworkListRequest_17Item_Homeworks *)homework {
    for (UIView *view in self.contentView.subviews) {
        if (view.tag >= 100000) {
            [view removeFromSuperview];
        }
    }
    _homework = homework;
    self.titleLabel.text = _homework.title;
    self.subTitleLabel.text = _homework.desc;
    self.submitTimeLabel.text = [NSString stringWithFormat:@"提交时间 %@",_homework.createTime];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@分",_homework.score];
    [self.scoreLabel sizeToFit];
    [self setupHomeworkStatusScoreWidth:self.scoreLabel.frame.size.width];
}

#pragma mark - setupUI
- (void)setupHomeworkStatusScoreWidth:(CGFloat)width {
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.submitTimeLabel.mas_bottom).offset(9.0f);
    }];
    UIView *lastView = [[UIView alloc] init];
    [self.contentView addSubview:lastView];
    lastView.tag = 100000;
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreLabel.mas_right);
        make.centerY.equalTo(self.scoreLabel.mas_centerY);
        make.height.equalTo(self.scoreLabel.mas_height);
        make.width.mas_offset(16.0f);
    }];
    width = width + 16.0f + 20.0f;
    if (self.homework.ismyrec.boolValue) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"自荐";
        label.tag = 100001;
        label.layer.cornerRadius = YXTrainCornerRadii;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:8.0f];
        label.backgroundColor = [UIColor colorWithHexString:@"99a1b2"];
        [self.contentView addSubview:label];
        width = width + 30.0f;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView.mas_right).offset(5.0f);
            make.centerY.equalTo(lastView.mas_centerY);
            make.size.mas_offset(CGSizeMake(25.0f, 20.0f));
        }];
        lastView = label;
    }
    if (self.homework.isExpertComment.boolValue) {//专家点评
        UILabel *label = [[UILabel alloc] init];
        label.text = @"专家点评";
        label.tag = 100003;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = YXTrainCornerRadii;
        label.font = [UIFont systemFontOfSize:8.0f];
        label.backgroundColor = [UIColor colorWithHexString:@"f3b6b9"];
        [self.contentView addSubview:label];
        width = width + 46.0f;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView.mas_right).offset(5.0f);
            make.centerY.equalTo(lastView.mas_centerY);
            make.size.mas_offset(CGSizeMake(41.0f, 20.0f));
        }];
        lastView = label;
    }
    if (self.homework.isMasterComment.boolValue) {//组长点评
        UILabel *label = [[UILabel alloc] init];
        label.text = @"组长点评";
        label.tag = 100004;
        label.textColor = [UIColor whiteColor];
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = YXTrainCornerRadii;
        label.font = [UIFont systemFontOfSize:8.0f];
        label.backgroundColor = [UIColor colorWithHexString:@"f3b6b9"];
        [self.contentView addSubview:label];
        width = width + 46.0f;
        if (width >= kScreenWidth) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scoreLabel.mas_left).offset(15.0f);
                make.top.equalTo(self.scoreLabel.mas_bottom).offset(10.0f);
                make.size.mas_offset(CGSizeMake(41.0f, 20.0f));
            }];
            width = 0.0f;
        }else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(5.0f);
                make.centerY.equalTo(lastView.mas_centerY);
                make.size.mas_offset(CGSizeMake(41.0f, 20.0f));
            }];
        }
        lastView = label;
    }
    if (self.homework.isGrouperComment.boolValue) {//组长点评
        UILabel *label = [[UILabel alloc] init];
        label.text = @"组长点评";
        label.tag = 100005;
        label.textColor = [UIColor whiteColor];
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = YXTrainCornerRadii;
        label.font = [UIFont systemFontOfSize:8.0f];
        label.backgroundColor = [UIColor colorWithHexString:@"f3b6b9"];
        [self.contentView addSubview:label];
        width = width + 46.0f;
        if (width >= kScreenWidth) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scoreLabel.mas_left).offset(15.0f);
                make.top.equalTo(self.scoreLabel.mas_bottom).offset(10.0f);
                make.size.mas_offset(CGSizeMake(41.0f, 20.0f));
            }];
            width = 0.0f;
        }else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(5.0f);
                make.centerY.equalTo(lastView.mas_centerY);
                make.size.mas_offset(CGSizeMake(41.0f, 20.0f));
            }];
        }
        lastView = label;
    }
    if (self.homework.isExpertRecommend.boolValue) {//专家推荐
        UILabel *label = [[UILabel alloc] init];
        label.text = @"专家推荐";
        label.tag = 100006;
        label.textColor = [UIColor whiteColor];
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = YXTrainCornerRadii;
        label.font = [UIFont systemFontOfSize:8.0f];
        label.backgroundColor = [UIColor colorWithHexString:@"7fb7e4"];
        [self.contentView addSubview:label];
        width = width + 46.0f;
        if (width >= kScreenWidth) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scoreLabel.mas_left).offset(15.0f);
                make.top.equalTo(self.scoreLabel.mas_bottom).offset(10.0f);
                make.size.mas_offset(CGSizeMake(41.0f, 20.0f));
            }];
            width = 0.0f;
        }else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(5.0f);
                make.centerY.equalTo(lastView.mas_centerY);
                make.size.mas_offset(CGSizeMake(41.0f, 20.0f));
            }];
        }
        lastView = label;
    }
    if (self.homework.isMasterRecommend.boolValue) {//坊主推荐
        UILabel *label = [[UILabel alloc] init];
        label.text = @"坊主推荐";
        label.tag = 100007;
        label.textColor = [UIColor whiteColor];
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = YXTrainCornerRadii;
        label.font = [UIFont systemFontOfSize:8.0f];
        label.backgroundColor = [UIColor colorWithHexString:@"7fb7e4"];
        [self.contentView addSubview:label];
        width = width + 46.0f;
        if (width >= kScreenWidth) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scoreLabel.mas_left).offset(15.0f);
                make.top.equalTo(self.scoreLabel.mas_bottom).offset(10.0f);
                make.size.mas_offset(CGSizeMake(41.0f, 20.0f));
            }];
            width = 0.0f;
        }else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(5.0f);
                make.centerY.equalTo(lastView.mas_centerY);
                make.size.mas_offset(CGSizeMake(41.0f, 20.0f));
            }];
        }
        lastView = label;
    }
    if (self.homework.isGrouperRecommend.boolValue) {//组长推荐
        UILabel *label = [[UILabel alloc] init];
        label.text = @"组长推荐";
        label.tag = 100008;
        label.textColor = [UIColor whiteColor];
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = YXTrainCornerRadii;
        label.font = [UIFont systemFontOfSize:8.0f];
        label.backgroundColor = [UIColor colorWithHexString:@"7fb7e4"];
        [self.contentView addSubview:label];
        width = width + 46.0f;
        if (width >= kScreenWidth) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scoreLabel.mas_left).offset(15.0f);
                make.top.equalTo(self.scoreLabel.mas_bottom).offset(10.0f);
                make.size.mas_offset(CGSizeMake(41.0f, 20.0f));
            }];
            width = 0.0f;
        }else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right).offset(5.0f);
                make.centerY.equalTo(lastView.mas_centerY);
                make.size.mas_offset(CGSizeMake(41.0f, 20.0f));
            }];
        }
        lastView = label;
    }
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top).offset(-10.0f);
    }];
    
    
}
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:11.0f];
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.subTitleLabel];
    
    self.submitTimeLabel = [[UILabel alloc] init];
    self.submitTimeLabel.font = [UIFont systemFontOfSize:11.0f];
    self.submitTimeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.submitTimeLabel];
    
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = [UIFont systemFontOfSize:11.0f];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    [self.contentView addSubview:self.scoreLabel];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.contentView addSubview:self.bottomView];
    self.nextImageView = [[UIImageView alloc] init];
    self.nextImageView.image = [UIImage imageNamed:@"意见反馈展开箭头"];
    [self.contentView addSubview:self.nextImageView];

}
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(12.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
    }];
    
    [self.submitTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(9.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(5.0f);
    }];
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12.0f);
        make.height.width.mas_equalTo(16.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

@end

