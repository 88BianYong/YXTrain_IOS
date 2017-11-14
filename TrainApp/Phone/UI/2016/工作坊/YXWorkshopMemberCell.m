//
//  YXWorkshopMenberCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopMemberCell.h"
@interface YXWorkshopMemberCell()
{
    UIImageView *_headImageView;
    UILabel *_nameLabel;
}
@end

@implementation YXWorkshopMemberCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self layoutInterface];
    }
    return self;
}

- (void)setupUI{
    _headImageView = [[UIImageView alloc] init];
    _headImageView.image = [UIImage imageNamed:@"成员大头像"];
    _headImageView.layer.cornerRadius = 30.0f;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentView addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:12.0f];
    _nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
}

- (void)layoutInterface{
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(60.0f);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self->_nameLabel.mas_top).offset(-10.0f);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(10.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.height.offset(12.0f);
    }];
}

#pragma mark - reloadData
- (void)setList:(YXWorkshopMemberRequestItem_memberList *)list{
    _list = list;
    _nameLabel.text = list.realName;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:list.head] placeholderImage:[UIImage imageNamed:@"成员大头像"]];
}
@end
