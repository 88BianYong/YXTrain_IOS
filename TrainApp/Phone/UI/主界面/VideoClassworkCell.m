//
//  VideoClassworkCell.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoClassworkCell.h"
static NSString *kClassworkAnswerRight = @"   [ 正确 ]";
static NSString *kClassworkAnswerError = @"   [ 错误 ]";
@interface VideoClassworkCell ()
@property (nonatomic, strong) UIImageView *chooseImageView;
@property (nonatomic, strong) UILabel *answerLabel;
@end

@implementation VideoClassworkCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.chooseImageView = [[UIImageView alloc] init];
    self.chooseImageView.image = [UIImage imageNamed:@"未选择"];
    [self.contentView addSubview:self.chooseImageView];
    self.answerLabel = [[UILabel alloc] init];
    self.answerLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.answerLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    self.answerLabel.numberOfLines = 0;
    [self.contentView addSubview:self.answerLabel];
}
- (void)setupLayout {
    [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(38.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
    }];
    
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(87.0f);
        make.top.equalTo(self.contentView.mas_top).offset(11.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-20.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-11.0f);
    }];
}
#pragma mark - set
- (void)setAnswer:(YXVideoQuestionsRequestItem_Result_Questions_Question_AnswerJson *)answer {
    _answer = answer;
    self.answerLabel.text = _answer.content;
    self.chooseImageView.image = [UIImage imageNamed:_answer.isChoose.boolValue ? @"选择" : @"未选择"];
}
- (void)setClassworkStatus:(VideoClassworkCellStatus)classworkStatus {
    _classworkStatus = classworkStatus;
    NSString *contentString = @" ";
    UIColor *color;
    if (_classworkStatus == VideoClassworkCellStatus_Right) {
        contentString = [NSString stringWithFormat:@"%@%@",self.answer.content,kClassworkAnswerRight];
        color = [UIColor colorWithHexString:@"2bad28"];
    }else if (_classworkStatus == VideoClassworkCellStatus_Error){
        contentString = [NSString stringWithFormat:@"%@%@",self.answer.content,kClassworkAnswerError];
        color = [UIColor colorWithHexString:@"eb502c"];
    }else {
        contentString = self.answer.content;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(self.answer.content.length, contentString.length - self.answer.content.length)];
    self.answerLabel.attributedText = attributedString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
