//
//  CourseTestCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseTestCell_17.h"
@interface CourseTestCell_17 ()
@property (nonatomic, strong) UIImageView *chooseImageView;
@property (nonatomic, strong) UILabel *answerLabel;
@end
@implementation CourseTestCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
        make.left.equalTo(self.chooseImageView.mas_right).offset(30.0f);
        make.top.equalTo(self.contentView.mas_top).offset(11.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-20.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-11.0f);
    }];
}
#pragma mark - set
- (void)setAnswer:(CourseGetQuizesRequest_17Item_Result_Questions_AnswerJson *)answer {
    _answer = answer;
    self.answerLabel.text = _answer.content;
    self.chooseImageView.image = [UIImage imageNamed:_answer.isChoose.boolValue ? @"选择" : @"未选择"];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setIsFullscreen:(BOOL)isFullscreen {
    _isFullscreen = isFullscreen;
    if (_isFullscreen) {
        [self.chooseImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(38.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
        }];
    }else {
        [self.chooseImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(20.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
        }];
    }
}

@end
