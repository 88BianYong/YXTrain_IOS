//
//  PreventHangingCourseView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "PreventHangingCourseView.h"
@interface PreventHangingCourseView ()
@property (nonatomic, copy) PreventHangingCourseBlock touchBlock;
@end
@implementation PreventHangingCourseView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    }
    return self;
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor redColor];
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_offset(CGSizeMake(150.0f, 150.0f));
    }];
}

- (void)setPreventHangingCourseBlock:(PreventHangingCourseBlock)block {
    self.touchBlock = block;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.hidden = YES;
   BLOCK_EXEC(self.touchBlock);
}
@end
