//
//  YXVideoRecordTopView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXVideoRecordTopView.h"
@interface YXVideoRecordTopView()
{
    UILabel *_recordTimeLabel;
    UIView *_pointView;
    BOOL _isAnimate;
}
@end
@implementation YXVideoRecordTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        [self setupUI];
        [self layoutInterface];
    }
    return self;
}

- (void)setupUI{
    _canleButton = [[UIButton alloc] init];
    [_canleButton setImage:[UIImage imageNamed:@"关闭取消按钮"] forState:UIControlStateNormal];
    [_canleButton setImage:[UIImage imageNamed:@"关闭取消按钮点击态"] forState:UIControlStateHighlighted];
    [_canleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_canleButton];
    
    _pointView = [[UIView alloc] init];
    _pointView.backgroundColor = [UIColor colorWithHexString:@"0f95ff"];
    _pointView.layer.cornerRadius = 3.0f;
    _pointView.alpha = 0.0f;
    [self addSubview:_pointView];
    
    _recordTimeLabel = [[UILabel alloc] init];
    _recordTimeLabel.textColor = [UIColor whiteColor];
    _recordTimeLabel.font = [UIFont systemFontOfSize:17.0f];
    _recordTimeLabel.textAlignment = NSTextAlignmentCenter;
    _recordTimeLabel.text = @"00:00";
    [self addSubview:_recordTimeLabel];
}

- (void)layoutInterface{
    [_canleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5.0f);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_offset(30.0f);
    }];
    
    [_recordTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_recordTimeLabel.mas_left).offset(-8.0f);
        make.width.height.mas_offset(6.0f);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

- (void)setRecordTime:(NSInteger)recordTime
{
    _recordTime = recordTime;
    _recordTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)_recordTime/60, (long)_recordTime%60];
    
}

- (void)cancleButtonAction:(UIButton *)sender{
    BLOCK_EXEC(self.cancleHandler);
}
- (void)startAnimatetion{
    _pointView.hidden = NO;
    _canleButton.hidden = YES;
    if (!_isAnimate) {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            _pointView.alpha = 1.0f;
        }completion:^(BOOL finished) {
            
        }];
        _isAnimate = YES;
    }
}

- (void)stopAnimatetion{
    _pointView.hidden = YES;
}
@end
