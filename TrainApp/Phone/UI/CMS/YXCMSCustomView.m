//
//  YXCMSCustomView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCMSCustomView.h"
#import "YXCMSTimerView.h"
@interface YXCMSCustomView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) YXCMSTimerView *timerView;
@property (nonatomic, strong) YXRotateListRequestItem_Rotates *model;
@end

@implementation YXCMSCustomView
- (void)dealloc{
    DDLogWarn(@"release=====>%@",NSStringFromClass([self class]));
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupUI{
    _imageView = [[UIImageView alloc] init];
    if (IS_IPHONE_4) {
        _imageView.image = [UIImage imageNamed:@"640-960"];
    }
    else if (IS_IPHONE_5){
        _imageView.image = [UIImage imageNamed:@"640-1136"];
    }else if (IS_IPHONE_6) {
        _imageView.image = [UIImage imageNamed:@"750-1334"];
    }
    else if(IS_IPHONE_6P){
        _imageView.image = [UIImage imageNamed:@"1242-2208"];
    }
    else if(IS_IPHONE_X){
        _imageView.image = [UIImage imageNamed:@"iphonex"];
    }
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _timerView = [[YXCMSTimerView alloc] init];
    _timerView.layer.cornerRadius = 14.5f;
    _timerView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    _timerView.hidden = YES;
    WEAK_SELF
    _timerView.stopTimerBlock = ^ {
        STRONG_SELF
        if (self.superview != nil) {
          [self removeCMSView:NO];
        }
    };
    [self addSubview:_timerView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [_timerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kVerticalStatusBarHeight);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(70.0f);
        make.height.mas_offset(29.0f);
    }];

}
- (void)reloadWithModel:(YXRotateListRequestItem_Rotates *)model
{
    self.model = model;
    UIImage *image = [model localImage];
    NSURL *URL = [NSURL URLWithString:model.startpageurl];
    if (image) {
        _timerView.hidden = NO;
        self.imageView.image = image;
        [self.timerView startWithSeconds:self.model.seconds.integerValue];
    } else if (URL) {
        [self removeCMSView:NO];
        [self.imageView sd_setImageWithURL:URL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [model saveImageToDisk:image];
            }
        }];

    } else {
        [self removeCMSView:NO];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.timerView.frame, point)) {
        [self clickTimerViewAction];
    } else {
        [self enterCMSViewAction];
    }
}


- (void)clickTimerViewAction
{
    [self removeCMSView:NO];
}

- (void)enterCMSViewAction
{
    if (self.clickedBlock) {
        self.clickedBlock(self.model);
    }
    [self removeCMSView:YES];
}

- (void)removeCMSView:(BOOL)isJump
{
    if (!isJump) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainShowUpdate object:nil];
    }
    [self removeFromSuperview];
}

@end
