//
//  YXNotAutorotateView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXNotAutorotateView.h"
@interface YXNotAutorotateView()
{
    UIImageView *_imageView;
    UILabel *_toalsLabel;
}
@end
@implementation YXNotAutorotateView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self layoutInterface];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI{
    self.layer.cornerRadius = YXTrainCornerRadii;
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"视频上传说明图标"];
    [self addSubview:_imageView];
    
    _toalsLabel = [[UILabel alloc] init];
    _toalsLabel.textColor = [UIColor colorWithHexString:@"334466"];
    _toalsLabel.font = [UIFont systemFontOfSize:14.0f];
    _toalsLabel.text = @"录制过程中请不要旋转屏幕";
    [self addSubview:_toalsLabel];
}

- (void)layoutInterface{
    [_toalsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX).offset(12.0f);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self->_toalsLabel.mas_left).offset(-5.0f);
        make.width.height.mas_offset(20.0f);
    }];
}
@end
