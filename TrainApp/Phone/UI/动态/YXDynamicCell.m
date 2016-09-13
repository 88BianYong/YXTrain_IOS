//
//  YXDynamicCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXDynamicCell.h"
@interface YXDynamicCell()
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *timeLabel;
@property (nonatomic ,strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic ,strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *redPointView;

@end
@implementation YXDynamicCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self layoutInterface];
        [self mockData];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI{
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.image = [UIImage imageNamed:@"消息动态详情页icon-0"];
    [self.contentView addSubview:self.iconImageView];
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.contentView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.contentLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.contentLabel.numberOfLines = 2;
    [self.contentView addSubview:self.contentLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.timeLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:self.timeLabel];
        
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).priorityLow();
        make.height.mas_offset(1.0f / [UIScreen mainScreen].scale);
    }];
    
    self.redPointView = [[UIView alloc] init];
    self.redPointView.backgroundColor = [UIColor colorWithHexString:@"ed5836"];
    self.redPointView.layer.cornerRadius = 2.5f;
    [self.contentView addSubview:self.redPointView];
}
- (void)layoutInterface{
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.size.mas_offset(CGSizeMake(21.0f, 21.0f));
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    
    [self.redPointView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconImageView.mas_right);
        make.top.equalTo(self.iconImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(5.0f, 5.0f));
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(11.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-25.0f);
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-25.0f);
    }];
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(14.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
    }];

}

- (void)updateLayoutInterfaceSingle:(BOOL)boolSingle{//TD 解决单行Lable 出现行间距问题
    if (boolSingle){
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(10.0f);
        }];
    }
    else{
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(13.0f);
        }];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:YES];
    self.redPointView.backgroundColor = [UIColor colorWithHexString:@"ed5836"];
}

- (void)mockData{
    self.titleLabel.text = @"和水电费和山东省地方大家收发接口的回复:";
    self.contentLabel.attributedText = [self contentStringWithDesc:@"饭还是好地方是否六点十"];
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.timeLabel.text = @"30分钟前";
    [self.titleLabel sizeToFit];
    CGRect frame = self.titleLabel.frame;
    if (frame.size.width > kScreenWidth - 30.0f){
        [self updateLayoutInterfaceSingle:NO];
    }else{
        [self updateLayoutInterfaceSingle:YES];
    }
    
}
- (NSMutableAttributedString *)contentStringWithDesc:(NSString *)desc{
    NSRange range = NSMakeRange(0, desc.length);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:desc];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSParagraphStyleAttributeName:paragraphStyle} range:range];
    return attributedString;
}

@end
