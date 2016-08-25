//
//  YXWriteHomeworkInfoCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
@interface YXWriteView : UIView
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *stateImageView;
@end

@implementation YXWriteView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithHexString:@"334466"];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_contentLabel];
        
        _stateImageView = [[UIImageView alloc] init];
        [_stateImageView setImage:[UIImage imageNamed:@"第一阶段展开箭头"]];
//        [_openUpButton setImage: forState:UIControlStateNormal];
//        [_openUpButton setImage:[UIImage imageNamed:@"第一阶段展开收起箭头"] forState:UIControlStateSelected];
        [self addSubview:_stateImageView];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15.0f);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(_stateImageView.mas_left).offset(21.0f);
        }];
        
        [_stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-16.0f);
            make.centerY.equalTo(self.mas_centerY);
            make.width.height.mas_offset(15.0f);
        }];
    }
    return self;
}

@end


#import "YXWriteHomeworkInfoCell.h"
@interface YXWriteHomeworkInfoCell()
{
    UILabel *_titleLabel;
    YXWriteView *_writeView;
    
}
@end
@implementation YXWriteHomeworkInfoCell
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
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"学段";
    [self.contentView addSubview:_titleLabel];
    
    _writeView = [[YXWriteView alloc] init];
    _writeView.layer.cornerRadius = YXTrainCornerRadii;
    [self.contentView addSubview:_writeView];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_writeView addGestureRecognizer:recognizer];
}

- (void)layoutInterface{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.width.mas_offset(55.0f);
        make.top.equalTo(self.contentView.mas_top).offset(10.0f);
        make.height.mas_offset(40.0f);
    }];
    
    [_writeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(10.0f);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    _titleLabel.text = _titleString;
}

- (void)setContentString:(NSString *)contentString{
    _contentString = contentString;
    _writeView.contentLabel.text = _contentString;
}

- (void)setIsEnabled:(BOOL)isEnabled{
    _isEnabled = isEnabled;
    if (_isEnabled) {
        _writeView.stateImageView.image = [UIImage imageNamed:@"第一阶段展开箭头A"];
        _writeView.stateImageView.hidden = NO;
    }else{
        _writeView.stateImageView.hidden = YES;
    }
    //第一阶段展开收起箭头
}
#pragma mark - button Action
- (void)tapAction:(UITapGestureRecognizer *)sender{
    if (_isEnabled) {
        _writeView.stateImageView.image = [UIImage imageNamed:@"第一阶段展开收起箭头"];
        BLOCK_EXEC(self.openCloseHandler,sender.view,self.status);
    }
}

@end
