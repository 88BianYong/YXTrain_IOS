//
//  YXNoticeAndBulletinTableViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXNoticeAndBulletinTableViewCell.h"
#import "NSDate+Utilities.h"

@interface YXNoticeAndBulletinTableViewCell ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *middleSircleView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *publisherLabel;


@end

@implementation YXNoticeAndBulletinTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    //UIView *selectedBgView = [[UIView alloc]init];
    //selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    //self.selectedBackgroundView = selectedBgView;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.topView];
    
    self.middleSircleView = [[UIView alloc] init];
    self.middleSircleView.backgroundColor = [UIColor whiteColor];
    self.middleSircleView.layer.borderColor = [[UIColor colorWithHexString:@"eceef2"] CGColor];
     self.middleSircleView.layer.borderWidth = 3.0f;
    [self.contentView addSubview:self.middleSircleView];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.bottomView];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = @"k快上课打瞌睡克利夫兰是否快乐的时间浪费快乐的时刻";
    self.contentLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.contentLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:self.contentLabel];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.text = @"2016-06-07";
    self.dateLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.dateLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:self.dateLabel];
    
    self.publisherLabel = [[UILabel alloc] init];
    self.publisherLabel.text = @"by YANXIAOBU";
    self.publisherLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.publisherLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:self.publisherLabel];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.middleSircleView.mas_centerX);
        make.bottom.mas_equalTo(self.middleSircleView.mas_top);
        make.size.mas_equalTo(CGSizeMake(2, 25.5));
    }];
    
    [self.middleSircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(21);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    self.middleSircleView.layer.cornerRadius = 6.5;
    self.middleSircleView.layer.masksToBounds = YES;
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.middleSircleView.mas_bottom);
        make.centerX.mas_equalTo(self.middleSircleView.mas_centerX);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(2, 25.5));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.middleSircleView.mas_centerY);
        make.left.mas_equalTo(self.middleSircleView.mas_right).offset(14);
        make.right.mas_lessThanOrEqualTo(-15);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentLabel.mas_left);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(8);
    }];
    
    [self.publisherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.dateLabel.mas_centerY);
        make.left.mas_equalTo(self.dateLabel.mas_right).offset(10);
        make.right.mas_lessThanOrEqualTo(-15);
    }];
}
- (void)configUIwithItem:(YXNoticeAndBulletinItem *)item isFirstOne:(BOOL)isFirstOne isLastOne:(BOOL)isLastOne{
    if (isFirstOne) {
        self.topView.hidden = YES;
    } else {
        self.topView.hidden = NO;
    }
    if (isLastOne) {
        self.bottomView.hidden = YES;
    } else {
        self.bottomView.hidden = NO;
    }
    self.contentLabel.text = item.title;
    self.dateLabel.text = item.createDate;
    self.publisherLabel.text = [NSString stringWithFormat:@"by %@",item.userName];
}


@end
