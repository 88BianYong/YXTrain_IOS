//
//  ActitvityCommentCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActitvityCommentCell.h"
@interface ActitvityCommentCell ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *favorLabel;
@property (nonatomic, strong) UIButton *favorButton;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation ActitvityCommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
    [self.contentView addSubview:self.topView];
    self.middleView = [[UIView alloc] init];
    self.middleView.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
    [self.contentView addSubview:self.middleView];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
    [self.contentView addSubview:self.bottomView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:15.0f];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.timeLabel];
    
    self.favorLabel = [[UILabel alloc] init];
    self.favorLabel.font = [UIFont systemFontOfSize:15.0f];
    self.favorLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    [self.contentView addSubview:self.favorLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:16.0f];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    self.favorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favorButton setImage:[UIImage imageNamed:@"点赞icon"] forState:UIControlStateNormal];
    [self.favorButton setImage:[UIImage imageNamed:@"点赞icon-点击状态"] forState:UIControlStateSelected];
    [self.favorButton addTarget:self action:@selector(favorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.favorButton];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"d2d8df"];
    [self.contentView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(56.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.middleView.mas_top).offset(2.0f);
        make.height.mas_offset(17.0f);
    }];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.bottom.equalTo(self.bottomView.mas_top).offset(2.0f);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(17.0f);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8.0f);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_left);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-25.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
    }];
    
    [self.favorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favorButton.mas_top);
        make.right.equalTo(self.favorButton.mas_left).offset(-6.0f);
    }];
    
    [self.favorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-13.0f - 10.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
        make.size.mas_offset(CGSizeMake(16.0f, 16.0f));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(15.0f);
        make.right.equalTo(self.topView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
}

#pragma mark - button Action
- (void)favorButtonAction:(UIButton *)sender{
    
}

#pragma mark - set
- (void)setReply:(ActivityFirstCommentRequestItem_Body_Replies *)reply{
    _reply = reply;
    self.nameLabel.text = reply.userName;
    self.timeLabel.text = reply.time;
    self.favorLabel.text = reply.up;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:reply.content?:@""];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7.0f;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [reply.content?:@"" length])];
    self.contentLabel.attributedText = attributedString;
}

- (void)setCellStatus:(ActitvityCommentCellStatus)cellStatus{
    _cellStatus = cellStatus;
    self.lineView.hidden = NO;
    if (_cellStatus == ActitvityCommentCellStatus_Top) {
        self.topView.layer.cornerRadius = YXTrainCornerRadii;
        self.bottomView.layer.cornerRadius = 0.0f;
        self.lineView.hidden = NO;
    }else if (_cellStatus == ActitvityCommentCellStatus_Middle) {
        self.topView.layer.cornerRadius = 0.0f;
        self.bottomView.layer.cornerRadius = 0.0f;
        self.lineView.hidden = YES;
    }else if (_cellStatus == ActitvityCommentCellStatus_Bottom){
        self.topView.layer.cornerRadius = 0.0f;
        self.bottomView.layer.cornerRadius = YXTrainCornerRadii;
        self.lineView.hidden = YES;
    }else if (_cellStatus == (ActitvityCommentCellStatus_Top|ActitvityCommentCellStatus_Bottom)){
        self.topView.layer.cornerRadius = YXTrainCornerRadii;
        self.bottomView.layer.cornerRadius = YXTrainCornerRadii;
        self.lineView.hidden = YES;
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
