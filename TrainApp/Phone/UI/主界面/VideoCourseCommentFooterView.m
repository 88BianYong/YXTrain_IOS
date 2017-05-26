//
//  VideoCourseCommentFooterView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseCommentFooterView.h"
@interface VideoCourseCommentFooterView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, copy) VideoCourseAllCommentReplyBlock replyBlock;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation VideoCourseCommentFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI {
    self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.replyButton setTitle:@"查看全部回复" forState:UIControlStateNormal];
    [self.replyButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    self.replyButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.replyButton.frame = CGRectMake(62.0f, 0.0f, 90.0f, 14.0f);
    self.replyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.replyButton addTarget:self action:@selector(replyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.replyButton];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(62.0f);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
}


#pragma mark - button Action
- (void)replyButtonAction:(UIButton *)sender {
    BLOCK_EXEC(self.replyBlock);
}

#pragma mark - set
- (void)setVideoCourseAllCommentReplyBlock:(VideoCourseAllCommentReplyBlock)block {
    self.replyBlock = block;
}
- (void)setChildNum:(NSString *)childNum {
    [self.replyButton setTitle:[NSString stringWithFormat:@"- %@条回复",childNum] forState:UIControlStateNormal];
}
@end
