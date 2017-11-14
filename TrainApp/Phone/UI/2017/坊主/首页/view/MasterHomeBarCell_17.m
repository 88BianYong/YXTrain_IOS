//
//  MasterHomeBarCell.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeBarCell_17.h"
@interface MasterHomeBarCell_17 ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *passLabel;
@end
@implementation MasterHomeBarCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setCountBar:(MasterIndexRequestItem_Body_CountBars *)countBar {
    _countBar = countBar;
    self.nameLabel.text = _countBar.name;
    NSString *passString = [NSString stringWithFormat:@"%@/%@ 通过",_countBar.passCount,_countBar.allCount];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:passString];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:YXFontMetro_Medium size:13.0f] range:NSMakeRange(0, passString.length - 2)];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(_countBar.passCount.length, _countBar.allCount.length)];
    self.passLabel.attributedText = attString;
}
#pragma mark - setupUI
- (void)setupUI{
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:13.0f];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.nameLabel];
    
    self.passLabel = [[UILabel alloc] init];
    self.passLabel.font = [UIFont systemFontOfSize:13.0f];
    self.passLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.passLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.passLabel];
}
- (void)setupLayout {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.passLabel.mas_left).offset(-40.0f);
    }];
    [self.passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_offset(60.0f);
    }];
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
