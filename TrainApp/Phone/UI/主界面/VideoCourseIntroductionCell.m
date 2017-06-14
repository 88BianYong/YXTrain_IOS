//
//  VideoCourseIntroductionCell.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseIntroductionCell.h"
@interface VideoCourseIntroductionCell ()
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation VideoCourseIntroductionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI {
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.contentLabel.font = [UIFont systemFontOfSize:13.0f];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
}
- (void)setupLayout {
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5.0f, 25.0f, 10.0f, 25.0f));
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)setIntroduction:(NSString *)introduction {
    _introduction = introduction;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_introduction?:@""];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7.0f;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _introduction.length)];
    self.contentLabel.attributedText = attributedString;
}
@end
