//
//  YXSideTableViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXSideTableViewCell.h"
#import "TrainRedPointManger.h"

@interface YXSideTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *sideLabel;
@property (nonatomic, strong) UILabel *redPointLabel;
@property (nonatomic, assign) NSInteger redPointNumber;//-1隐藏,0小红点,>0大红点显示数,>99显示99+
@end

@implementation YXSideTableViewCell
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!selected) {
        self.iconImageView.image = self.nameDictionary[@"normalIcon"] ? [UIImage imageNamed:self.nameDictionary[@"normalIcon"]] : nil;
        self.sideLabel.textColor = [UIColor colorWithHexString:@"334466"];
    }
    self.redPointLabel.backgroundColor = [UIColor colorWithHexString:@"ed5836"];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.iconImageView.image = self.nameDictionary[@"hightIcon"] ? [UIImage imageNamed:self.nameDictionary[@"hightIcon"]]:nil;
        self.sideLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    }
    else{
        self.iconImageView.image = self.nameDictionary[@"normalIcon"] ? [UIImage imageNamed:self.nameDictionary[@"normalIcon"]] : nil;
        self.sideLabel.textColor = [UIColor colorWithHexString:@"334466"];
    }
    self.redPointLabel.backgroundColor = [UIColor colorWithHexString:@"ed5836"];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushWebSocketReceiveMessage:) name:kYXTrainPushWebSocketReceiveMessage object:nil];
    }
    return self;
}

- (void)setupUI {
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    
    self.sideLabel = [[UILabel alloc] init];
    self.sideLabel.font = [UIFont boldSystemFontOfSize:14];
    self.sideLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.sideLabel];
    
    self.redPointLabel = [[UILabel alloc] init];
    self.redPointLabel.backgroundColor = [UIColor colorWithHexString:@"ed5836"];
    self.redPointLabel.layer.cornerRadius = 2.5f;
    self.redPointLabel.textAlignment = NSTextAlignmentCenter;
    self.redPointLabel.textColor = [UIColor whiteColor];
    self.redPointLabel.font = [UIFont systemFontOfSize:12.0f];
    self.redPointLabel.clipsToBounds = YES;
    [self.contentView addSubview:self.redPointLabel];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.sideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(21);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.redPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sideLabel.mas_right).offset(2.0f);
        make.top.equalTo(self.sideLabel.mas_top).offset(-2.0f);
        make.size.mas_equalTo(CGSizeMake(5.0f, 5.0f));
    }];
}
- (void)setNameDictionary:(NSDictionary *)nameDictionary{
    _nameDictionary = nameDictionary;
    self.iconImageView.image = [UIImage imageNamed:self.nameDictionary[@"normalIcon"]];
    self.sideLabel.text = self.nameDictionary[@"title"];
}
- (void)pushWebSocketReceiveMessage:(NSNotification *)aNotofication {
    self.cellStatus = _cellStatus;
}
- (void)setCellStatus:(YXSideTableViewCellStatus)cellStatus {
    _cellStatus = cellStatus;
    switch (_cellStatus) {
        case YXSideTableViewCellStatus_Hotspot:
        {
            self.redPointNumber = [TrainRedPointManger sharedInstance].hotspotInteger > 0 ? 0 : - 1;
        }
            break;
        case YXSideTableViewCellStatus_Datum:
        {
            self.redPointNumber = -1 ;
        }
            break;
        case YXSideTableViewCellStatus_Workshop:
        {
            self.redPointNumber = -1;
        }
            break;
        case YXSideTableViewCellStatus_Dynamic:
        {
            self.redPointNumber = [TrainRedPointManger sharedInstance].dynamicInteger > 0 ? [TrainRedPointManger sharedInstance].dynamicInteger : - 1;
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
        self.redPointLabel.hidden = NO;
    }else if (_redPointNumber > 0 && _redPointNumber < 100) {
        [self.redPointLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15.0f, 15.0f));
        }];
        self.redPointLabel.layer.cornerRadius = 7.5f;
        self.redPointLabel.hidden = NO;
        self.redPointLabel.text = [NSString stringWithFormat:@"%ld",_redPointNumber];
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
