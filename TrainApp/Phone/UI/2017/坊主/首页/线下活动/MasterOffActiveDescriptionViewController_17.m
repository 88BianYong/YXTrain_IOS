//
//  MasterOffActiveDescriptionViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOffActiveDescriptionViewController_17.h"

@interface MasterOffActiveDescriptionViewController_17 ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@end

@implementation MasterOffActiveDescriptionViewController_17
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.descriptionLabel.font = [UIFont systemFontOfSize:13.0f];
    self.descriptionLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.descriptionLabel];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(15.0f);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top);
        make.left.equalTo(self.view.mas_left).offset(15.0f);
        make.right.equalTo(self.view.mas_right).offset(-15.0f);
    }];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:self.descString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineHeightMultiple:1.2f];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _descString.length)];
    self.descriptionLabel.attributedText = attributedString;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth - 31.0f, ceilf([self.descriptionLabel sizeThatFits:CGSizeMake(kScreenWidth - 30.0f , MAXFLOAT)].height));
}
@end
