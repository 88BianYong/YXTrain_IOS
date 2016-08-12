//
//  YXHomeworkAlreadyRecordCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkAlreadyRecordCell.h"
#import "UIImage+YXImage.h"
@interface YXHomeworkAlreadyRecordCell()
{
    UIImageView *_posterImageView;//视频图
    UILabel *_titleLabel;//视频状态
    UILabel *_recordTimeLabel;//录制时间
    UILabel *_durationLabel;//视频时长
    UILabel *_recordSizeLabel;//视频大小
    UIView *_lineView;
    
    UIButton *_playButton;
    UIButton *_uploadButton;
    UILabel *_againLabel;
    UIButton *_againButton;
    
}
@end

@implementation YXHomeworkAlreadyRecordCell
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
    UIView *backgrounView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, [UIScreen mainScreen].bounds.size.width - 10.0f, 250.0f)];
    backgrounView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backgrounView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backgrounView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(YXTrainCornerRadii, YXTrainCornerRadii)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = backgrounView.bounds;
    maskLayer.path = maskPath.CGPath;
    backgrounView.layer.mask = maskLayer;
    
    _posterImageView = [[UIImageView alloc] init];
    _posterImageView.layer.cornerRadius = YXTrainCornerRadii;
    _posterImageView.layer.masksToBounds = YES;
    _posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_posterImageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _titleLabel.text = @"已录制未上传视频";
    [self.contentView addSubview:_titleLabel];
    
    _recordTimeLabel = [[UILabel alloc] init];
    _recordTimeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    _recordTimeLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:_recordTimeLabel];
    
    _durationLabel = [[UILabel alloc] init];
    _durationLabel.textColor = [UIColor colorWithHexString:@"334466"];
    _durationLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:_durationLabel];
    
    _recordSizeLabel = [[UILabel alloc] init];
    _recordSizeLabel.textColor = [UIColor colorWithHexString:@"334466"];
    _recordSizeLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.contentView addSubview:_recordSizeLabel];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:_lineView];
    
    _uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _uploadButton.tag = YXRecordVideoInterfaceStatus_Write;
    [_uploadButton setImage:[UIImage imageNamed:@"上传视频图标正常态"] forState:UIControlStateNormal];
    [_uploadButton setImage:[UIImage imageNamed:@"上传视频图标点击态"] forState:UIControlStateHighlighted];
    [_uploadButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
    [_uploadButton setTitle:@"上传视频" forState:UIControlStateNormal];
    [_uploadButton setTitleColor:[UIColor colorWithHexString:@"0070c9"] forState:UIControlStateNormal];
    [_uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_uploadButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10.0f, 0, 0)];
    [_uploadButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _uploadButton.layer.cornerRadius = YXTrainCornerRadii;
    _uploadButton.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;
    _uploadButton.layer.borderWidth = 1.0f;
    _uploadButton.clipsToBounds = YES;
    _uploadButton.layer.masksToBounds = YES;
    [_uploadButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_uploadButton];
    
    _againLabel = [[UILabel alloc] init];
    _againLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    _againLabel.font = [UIFont systemFontOfSize:12.0f];
    _againLabel.text = @"录制不满意?";
    [self.contentView addSubview:_againLabel];
    
    _againButton = [[UIButton alloc] init];
    _againButton.tag = YXRecordVideoInterfaceStatus_Record;
    [_againButton setTitle:@"重新录制" forState:UIControlStateNormal];
    [_againButton setTitleColor:[UIColor colorWithHexString:@"0070c9"] forState:UIControlStateNormal];
    [_againButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_againButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_againButton];
    
    _playButton = [[UIButton alloc] init];
    _playButton.tag = YXRecordVideoInterfaceStatus_Play;
    [_playButton setImage:[UIImage imageNamed:@"播放视频按钮-正常态"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"播放视频按钮-点击态"] forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_playButton];
}

#pragma mark - layoutInterface
- (void)layoutInterface{
   [_posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.contentView.mas_left).offset(15.0f);
       make.top.equalTo(self.contentView.mas_top).offset(20.0f);
       make.width.mas_offset(125.0f);
       make.height.mas_offset(94.0f);
   }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_posterImageView.mas_right).offset(14.0f);
        make.top.equalTo(self.contentView.mas_top).offset(27.0f);
    }];
    
    [_recordTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(5.5f);
        make.left.equalTo(_titleLabel.mas_left);
    }];
    
    [_durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_recordSizeLabel.mas_top).offset(-4.5f);
        make.left.equalTo(_titleLabel.mas_left);
    }];
    
    [_recordSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_posterImageView.mas_bottom).offset(-2.5f);
        make.left.equalTo(_titleLabel.mas_left);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(_posterImageView.mas_bottom).offset(10.0f);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [_uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).offset(35.0f);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.mas_offset(44.0f);
        make.width.mas_offset(225.0f);
    }];
    
    [_againLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_uploadButton.mas_bottom).offset(20.0f);
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    
    [_againButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(9.0f);
        make.centerY.equalTo(_againLabel.mas_centerY);
        make.height.mas_offset(30.0f);
        make.width.mas_offset(50.0f);
    }];
    
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(kScreenWidthScale(-26.0f));
        make.centerY.equalTo(_posterImageView.mas_centerY);
        make.width.height.mas_offset(30.0f);
    }];
}

- (void)setFilePath:(NSString *)filePath{
    _filePath = filePath;
    if (_filePath) {
        unsigned long long fileSize = 0;
        NSDate *fileCreateDate = nil;
        NSError *error = nil;
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:_filePath error:&error];
        NSString * fileSizeString = [fileAttributes objectForKey:@"NSFileSize"];
        fileSize = [fileSizeString longLongValue];
        fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
        AVURLAsset *mp4Asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
        CMTime itmeTime = mp4Asset.duration;
        CGFloat durationTime = CMTimeGetSeconds(itmeTime);
        _recordTimeLabel.text = [NSString stringWithFormat:@"录制时间  %@",[NSString timeStringWithDate:fileCreateDate]];
        _recordSizeLabel.text = [NSString stringWithFormat:@"大小  %@",[NSString sizeStringWithFileSize:fileSize]];
        _durationLabel.text = [NSString stringWithFormat:@"时长  %@",[NSString stringWithFormatFloat:durationTime]];
        _posterImageView.image = [UIImage yx_thumbnailImageForVideo:[NSURL fileURLWithPath:_filePath] atTime:5.0f];
    }
}

#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)sender{
    BLOCK_EXEC(self.buttonActionHandler,sender.tag);
}



@end
