//
//  YXFilterCustomButton.m
//  TrainApp
//
//  Created by 李五民 on 16/6/28.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFilterCustomButton.h"

@implementation YXFilterCustomButton

- (instancetype)init{
    if (self = [super init]) {
        //[self setupUI];
    }
    return self;
}

- (void)setButtonTitle:(NSString *)title withMaxWidth:(float)width{
    [self setTitleColor:[UIColor colorWithHexString:@"505f84"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateSelected];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    
    CGFloat spacing = 2.0;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(width - 20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:NULL];
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    UIImage *titleImage = [UIImage imageNamed:@"排序"];
    [self setImage:titleImage forState:UIControlStateNormal];
    CGSize imageSize = titleImage.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
    CGSize titleSize = rect.size;
    //self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - self.titleLabel.intrinsicContentSize.width * 2 - spacing);
}

@end
