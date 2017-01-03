//
//  BeijingDynamicCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingDynamicCell.h"
@interface BeijingDynamicCell ()
@property (nonatomic ,strong) UILabel *timeLabel;
@property (nonatomic ,strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic ,strong) UIImageView *iconImageView;
@end
@implementation BeijingDynamicCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self setupLayout];
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
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.contentLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.timeLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:self.timeLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.lineView];
    
}
- (void)setupLayout {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(14.0f);
        make.size.mas_offset(CGSizeMake(21.0f, 21.0f));
    }];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(14.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-25.0f);
    }];
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_left);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(14.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).priorityLow();
        make.height.mas_offset(1.0f / [UIScreen mainScreen].scale);
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
}

- (void)setData:(YXDynamicRequestItem_Data *)data{
    self.contentLabel.attributedText = [self contentStringWithDesc:data.title];
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.timeLabel.text = data.timer;
    [self.contentLabel sizeToFit];
    CGRect frame = self.contentLabel.frame;
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
