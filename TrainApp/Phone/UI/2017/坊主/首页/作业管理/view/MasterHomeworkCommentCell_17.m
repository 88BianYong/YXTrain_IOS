//
//  MasterHomeworkCommentCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkCommentCell_17.h"
@interface MasterHomeworkCommentCell_17 ()
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation MasterHomeworkCommentCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setRemark:(MasterHomeworkRemarkItem_Body_Remark *)remark {
    _remark = remark;
   [self.userImageView sd_setImageWithURL:[NSURL URLWithString:_remark.rId] placeholderImage:[UIImage imageNamed:@"个人信息默认用户头像"]];
    self.nameLabel.text = _remark.userName;
    self.timeLabel.text = _remark.publishDate;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2f;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:_remark.content?:@""];
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _remark.content.length)];
    self.commentLabel.attributedText = attString;
}
#pragma mark - setupUI
- (void)setupUI {
    self.userImageView = [[UIImageView alloc] init];
    self.userImageView.clipsToBounds = YES;
    self.userImageView.layer.cornerRadius = 18.0f;
    [self.contentView addSubview:self.userImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.nameLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:self.timeLabel];
    
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.commentLabel.font = [UIFont systemFontOfSize:14.0f];
    self.commentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.commentLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
        make.size.mas_offset(CGSizeMake(36.0f, 36.0f));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(15.0f);
        make.top.equalTo(self.userImageView.mas_top).offset(1.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(7.0f);
    }];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_left);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(13.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
    }];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self modifiDeleteBtn];
}
-(void)modifiDeleteBtn{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            subView.backgroundColor= [UIColor colorWithHexString:@"eb7467"];
            for (UIButton *btn in subView.subviews) {
                if ([btn isKindOfClass:[UIButton class]]) {
                    btn.backgroundColor=[UIColor colorWithHexString:@"eb7467"];
                    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
                    [btn setTitle:@"删除" forState:UIControlStateNormal];
                }
            }
        }
    }
}
@end
