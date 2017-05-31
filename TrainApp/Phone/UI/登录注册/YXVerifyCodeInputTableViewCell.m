//
//  YXVerifyCodeInputTableViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXVerifyCodeInputTableViewCell.h"
#import "YXLoginTextFiledView.h"


@interface YXVerifyCodeInputTableViewCell ()

@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UIButton *verifyCodeButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger secondsLeft;
@property (nonatomic,strong) YXLoginTextFiledView *loginTextField;

@end

@implementation YXVerifyCodeInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.containView = [[UIView alloc] init];
    self.containView.layer.cornerRadius = 2;
    self.containView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.containView];
    self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.loginTextField = [[YXLoginTextFiledView alloc] init];
    [self.loginTextField setTextColor:[UIColor colorWithHexString:@"334466"] placeHolderColor:[UIColor colorWithHexString:@"c6c9cc"]];
    @weakify(self);
    [self.loginTextField setPlaceHolderWithString:@"输入短信验证码" keyType:UIKeyboardTypeNumberPad isSecure:NO];
    self.loginTextField.textChangedBlock = ^(NSString *text) {
        @strongify(self);
        if (self.verifyCodeChangedBlock) {
            self.verifyCodeChangedBlock(text);
        }
    };
    [self.loginTextField setTextFiledViewBackgroundColor:[UIColor whiteColor]];
    [self.loginTextField setTextFiledEditedBackgroundColor:[UIColor whiteColor]];
    [self.containView addSubview:self.loginTextField];
    
    self.verifyCodeButton = [[UIButton alloc]init];
    [self.verifyCodeButton setBackgroundColor:[UIColor whiteColor]];
    [self.verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.verifyCodeButton setTitleColor:[UIColor colorWithHexString:@"cf2627"] forState:UIControlStateNormal];
    self.verifyCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.verifyCodeButton addTarget:self action:@selector(getVerifyCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.containView addSubview:self.verifyCodeButton];
    
    UIView *middleView = [[UIView alloc] init];
    middleView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.containView addSubview:middleView];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
    }];
    
    [self.verifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.right.mas_equalTo(0);
    }];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(self.verifyCodeButton.mas_left);
        make.size.mas_equalTo(CGSizeMake(1, 20));
    }];
    
    [self.loginTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.verifyCodeButton.mas_left);
    }];
}

- (void)getVerifyCodeAction{
    if (self.verifyCodeAction) {
        self.verifyCodeAction();
    }
}

- (void)startTimer{
    self.secondsLeft = 60;
    self.verifyCodeButton.userInteractionEnabled = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
    self.verifyCodeButton.userInteractionEnabled = YES;
    [self.verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)timerAction{
    if (self.secondsLeft == 0) {
        [self stopTimer];
        [self.verifyCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
        return;
    }
    NSString *secString = [NSString stringWithFormat:@"%@",@(self.secondsLeft)];
    [self.verifyCodeButton setTitle:secString forState:UIControlStateNormal];
    self.secondsLeft--;
}

- (void)resetTextField {
    [self.loginTextField resetTextFieldText];
}

- (void)setRightButtonImage {
    [self.loginTextField setRightButtonWhiteColor];
}


@end
