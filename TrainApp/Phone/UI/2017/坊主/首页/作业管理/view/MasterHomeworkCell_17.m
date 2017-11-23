//
//  MasterHomeworkCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkCell_17.h"
@interface MasterHomeworkCell_17 ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *publishLabel;
@property (nonatomic, strong) UILabel *finishTimeLabel;

@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *nextImageView;
@end
@implementation MasterHomeworkCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.frame = [UIScreen mainScreen].bounds;
        [self layoutIfNeeded];
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
- (void)setHomework:(MasterHomeworkListItem_Body_Homework *)homework {
    for (UIView *view in self.contentView.subviews) {
        if (view.tag >= 100000) {
            [view removeFromSuperview];
        }
    }
    _homework = homework;
    NSString *string = [NSString stringWithFormat:@"%@分",[_homework.score yx_formatInteger]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:YXFontMetro_Medium size:14.0f] range:NSMakeRange(0, string.length)];
    self.scoreLabel.attributedText = attString;
    self.titleLabel.text = _homework.title;
    self.publishLabel.text = _homework.publishUser;
    self.finishTimeLabel.text = _homework.finishDate;
    [self setupHomeworkStatusScoreWidth:0.0f];
}

#pragma mark - setupUI
- (void)setupHomeworkStatusScoreWidth:(CGFloat)width {
    UIView *lastView = [[UIView alloc] init];
    [self.contentView addSubview:lastView];
    lastView.tag = 100000;
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.publishLabel.mas_bottom).offset(10.0f);
        make.height.mas_offset(20.0f);
        make.width.mas_offset(10.0f);
    }];
    width = width + 10.0f;
    if (self.homework.isSelfRecommend.boolValue) {
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
    if (self.homework.isMasterComment.boolValue) {//坊主点评
        UILabel *label = [[UILabel alloc] init];
        label.text = @"坊主点评";
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
                make.left.equalTo(self.contentView.mas_left).offset(15.0f);
                make.top.equalTo(lastView.mas_bottom).offset(10.0f);
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
                make.left.equalTo(self.contentView.mas_left).offset(15.0f);
                make.top.equalTo(lastView.mas_bottom).offset(10.0f);
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
    if (self.homework.isExpertRecommend.boolValue) {//专家推优
        UILabel *label = [[UILabel alloc] init];
        label.text = @"专家推优";
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
                make.left.equalTo(self.contentView.mas_left).offset(15.0f);
                make.top.equalTo(lastView.mas_bottom).offset(10.0f);
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
    if (self.homework.isMasterRecommend.boolValue) {//坊主推优
        UILabel *label = [[UILabel alloc] init];
        label.text = @"坊主推优";
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
                make.left.equalTo(self.contentView.mas_left).offset(15.0f);
                make.top.equalTo(lastView.mas_bottom).offset(10.0f);
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
    if (self.homework.isGrouperRecommend.boolValue) {//组长推优
        UILabel *label = [[UILabel alloc] init];
        label.text = @"组长推优";
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
                make.left.equalTo(self.contentView.mas_left).offset(15.0f);
                make.top.equalTo(lastView.mas_bottom).offset(10.0f);
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
    if (lastView.tag == 100000) {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomView.mas_top).offset(10.0f);
        }];
    }else {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomView.mas_top).offset(-10.0f);
        }];
        
    }

}
- (void)setupUI {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    
    self.publishLabel = [[UILabel alloc] init];
    self.publishLabel.font = [UIFont systemFontOfSize:11.0f];
    self.publishLabel.numberOfLines = 1;
    self.publishLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.publishLabel];
    
    self.finishTimeLabel = [[UILabel alloc] init];
    self.finishTimeLabel.font = [UIFont systemFontOfSize:11.0f];
    self.finishTimeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.finishTimeLabel];
    
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.scoreLabel.font = [UIFont systemFontOfSize:13.0f];
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
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
        make.right.equalTo(self.contentView.mas_right).offset(-25.0f);
    }];
    
    [self.publishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.0f);
    }];
    
    [self.finishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publishLabel.mas_right).offset(23.0f);
        make.top.equalTo(self.publishLabel.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12.0f);
        make.height.width.mas_equalTo(16.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextImageView.mas_left).offset(-30.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

@end
