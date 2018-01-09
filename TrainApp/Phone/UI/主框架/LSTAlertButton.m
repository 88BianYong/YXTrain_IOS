//
//  LSTAlertButton.m
//  TrainApp
//
//  Created by ZLL on 2016/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "LSTAlertButton.h"

@implementation LSTAlertButton

- (void)setStyle:(LSTAlertActionStyle)style {
    _style = style;
    if (style == LSTAlertActionStyle_Cancel) {
        [self setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f3f7fa"]] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
        self.layer.cornerRadius = YXTrainCornerRadii;
        self.clipsToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    else if (style == LSTAlertActionStyle_Default){
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
        self.layer.cornerRadius = YXTrainCornerRadii;
        self.clipsToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }else if(style == LSTAlertActionStyle_Alone){
        [self setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
}

@end
