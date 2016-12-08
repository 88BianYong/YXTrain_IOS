//
//  BeijingCheckedMobileMessageCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingCheckedMobileMessageCell.h"
@interface BeijingCheckedMobileMessageCell ()
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) dispatch_source_t sourceTimer;
@property (nonatomic, copy) BeijingCheckedMobileMessageBlock messageBlock;
@end
@implementation BeijingCheckedMobileMessageCell
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.sourceTimer) {
        dispatch_source_cancel(self.sourceTimer);
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark - setupUI
- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = YXTrainCornerRadii;
    [self.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    self.textField = [[UITextField alloc] init];
    self.textField.font = [UIFont systemFontOfSize:14.0f];
    self.textField.textColor = [UIColor colorWithHexString:@"334466"];
    [self.textField setValue:[UIColor colorWithHexString:@"c6c9cc"] forKeyPath:@"_placeholderLabel.textColor"];
    self.textField.placeholder = @"输入短信验证码";
    self.textField.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:self.textField];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"dfe2e5"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-99.0f - 10.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_offset(18.0f);
        make.width.mas_offset(1.0f);
    }];
    
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleButton setImage:[UIImage imageNamed:@"删除当前内容-正常态"] forState:UIControlStateNormal];
    [self.cancleButton setImage:[UIImage imageNamed:@"删除当前内容-点击态"] forState:UIControlStateHighlighted];
    [self.cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cancleButton.hidden = YES;
    [self.contentView addSubview:self.cancleButton];

    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
        make.right.equalTo(lineView.mas_right).offset(-14.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(25.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.cancleButton.mas_left).offset(-10.0f);
    }];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    [self.sendButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
    [self.sendButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateDisabled];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.sendButton.enabled = NO;
    [self.sendButton addTarget:self action:@selector(sendMessageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)textDidChange:(NSNotification *)aNotification {
    if (self.textField.text.length == 0) {
        self.cancleButton.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainDeleteInfo object:@(YES)];
    }else {
        self.cancleButton.hidden = NO;
    }
}
- (void)setBeijingCheckedMobileMessageBlock:(BeijingCheckedMobileMessageBlock)block {
    self.messageBlock = block;
}
- (void)cancleButtonAction:(UIButton *)sender {
    self.textField.text = nil;
    self.cancleButton.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainDeleteInfo object:@(YES)];
}
- (void)sendMessageButtonAction:(UIButton *)sender {
    if (!self.isCountdown) {
        [self messageCountdown:sender time:kMessageCountdownTime];
        BLOCK_EXEC(self.messageBlock);
    }
}
- (void)messageCountdown:(UIButton *)sender time:(NSInteger)intTime {
    __block NSInteger timeout = intTime;
    WEAK_SELF
    timeout -- ;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.sourceTimer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(self.sourceTimer, ^{
        STRONG_SELF
        if (timeout <= 0) {
            dispatch_source_cancel(self.sourceTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
            self.isCountdown = NO;
        }
        else {
            self.isCountdown = YES;
            NSInteger secondes = timeout % kMessageCountdownTime;
            NSString *timeString = [ NSString stringWithFormat:@"%2lds",(long)secondes];
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:timeString forState:UIControlStateNormal];
            });
            timeout -- ;
        }
    });
    dispatch_resume(self.sourceTimer);
}
- (void)resetMobileMessage {
    dispatch_source_cancel(self.sourceTimer);
    self.sendButton.enabled = YES;
    self.isCountdown = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.sendButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
    });
}
@end
