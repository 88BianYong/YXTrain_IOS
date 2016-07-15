//
//  YXExamMarkView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/28.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamMarkView.h"

@interface YXExamMarkView()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation YXExamMarkView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 111, 44)];
    self.imageView.image = [UIImage imageNamed:@"等待坊主点评"];
//    self.imageView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction{
    [self removeFromSuperview];
}

- (void)setOriginRect:(CGRect)originRect{
    _originRect = originRect;
    CGRect rect = self.imageView.bounds;
    rect.origin.x = originRect.origin.x - (rect.size.width-originRect.size.width);
    rect.origin.y = originRect.origin.y - rect.size.height;
    self.imageView.frame = rect;
}

- (void)showInView:(UIView *)view{
    self.frame = view.bounds;
    [view addSubview:self];
}

@end
