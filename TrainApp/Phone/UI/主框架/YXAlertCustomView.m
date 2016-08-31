//
//  YXAlertCustomView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/10.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXAlertCustomView.h"
#import "AppDelegate.h"
@implementation YXAlertAction
@end


@interface YXAlertCustomView()
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UIView *_backgroundView;
    
    NSMutableArray *_actionMutableArray;
    
}
@end
@implementation YXAlertCustomView
+ (instancetype)alertViewWithTitle:(NSString *)title image:(NSString *)image actions:(NSArray *)actions{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) withTilte:title withImage:image withActions:actions];
}

- (instancetype)initWithFrame:(CGRect)frame withTilte:(NSString *)title withImage:(NSString *)image withActions:(NSArray *)actions{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        _actionMutableArray = [[NSMutableArray alloc] initWithArray:actions];
        [self setupWithTilte:title image:image withActions:actions];
        [self layoutInterface];
    }
    return self;
}


- (void)setupWithTilte:(NSString *)title image:(NSString *)image withActions:(NSArray *)actions{
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    _backgroundView.layer.cornerRadius = YXTrainCornerRadii;
    [self addSubview:_backgroundView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:image];
    [_backgroundView addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.attributedText = [self titleString:title];
    _titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [_backgroundView addSubview:_titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [_backgroundView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_backgroundView);
        make.bottom.equalTo(_backgroundView.mas_bottom).offset(-60.0f);
        make.height.mas_offset(1/[UIScreen mainScreen].scale);
    }];
    
    if (actions.count > 2.0f || actions.count == 0) {
       NSAssert(actions.count, @"按键数目不能超过2个,也不能为空");
    }else{
        if (actions.count == 1) {
            UIButton *button = [self customButtonAction:actions[0]];
            button.tag = 0;
            [_backgroundView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_backgroundView.mas_bottom);
                make.left.right.equalTo(_backgroundView);
                make.height.mas_offset(60.0f);
            }];
        }else{
            UIButton *buttonOne = [self customButtonAction:actions[0]];
            buttonOne.tag = 0;
            [_backgroundView addSubview:buttonOne];
            [buttonOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_backgroundView.mas_left).offset(30.0f);
                make.height.mas_offset(29.0f);
                make.width.mas_offset(75.0f);
                make.bottom.equalTo(_backgroundView.mas_bottom).offset(-15.5f);
            }];
            UIButton *buttonTwo = [self customButtonAction:actions[1]];
            buttonTwo.tag = 1;
            [_backgroundView addSubview:buttonTwo];
            [buttonTwo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_backgroundView.mas_right).offset(-30.0f);
                make.height.mas_offset(29.0f);
                make.width.mas_offset(75.0f);
                make.bottom.equalTo(_backgroundView.mas_bottom).offset(-15.5f);
            }];
        }
    }
}
- (NSMutableAttributedString *)titleString:(NSString *)title{
    NSRange range = NSMakeRange(0, title.length);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSParagraphStyleAttributeName:paragraphStyle} range:range];
    return attributedString;
}


- (void)layoutInterface{
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(270.f, 155.0f));
        make.center.equalTo(self);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90.0f, 90.0f));
        make.bottom.equalTo(_backgroundView.mas_top).offset(37.0f);
        make.centerX.equalTo(_backgroundView.mas_centerX);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom).offset(3.0f);
        make.centerX.equalTo(_imageView.mas_centerX);
        make.width.equalTo(_backgroundView.mas_width).offset(-30.0f);
    }];
}

- (UIButton *)customButtonAction:(YXAlertAction *)action{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:action.title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    if (action.style == YXAlertActionStyleCancel) {
        [button setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f3f7fa"]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"a9acae"]] forState:UIControlStateHighlighted];
        button.layer.cornerRadius = YXTrainCornerRadii;
        button.clipsToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    else if (action.style == YXAlertActionStyleDefault){
      [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [button setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"003686"]] forState:UIControlStateHighlighted];
      button.layer.cornerRadius = YXTrainCornerRadii;
        button.clipsToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }else if(action.style == YXAlertActionStyleAlone){
        [button setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"003686"]] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return button;

}

- (void)buttonAction:(UIButton *)sender{
    [self removeFromSuperview];
    YXAlertAction *action = _actionMutableArray[sender.tag];
    BLOCK_EXEC(action.block);
}

- (void)showAlertView:(UIView *)view{
    if (view == nil){
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [window addSubview:self];
    }
    else{
        self.frame = view.frame;
        [view addSubview:self];
    }

}
@end
