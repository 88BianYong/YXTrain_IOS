//
//  MasterThemeHeaderView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/3/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MasterThemeHeaderView_17.h"
@interface MasterThemeHeaderView_17 ()
@property (nonatomic, strong) UILabel *contentLabel;
@end
@implementation MasterThemeHeaderView_17
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        NSString *contentString = @"温馨提示：\n1、每次只能选择一个主题，每个主题的适用对象不同，请仔细阅读主题说明\n2、在项目开始前可再次更改主题，项目开始后不可再更改，如有疑问请联系项目经理/编辑";
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.font = [UIFont systemFontOfSize:12.0f];
        self.contentLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple = 1.2f;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentString];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentString.length)];
        self.contentLabel.attributedText = attributedString;
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.top.equalTo(self.contentView.mas_top).offset(25.0f);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-25.0f);
        }];
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self.contentView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top);
            make.height.mas_offset(10.0f);
        }];
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self.contentView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_offset(10.0f);
        }];        
    }
    return self;
}
@end
