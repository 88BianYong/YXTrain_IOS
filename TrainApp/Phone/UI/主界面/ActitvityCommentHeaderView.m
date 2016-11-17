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

@property (nonatomic, copy) ActitvityCommentFavorBlock favorBlock;
@property (nonatomic, copy) ActitvityCommentReplyBlock replyBlock;

@end
@implementation ActitvityCommentHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
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
    [self.favorButton setImage:[UIImage imageNamed:@"点赞icon-点击状态"] forState:UIControlStateSelected];
    [self.favorButton addTarget:self action:@selector(favorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.favorButton];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyCommentAction:)];
    [self.contentView addGestureRecognizer:recognizer];
}
- (void)setupLayout {
   [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.contentView.mas_left).offset(15.0f);
       make.top.equalTo(self.contentView.mas_top).offset(30.0f);
       make.size.mas_offset(CGSizeMake(36.0f, 36.0f));
   }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(11.0f);
        make.top.equalTo(self.contentView.mas_top).offset(30.0f);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6.0f);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_left);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
    }];
    
    [self.favorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favorButton.mas_top);
        make.right.equalTo(self.favorButton.mas_left).offset(-6.0f);
    }];
    
    [self.favorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-25.0f);
        make.top.equalTo(self.contentView.mas_top).offset(33.0f);
        make.size.mas_offset(CGSizeMake(16.0f, 16.0f));
    }];
    
}

#pragma mark - button Action 
- (void)favorButtonAction:(UIButton *)sender{
    BLOCK_EXEC(self.favorBlock, self.replie);
}
- (void)replyCommentAction:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        BLOCK_EXEC(self.replyBlock,self.replie);
    }
}

#pragma mark - set
- (void)setReplie:(ActivityFirstCommentRequestItem_Body_Replies *)replie{
    _replie = replie;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:replie.headUrl] placeholderImage:nil];
    self.nameLabel.text = replie.userName;
    self.timeLabel.text = replie.time;
    self.favorLabel.text = replie.up;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:replie.content?:@""];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7.0f;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [replie.content?:@"" length])];
    self.contentLabel.attributedText = attributedString;
    
}

- (void)setActitvityCommentFavorBlock:(ActitvityCommentFavorBlock)block {
    self.favorBlock = block;
}
- (void)setActitvityCommentReplyBlock:(ActitvityCommentReplyBlock)block {
    self.replyBlock = block;
}
@end
