//
//  YXHomeworkInfoNoRecordCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkInfoNoRecordCell.h"
@interface YXHomeworkInfoNoRecordCell()
{
    UIButton *_recordButton;
    UIButton *_directionsButton;
}
@end
@implementation YXHomeworkInfoNoRecordCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [self setupUI];
        [self layoutInterface];
    }
    return self;
}

#pragma mark - setupUI

- (void)setupUI{
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordButton.tag = YXRecordVideoInterfaceStatus_Record;
    [_recordButton setImage:[UIImage imageNamed:@"录制视频图标"] forState:UIControlStateNormal];
    [_recordButton setImage:[UIImage imageNamed:@"录制视频图标-点击态"] forState:UIControlStateHighlighted];
    [_recordButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
    [_recordButton setTitle:@"录制视频" forState:UIControlStateNormal];
    [_recordButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    [_recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_recordButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10.0f, 0, 0)];
    [_recordButton addTarget:self action:@selector(noRecordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _recordButton.layer.cornerRadius = YXTrainCornerRadii;
    _recordButton.layer.borderColor = [UIColor colorWithHexString:@"0067be"].CGColor;
    _recordButton.layer.borderWidth = 1.0f;
    _recordButton.clipsToBounds = YES;
    _recordButton.layer.masksToBounds = YES;
    _recordButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:_recordButton];
    
    
    _directionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _directionsButton.tag = YXRecordVideoInterfaceStatus_Depiction;
    [_directionsButton setImage:[UIImage imageNamed:@"视频上传说明图标"] forState:UIControlStateNormal];
    [_directionsButton setImage:[UIImage imageNamed:@"视频上传说明图标"] forState:UIControlStateHighlighted];
    [_directionsButton setTitle:@"视频录制上传说明" forState:UIControlStateNormal];
    [_directionsButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateNormal];
    [_directionsButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8.0f, 0, 0)];
    _directionsButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [_directionsButton addTarget:self action:@selector(noRecordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_directionsButton];
}

- (void)layoutInterface{
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(50.0f);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.mas_offset(44.0f);
        make.width.mas_offset(225.0f);
    }];
    
    [_directionsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.0f);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_offset(200.0f);
    }];
}

- (void)noRecordButtonAction:(UIButton *)sender{
    BLOCK_EXEC(self.noRecordHandler,sender.tag);
}

@end
