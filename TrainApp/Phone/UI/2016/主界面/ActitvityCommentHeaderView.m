//
//  ActitvityCommentHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActitvityCommentHeaderView.h"
@interface ActitvityCommentHeaderView ()
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *favorLabel;
@property (nonatomic, strong) UIButton *favorButton;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *lineView;



@property (nonatomic, copy) ActitvityCommentFavorBlock favorBlock;
@property (nonatomic, copy) ActitvityCommentReplyBlock replyBlock;
@property (nonatomic, copy) ActitvityCommentDeleteBlock deleteBlock;



@end
@implementation ActitvityCommentHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.frame = [UIScreen mainScreen].bounds;
        [self layoutIfNeeded];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self);
    }];
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.layer.cornerRadius = 18.0f;
    self.headerImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.headerImageView];
    
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
    self.contentLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    self.favorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favorButton setImage:[UIImage imageNamed:@"点赞icon"] forState:UIControlStateNormal];
    [self.favorButton setImage:[UIImage imageNamed:@"点赞icon-点击状态"] forState:UIControlStateDisabled];
    [self.favorButton addTarget:self action:@selector(favorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.favorButton];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyCommentAction:)];
    [self.contentView addGestureRecognizer:recognizer];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    self.deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.deleteButton setTitleColor:[UIColor colorWithHexString:@"efa280"] forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(15.0f);
        make.size.mas_offset(CGSizeMake(36.0f, 36.0f));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6.0f- 2.0f);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(8.0f);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.width.mas_offset(40.0f);
        make.height.mas_offset(20.0f);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_left);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(9.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.0f);
    }];
    
    [self.favorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favorButton.mas_top).offset(5.0f);
        make.right.equalTo(self.favorButton.mas_left).offset(2.0f);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(11.0f);
        make.top.equalTo(self.headerImageView.mas_top);
        make.right.mas_lessThanOrEqualTo(self.favorLabel.mas_left);
    }];
    [self.favorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-25.0f + 8.0f);
        make.top.equalTo(self.headerImageView.mas_top).offset(0.0f);
        make.size.mas_offset(CGSizeMake(32.0f, 16.0f + 3.0f + 3.0f));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(63.0f);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
}

#pragma mark - button Action
- (void)favorButtonAction:(UIButton *)sender{
    BLOCK_EXEC(self.favorBlock);
}
- (void)deleteButtonAction:(UIButton *)sender {
    BLOCK_EXEC(self.deleteBlock,sender);
}
- (void)replyCommentAction:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.contentView];
    if (sender.state == UIGestureRecognizerStateEnded &&
        !CGRectContainsPoint(self.favorButton.frame,point)) {
        BLOCK_EXEC(self.replyBlock,self.replie);
    }else {
        [(YXBaseViewController *)[self yx_viewController] showToast:@"您已经赞过了哦"];
    }
}

#pragma mark - set
- (void)setReplie:(ActivityFirstCommentRequestItem_Body_Replies *)replie{
    _replie = replie;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:replie.headUrl] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    self.nameLabel.text = _replie.userName;
    self.timeLabel.text = _replie.time;
    if (_replie.up.integerValue >= 10000) {
        self.favorLabel.text = @"9999+";
    }else {
        self.favorLabel.text = _replie.up;
    }
    if ([_replie.isRanked isEqualToString:@"true"]) {
        self.favorButton.enabled = NO;
        self.favorLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    }else {
        self.favorButton.enabled = YES;
        self.favorLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    }
    if (![self isFormatContent:replie.content?:@""]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:replie.content?:@""];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7.0f;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [replie.content?:@"" length])];
        self.contentLabel.attributedText = attributedString;
    }else {
        self.contentLabel.attributedText = [self formatSenondCommentContnet:replie.content];
    }
}
- (void)setIsShowLine:(BOOL)isShowLine {
    _isShowLine = isShowLine;
    self.lineView.hidden = !_isShowLine;
}
//判断是否为15年2级评论
- (BOOL)isFormatContent:(NSString *)contentString {
    NSRange contentRange = [contentString rangeOfString:kContentSeparator];
    NSRange nameRange = [contentString rangeOfString:kNameSeparator];
    return (contentRange.location != NSNotFound) &&
    (nameRange.location != NSNotFound) &&
    (contentRange.location > nameRange.location) &&
    (self.stageId.integerValue == 0);
}
- (NSMutableAttributedString *)formatSenondCommentContnet:(NSString *)content {
    NSRange contentRange = [content rangeOfString:kContentSeparator];
    NSString *contentString = [content substringFromIndex:contentRange.location + contentRange.length];
    NSRange nameRange = [[content substringToIndex:contentRange.location] rangeOfString:kNameSeparator];
    NSString *nameString = [[content substringToIndex:contentRange.location] substringFromIndex:nameRange.length + nameRange.location];
    NSString *tempString = [NSString stringWithFormat:@"回复%@: %@",nameString,contentString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tempString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7.0f;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tempString length])];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"a1a7ae"]} range:NSMakeRange(0, [nameString length] + 3)];
    return attributedString;
}

//- (void)setDistanceTop:(CGFloat)distanceTop {
//    _distanceTop = distanceTop;
//    [self.headerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).offset(_distanceTop);
//    }];
//}
- (void)setIsFontBold:(BOOL)isFontBold {
    _isFontBold = isFontBold;
    if (_isFontBold) {
        self.contentLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    }else{
        self.contentLabel.font = [UIFont systemFontOfSize:16.0f];
    }
}
- (void)setIsShowDelete:(BOOL)isShowDelete {
    _isShowDelete = isShowDelete;
    self.deleteButton.hidden = !_isShowDelete;
}
- (void)setActitvityCommentFavorBlock:(ActitvityCommentFavorBlock)block {
    self.favorBlock = block;
}
- (void)setActitvityCommentReplyBlock:(ActitvityCommentReplyBlock)block {
    self.replyBlock = block;
}
- (void)setActitvityCommentDeleteBlock:(ActitvityCommentDeleteBlock)block {
    self.deleteBlock = block;
}
@end
