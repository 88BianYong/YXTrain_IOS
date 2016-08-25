//
//  YXUploadDepictionViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/10.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXUploadDepictionViewController.h"
@interface YXUploadDepictionViewController()
{
    UIScrollView *_scrollView;
    UILabel *_contentLabel;
}
@end
@implementation YXUploadDepictionViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"视频录制上传说明";
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self setupAndLayoutInterface];
}

#pragma mark - setupUI
- (void)setupAndLayoutInterface{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.0f);
        make.top.equalTo(self.view.mas_top).offset(5.0f);
    }];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.numberOfLines = 0;
    [_scrollView addSubview:_contentLabel];
    NSString *dLabelString = YXTrainUploadDepictionString;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:dLabelString];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7.0];
    [paragraphStyle setParagraphSpacing:18.5f];
    [paragraphStyle setFirstLineHeadIndent:0.0f];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [dLabelString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"334466"] range:NSMakeRange(0, [dLabelString length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, [dLabelString length])];
    _contentLabel.attributedText = attributedString;
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top).offset(25.0f);
        make.left.equalTo(self.view.mas_left).offset(25.0f);
        make.right.equalTo(self.view.mas_right).offset(-25.0f);
    }];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGSize size = _contentLabel.frame.size;
    size.height += 30.0f;
    _scrollView.contentSize = size;
}
@end
