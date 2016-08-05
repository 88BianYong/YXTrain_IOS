//
//  YXSaveVideoProgressView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXSaveVideoProgressView.h"
#import <MDRadialProgressView.h>
#import <MDRadialProgressTheme.h>
#import <MDRadialProgressLabel.h>
@interface YXSaveVideoProgressView()
{
    MDRadialProgressView *_radialView;
    UIView *_backgroundView;
    UILabel *_titleLabel;
}
@end

@implementation YXSaveVideoProgressView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self layoutInterface];
    }
    return self;
}

- (void)setupUI{
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    _backgroundView.layer.cornerRadius = 25.0f;
    [self addSubview:_backgroundView];
    
    
    
    _radialView = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [self addSubview:_radialView];
    _radialView.progressTotal = 100;
    _radialView.progressCounter = 30.0f;
    _radialView.startingSlice = 1;
    _radialView.theme.sliceDividerHidden = YES;
    _radialView.theme.sliceDividerThickness = 1;
    _radialView.theme.incompletedColor = [UIColor clearColor];
    _radialView.theme.labelShadowOffset = CGSizeMake(0, 0);
    _radialView.theme.completedColor = [UIColor colorWithHexString:@"2c97dd"];
    _radialView.theme.centerColor = [UIColor clearColor];
    _radialView.theme.thickness = 13.0f;
    _radialView.theme.sliceDividerColor = [UIColor blueColor];
    _radialView.label.textColor = [UIColor colorWithHexString:@"0070c9"];
    _radialView.label.font = [UIFont systemFontOfSize:14];
    _radialView.label.text  =@"0%";
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"视频保存中...";
    [self addSubview:_titleLabel];

}

- (void)layoutInterface{
    [_radialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(56.0f, 56.0f));
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50.0f, 50.0f));
        make.center.equalTo(_radialView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_radialView.mas_bottom).offset(14.0f);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

- (void)setProgress:(CGFloat)progress {
    _progress = MIN(MAX(0, progress), 1);
    _radialView.progressCounter = (int)100 * _progress;
    _radialView.label.text = [NSString stringWithFormat:@"%d%%", (int)(100 * _progress)];
}

//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeButton setImage:[UIImage imageNamed:@"进度条-关闭"] forState:UIControlStateNormal];
//    //[closeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
//    [self addSubview:closeButton];
//    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(@20);
//        make.right.mas_equalTo(@0);
//        make.size.mas_equalTo(CGSizeMake(44, 44));
//    }];
//    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
//
//    self.titleLabel = [[UILabel alloc] init];
//    self.titleLabel.font = [UIFont systemFontOfSize:15];
//    self.titleLabel.textColor = [UIColor whiteColor];
//    [self addSubview:self.titleLabel];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(@0);
//        make.top.mas_equalTo(radialView.mas_bottom).mas_offset(@10);
//    }];



@end
