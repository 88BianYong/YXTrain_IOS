//
//  YXHomeworkListCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
#import "YXHomeworkListCell.h"
@interface YXHomeworkListCell()
{
    UIView *_lineView;
    UIImageView *_typeImageView;//视频or非视频
    UILabel *_nameLabel;
    UILabel *_endDataLabel;
    UIImageView *_finishedImageView;
    UIImageView *_recommendImageView;
    UIImageView *_ismyrecImageView;
    
    CAShapeLayer *_maskLayer;
}
@end
@implementation YXHomeworkListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self layoutInterface];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI{
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 10.0f, 80.0f);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(YXTrainCornerRadii, YXTrainCornerRadii)];
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.frame = frame;
    _maskLayer.path = maskPath.CGPath;
    
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:_lineView];
    
    _typeImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_typeImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    _nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [self.contentView addSubview:_nameLabel];
    
    _endDataLabel = [[UILabel alloc] init];
    _endDataLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    _endDataLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:_endDataLabel];
    
    _finishedImageView = [[UIImageView alloc] init];
    _finishedImageView.hidden = NO;
    _finishedImageView.image = [UIImage imageNamed:@"作业-已完成标签"];
    [self.contentView addSubview:_finishedImageView];
    
    _recommendImageView = [[UIImageView alloc] init];
    _recommendImageView.image = [UIImage imageNamed:@"优标签"];
    [self.contentView addSubview:_recommendImageView];
    
    _ismyrecImageView = [[UIImageView alloc] init];
    _ismyrecImageView.image = [UIImage imageNamed:@"荐标签"];
    [self.contentView addSubview:_ismyrecImageView];
}

- (void)layoutInterface{
    UIView *topView = [[UIView alloc] init];
    [self.contentView addSubview:topView];
    UIView *bottomView = [[UIView alloc] init];
    [self.contentView addSubview:bottomView];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
        make.height.offset(0.5f);
    }];
    
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(bottomView.mas_height);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-100.0f);
        make.left.equalTo(self.contentView.mas_left).offset(30.0f);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    [_endDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(6.0f);
        make.left.equalTo(_nameLabel.mas_left);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [_typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(14.0f);
        make.centerY.equalTo(_nameLabel.mas_centerY);
        make.width.height.mas_offset(10.0f);
    }];
    
    [_finishedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.height.mas_offset(45.0f);
    }];
}

- (void)setHomework:(YXHomeworkListRequestItem_Body_Stages_Homeworks *)homework{
    _homework = homework;
    if (_homework != nil){
        if ([_homework.type isEqualToString:@"1"]) {
            _typeImageView.image = [UIImage imageNamed:@"作业名称图标"];
        }else{
            _typeImageView.image = [UIImage imageNamed:@"作业名称视频类的标签"];
        }
        _nameLabel.text = _homework.title;
        _nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
        _endDataLabel.text = [NSString stringWithFormat:@"截止日期  %@",_homework.createtime?:@"无"];
        _endDataLabel.hidden = NO;
        if([_homework.isFinished isEqualToString:@"1"]){
            _finishedImageView.hidden = NO;
        }
        else{
            _finishedImageView.hidden = YES;
        }
        [self layoutInterface:[_homework.recommend boolValue] withIsmyrec:[_homework.ismyrec boolValue]];
    }
    else{
        _typeImageView.image = [UIImage imageNamed:@"作业名称图标"];
        _nameLabel.text = @"该阶段无作业";
        _nameLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
        _finishedImageView.hidden = YES;
        _recommendImageView.hidden = YES;
        _ismyrecImageView.hidden = YES;
    }
}

- (void)layoutInterface:(BOOL)recommendBool withIsmyrec:(BOOL)ismyrecBool{
    [_recommendImageView removeFromSuperview];
    [_ismyrecImageView removeFromSuperview];
    if (recommendBool && ismyrecBool) {//全部都有
        _recommendImageView.hidden = NO;
        _ismyrecImageView.hidden = NO;
        [self.contentView addSubview:_recommendImageView];
        [self.contentView addSubview:_ismyrecImageView];
        [_recommendImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).offset(6.0f);
            make.centerY.equalTo(_nameLabel.mas_centerY);
            make.width.height.mas_offset(20.0f);
        }];
        [_ismyrecImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).offset(6.0f + 6.0f + 20.0f);
            make.centerY.equalTo(_nameLabel.mas_centerY);
            make.width.height.mas_offset(20.0f);
        }];
    }
    else{
        if (recommendBool){//只有优
            [self.contentView addSubview:_recommendImageView];
            [_recommendImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameLabel.mas_right).offset(6.0f);
                make.centerY.equalTo(_nameLabel.mas_centerY);
                make.width.height.mas_offset(20.0f);
            }];
        }
        if (ismyrecBool) {//只有荐
            [self.contentView addSubview:_ismyrecImageView];
            [_ismyrecImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nameLabel.mas_right).offset(6.0f);
                make.centerY.equalTo(_nameLabel.mas_centerY);
                make.width.height.mas_offset(20.0f);
            }];
            
        }
    }
}

- (void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    if (_isLast) {
        self.layer.mask = _maskLayer;
    }else{
        self.layer.mask = nil;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
