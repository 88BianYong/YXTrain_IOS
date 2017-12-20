//
//  MasterOffActiveRecordHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOffActiveRecordHeaderView_17.h"
@interface MasterOffActiveRecordHeaderView_17 ()
@property (nonatomic, strong) UILabel *contentLabel;
@end
@implementation MasterOffActiveRecordHeaderView_17
- (void)setContentString:(NSString *)contentString {
    _contentString = contentString;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:_contentString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineHeightMultiple:1.2f];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _contentString.length)];
    self.contentLabel.attributedText = attributedString;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
//        self.frame = [UIScreen mainScreen].bounds;
//        [self layoutIfNeeded];
//        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.textColor = [UIColor colorWithHexString:@"334466"];
        self.contentLabel.font = [UIFont systemFontOfSize:14.0f];
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0);
            make.top.equalTo(self.contentView.mas_top).offset(15.0f);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
        }];
    }
    return self;
}
@end
