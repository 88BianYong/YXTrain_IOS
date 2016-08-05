//
//  YXVideoRecordBottomView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXVideoRecordBottomView.h"
@interface YXVideoRecordBottomView()
{
    UIButton *_deleteButton;
    UIButton *_recordButton;
    UIButton *_saveButton;
    
    UIView *_recordView;
    UIView *_stopView;
}
@end
@implementation YXVideoRecordBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        [self setupUI];
        [self layoutInterface];
        self.videoRecordStatus = YXVideoRecordStatus_Ready;
    }
    return self;
}

- (void)setupUI{
    _deleteButton = [[UIButton alloc] init];
    [_deleteButton setImage:[UIImage imageNamed:@"垃圾箱"] forState:UIControlStateNormal];
    [_deleteButton setImage:[UIImage imageNamed:@"垃圾箱-点击态"] forState:UIControlStateHighlighted];
    [_deleteButton addTarget:self action:@selector(deleteVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.alpha = 0.0f;
    [self addSubview:_deleteButton];
    
    _recordButton = [[UIButton alloc] init];
    _recordButton.layer.cornerRadius = 35.0f;
    _recordButton.layer.borderWidth = 3.0f;
    _recordButton.layer.borderColor = [UIColor colorWithHexString:@"b2d3ee"].CGColor;
    [_recordButton addTarget:self action:@selector(recordVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_recordButton];
    _recordView = [[UIView alloc] init];
    _recordView.backgroundColor = [UIColor colorWithHexString:@"0f95ff"];
    _recordView.layer.cornerRadius = 29.0f;
    _recordView.userInteractionEnabled = NO;
    [_recordButton addSubview:_recordView];
    
    _stopView = [[UIView alloc] init];
    _stopView.userInteractionEnabled = NO;
    _stopView.layer.cornerRadius = YXTrainCornerRadii;
    _stopView.backgroundColor = [UIColor colorWithHexString:@"0f95ff"];
    [_recordButton addSubview:_stopView];

    _saveButton = [[UIButton alloc] init];
    [_saveButton setImage:[UIImage imageNamed:@"保存按钮"] forState:UIControlStateNormal];
    [_saveButton setImage:[UIImage imageNamed:@"保存按钮-点击态"] forState:UIControlStateHighlighted];
    [_saveButton addTarget:self action:@selector(saveVideoButtonAcion:) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.alpha = 0.0f;
    [self addSubview:_saveButton];
}

- (void)layoutInterface{
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50.0f, 50.0f));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70.0f, 70.0f));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50.0f, 50.0f));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(58.0f, 58.0f));
        make.center.equalTo(_recordButton);
    }];
    
    [_stopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26.0f, 26.0f));
        make.center.equalTo(_recordButton);
    }];
    
    [self distributeSpacingHorizontallyWith:@[_deleteButton,_recordButton,_saveButton]];
}

- (void)setVideoRecordStatus:(YXVideoRecordStatus)videoRecordStatus
{
    _videoRecordStatus = videoRecordStatus;
    _recordView.hidden = NO;
    _stopView.hidden = YES;
    switch (videoRecordStatus) {
        case YXVideoRecordStatus_Ready:
        {
            [self showDeleteSaveButton:NO];
        }
            break;
        case YXVideoRecordStatus_Recording:
        {
            _recordView.hidden = YES;
            _stopView.hidden = NO;
            [self showDeleteSaveButton:NO];
        }
            break;
        case YXVideoRecordStatus_Pause:
        {
            [self showDeleteSaveButton:YES];
        }
            break;
        case YXVideoRecordStatus_Delete:
        {
            
        }
            break;
        case YXVideoRecordStatus_StopMax:
        {
            
        }
            break;
        case YXVideoRecordStatus_Save:
        {

        }
            break;
        default:
            break;
    }
    BLOCK_EXEC(self.recordHandler,self.videoRecordStatus);
}
- (void)showDeleteSaveButton:(BOOL)isShow{
    [UIView animateWithDuration:1.5 animations:^{
        _saveButton.alpha = isShow ? 1.0f : 0.0f;
        _deleteButton.alpha = isShow ? 1.0f : 0.0f;
    }];
}


/**
 *  删除录制视频
 *
 *  @param sender 按键
 */
- (void)deleteVideoButtonAction:(UIButton *)sender{
    self.videoRecordStatus = YXVideoRecordStatus_Delete;
}
/**
 *  录制暂停视频触发按键
 *
 *  @param sender 按键状态
 */
- (void)recordVideoButtonAction:(UIButton *)sender{
    if (self.videoRecordStatus == YXVideoRecordStatus_Recording) {
        self.videoRecordStatus = YXVideoRecordStatus_Pause;
    }else{
       self.videoRecordStatus = YXVideoRecordStatus_Recording;
    }
}
/**
 *  保存视频
 *
 *  @param sener 按键状态
 */
- (void)saveVideoButtonAcion:(UIButton *)sener{
    self.videoRecordStatus = YXVideoRecordStatus_Save;
}

@end
