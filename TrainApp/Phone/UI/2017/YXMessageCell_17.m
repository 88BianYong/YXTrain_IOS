//
//  YXMessageCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXMessageCell_17.h"
@interface YXMessageCell_17 ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UILabel *redPointLabel;
@property (nonatomic, assign) NSInteger redPointNumber;//-1隐藏,0小红点,>0大红点显示数,>99显示99+
@end
@implementation YXMessageCell_17
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushWebSocketReceiveMessage:) name:kYXTrainPushWebSocketReceiveMessage object:nil];
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
        self.iconImageView.image = self.nameDictionary[@"normalIcon"] ? [UIImage imageNamed:self.nameDictionary[@"normalIcon"]] : nil;
        self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    }
    self.redPointLabel.backgroundColor = [UIColor colorWithHexString:@"ed5836"];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.iconImageView.image = self.nameDictionary[@"hightIcon"] ? [UIImage imageNamed:self.nameDictionary[@"hightIcon"]]:nil;
        self.nameLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    }
    else{
        self.iconImageView.image = self.nameDictionary[@"normalIcon"] ? [UIImage imageNamed:self.nameDictionary[@"normalIcon"]] : nil;
        self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    }
    self.redPointLabel.backgroundColor = [UIColor colorWithHexString:@"ed5836"];
}
- (void)setupUI {
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.nameLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.lineView];
    
    self.nextImageView = [[UIImageView alloc] init];
    self.nextImageView.image = [UIImage imageNamed:@"意见反馈展开箭头"];
    [self.contentView addSubview:self.nextImageView];
    
    self.redPointLabel = [[UILabel alloc] init];
    self.redPointLabel.backgroundColor = [UIColor colorWithHexString:@"ed5836"];
    self.redPointLabel.layer.cornerRadius = 2.5f;
    self.redPointLabel.textAlignment = NSTextAlignmentCenter;
    self.redPointLabel.textColor = [UIColor whiteColor];
    self.redPointLabel.font = [UIFont systemFontOfSize:12.0f];
    self.redPointLabel.adjustsFontSizeToFitWidth = YES;
    self.redPointLabel.clipsToBounds = YES;
    [self.contentView addSubview:self.redPointLabel];
}
- (void)setupLayout {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(11);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).priorityLow();
        make.height.mas_offset(1.0f / [UIScreen mainScreen].scale);
    }];
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12.0f);
        make.height.width.mas_equalTo(16.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.redPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(2.0f);
        make.top.equalTo(self.nameLabel.mas_top).offset(-2.0f);
        make.size.mas_equalTo(CGSizeMake(5.0f, 5.0f));
    }];
    
}
- (void)setNameDictionary:(NSDictionary *)nameDictionary{
    _nameDictionary = nameDictionary;
    self.iconImageView.image = [UIImage imageNamed:self.nameDictionary[@"normalIcon"]];
    self.nameLabel.text = self.nameDictionary[@"title"];
}
- (void)pushWebSocketReceiveMessage:(NSNotification *)aNotofication {
    self.cellStatus = _cellStatus;
}

- (void)setCellStatus:(YXMessageCellStatus)cellStatus{
    _cellStatus = cellStatus;
    switch (_cellStatus) {
        case YXMessageCellStatus_Hotspot:
        {
            self.redPointNumber = [LSTSharedInstance sharedInstance].redPointManger.hotspotInteger > 0 ? 0 : - 1;
        }
            break;
        case YXMessageCellStatus_Dynamic:
        {
            self.redPointNumber = [LSTSharedInstance sharedInstance].redPointManger.dynamicInteger > 0 ? [LSTSharedInstance sharedInstance].redPointManger.dynamicInteger : - 1;
        }
            break;
    }
}
- (void)setRedPointNumber:(NSInteger)redPointNumber {
    _redPointNumber = redPointNumber;
    if (_redPointNumber < 0) {
        self.redPointLabel.hidden = YES;
    }else if (_redPointNumber == 0) {
        [self.redPointLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(5.0f, 5.0f));
        }];
        self.redPointLabel.layer.cornerRadius = 2.5f;
        self.redPointLabel.text = @"";
        self.redPointLabel.hidden = NO;
    }else if (_redPointNumber > 0 && _redPointNumber < 100) {
        [self.redPointLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15.0f, 15.0f));
        }];
        self.redPointLabel.layer.cornerRadius = 7.5f;
        self.redPointLabel.hidden = NO;
        self.redPointLabel.text = [NSString stringWithFormat:@"%ld",(long)_redPointNumber];
    }else {
        [self.redPointLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25.0f, 15.0f));
        }];
        self.redPointLabel.layer.cornerRadius = 7.5f;
        self.redPointLabel.hidden = NO;
        self.redPointLabel.text = @"99+";
    }
}
@end
