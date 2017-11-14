//
//  YXHomeworkPlayVideoCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkPlayVideoCell.h"
#import "UIImage+YXImage.h"
@interface YXHomeworkPlayVideoCell()
{
    UIImageView *_imageView;
    UIButton *_playButton;
}
@end
@implementation YXHomeworkPlayVideoCell
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
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    _playButton = [[UIButton alloc] init];
    [_playButton setImage:[UIImage imageNamed:@"播放视频按钮-正常态A"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"播放视频按钮-点击态A"] forState:UIControlStateHighlighted];
    _playButton.tag = YXRecordVideoInterfaceStatus_Play;
    [_playButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_playButton];
}

- (void)layoutInterface{
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(5.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-5.0f);
    }];
    
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.height.mas_offset(50.0f);
    }];
}
- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    
    UIImage  *image = [UIImage yx_thumbnailImageForVideo:[NSURL fileURLWithPath:imageName] atTime:5.0f];
    if (image){
        _imageView.image = image;
    }else{
        _imageView.image = [UIImage imageNamed:@"默认的一上传视频5S图片"];
    }
}

#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)sender{
    BLOCK_EXEC(self.buttonActionHandler,sender.tag);
}
@end
