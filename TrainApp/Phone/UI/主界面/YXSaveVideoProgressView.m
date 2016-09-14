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
    MDRadialProgressView *_radialView;//外进度条
    UIView *_innerCircleView;//内圆
    UILabel *_titleLabel;//提示
    UIButton *_closeButton;
    
    UIView *_backgroundView;//
    UIView *_obscuredView;
    
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
    
    _obscuredView = [[UIView alloc] init];
    _obscuredView.backgroundColor = [UIColor clearColor];
    [self addSubview:_obscuredView];
    
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    _backgroundView.layer.cornerRadius = YXTrainCornerRadii;
    [self addSubview:_backgroundView];
    
    _innerCircleView = [[UIView alloc] init];
    _innerCircleView.backgroundColor = [UIColor whiteColor];
    _innerCircleView.layer.cornerRadius = 25.0f;
    [self addSubview:_innerCircleView];

    
    _radialView = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(0, 0, 59, 59)];
    [self addSubview:_radialView];
    _radialView.progressTotal = 100;
    _radialView.progressCounter = 0.0f;
    _radialView.startingSlice = 1;
    _radialView.theme.sliceDividerHidden = YES;
    _radialView.theme.sliceDividerThickness = 1;
    _radialView.theme.incompletedColor = [UIColor clearColor];
    _radialView.theme.labelShadowOffset = CGSizeMake(0, 0);
    _radialView.theme.completedColor = [UIColor colorWithHexString:@"2c97dd"];
    _radialView.theme.centerColor = [UIColor clearColor];
    _radialView.theme.thickness = 17.0f;
    _radialView.theme.sliceDividerColor = [UIColor blueColor];
    _radialView.label.textColor = [UIColor colorWithHexString:@"0070c9"];
    _radialView.label.font = [UIFont systemFontOfSize:14];
    _radialView.label.text  =@"0%";
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"视频保存中...";
    [self addSubview:_titleLabel];
    
    _closeButton = [[UIButton alloc] init];
    [_closeButton setImage:[UIImage imageNamed:@"关闭按钮"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
}

- (void)layoutInterface{
    [_obscuredView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(150.0f, 150.0f));
        make.centerX.equalTo(self.mas_centerX).offset(-10.0f);
        make.centerY.equalTo(self.mas_centerY).offset(10.0f);
    }];
    
    [_radialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(59.0f, 59.0f));
        make.top.equalTo(_backgroundView.mas_top).offset(23.0f);
        make.centerX.equalTo(_backgroundView.mas_centerX);
    }];
    
    [_innerCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50.0f, 50.0f));
        make.center.equalTo(_radialView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_radialView.mas_bottom).offset(14.0f);
        make.centerX.equalTo(_backgroundView.mas_centerX);
        make.bottom.equalTo(_backgroundView.mas_bottom).offset(-23.0f);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView.mas_top).offset(-20.0f);
        make.left.equalTo(_backgroundView.mas_right);
        make.size.mas_equalTo(CGSizeMake(20.0f, 20.0f));
    }];
}

- (void)setProgress:(CGFloat)progress {
    
    _progress = MIN(MAX(0, progress), 1);    
    _radialView.progressCounter = (int)100 * _progress;
    _radialView.label.text = [NSString stringWithFormat:@"%d%%", (int)(100 * _progress)];
}
- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    _titleLabel.text = _titleString;
}

- (void)closeButtonAction:(UIButton *)sender{
    BLOCK_EXEC(self.closeHandler);
}
- (void)isShowView:(UIView *)view{
    if (view == nil){
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [window addSubview:self];
    }
    else{
        [view addSubview:self];
    }
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
@end
