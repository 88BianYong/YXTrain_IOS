//
//  VideoCourseCommentHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseCommentHeaderView.h"
@interface VideoCourseCommentHeaderView ()
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *favorLabel;
@property (nonatomic, strong) UIButton *favorButton;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) CourseCommentsFavorBlock favorBlock;
@property (nonatomic, copy) CourseCommentsFullReplyBlock fullReplyBlock;
@end
@implementation VideoCourseCommentHeaderView
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
    self.favorLabel.hidden = YES;
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
    self.favorButton.hidden = YES;
    [self.contentView addSubview:self.favorButton];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allCommentAction:)];
    [self.contentView addGestureRecognizer:recognizer];
    
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
    if (sender.selected) {
        [(YXBaseViewController *)[self viewController] showToast:@"您已经赞过了哦"];
    }else {
        BLOCK_EXEC(self.favorBlock);
    }
}
- (void)allCommentAction:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.contentView];
    if (sender.state == UIGestureRecognizerStateEnded &&
        !CGRectContainsPoint(self.favorButton.frame,point)) {
        BLOCK_EXEC(self.fullReplyBlock,self.comment);
    }else {
        [(YXBaseViewController *)[self viewController] showToast:@"您已经赞过了哦"];
    }
}
#pragma mark - set
- (void)setComment:(VideoCourseCommentsRequestItem_Body_Comments *)comment {
    _comment = comment;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:_comment.ap] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    self.nameLabel.text = _comment.userName;
    self.timeLabel.text = _comment.timeDesc;
    if (_comment.laudNumber.integerValue >= 10000) {
        self.favorLabel.text = @"9999+";
    }else {
        self.favorLabel.text = _comment.laudNumber;
    }
    if ([_comment.isLaund isEqualToString:@"true"]) {
        self.favorButton.enabled = NO;
        self.favorLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    }else {
        self.favorButton.enabled = YES;
        self.favorLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_comment.content?:@""];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7.0f;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_comment.content?:@"" length])];
    self.contentLabel.attributedText = attributedString;
}
- (void)setIsShowLine:(BOOL)isShowLine {
    _isShowLine = isShowLine;
    self.lineView.hidden = !_isShowLine;
}
- (void)setCourseCommentsFavorBlock:(CourseCommentsFavorBlock)block {
    self.favorBlock = block;
}
- (void)setCourseCommentsFullReplyBlock:(CourseCommentsFullReplyBlock)block {
    self.fullReplyBlock = block;
}
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
