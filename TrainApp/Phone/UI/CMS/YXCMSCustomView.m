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
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _timerView = [[YXCMSTimerView alloc] init];
    WEAK_SELF
    _timerView.stopTimerBlock = ^ {
        STRONG_SELF
        [self removeCMSView];
    };
    [self addSubview:_timerView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [_timerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(30);
    }];

}
- (void)reloadWithModel:(YXRotateListRequestItem_Rotates *)model
{
    self.model = model;
    UIImage *image = [model localImage];
    NSURL *URL = [NSURL URLWithString:model.startpageurl];
    NSArray *array = [model.projectId componentsSeparatedByString:@","];
    __block BOOL isShow = NO;
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[YXTrainManager sharedInstance].currentProject.pid isEqualToString:obj]) {
            isShow = YES;
            *stop = YES;
        }
    }];    
    if (image && isShow) {
        self.imageView.image = image;
        [self.timerView startWithSeconds:self.model.seconds.integerValue];
    } else if (URL) {
        WEAK_SELF
        [self.imageView sd_setImageWithURL:URL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            STRONG_SELF
            if (image) {
                [model saveImageToDisk:image];
            }
            [self removeCMSView];
        }];
    } else {
        [self removeCMSView];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
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
    [self removeCMSView];
}

- (void)enterCMSViewAction
{
    if (self.clickedBlock) {
        self.clickedBlock(self.model);
    }
    [self removeCMSView];
}

- (void)removeCMSView
{
    [self removeFromSuperview];
}

@end
