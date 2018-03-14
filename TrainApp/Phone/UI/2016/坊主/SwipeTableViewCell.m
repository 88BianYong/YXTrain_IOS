//
//  SwipeTableViewCell.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SwipeTableViewCell.h"
@interface SwipeTableViewCell ()
@property (nonatomic, strong) UIView *choooseView;
@property (nonatomic, strong) UIImageView *statusImageView;

@property (nonatomic, strong) UILabel *remindLabel;
@end
@implementation SwipeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSwipeUI];
        [self setupSwipeLayout];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupSwipeUI {
    self.choooseView = [[UIView alloc] init];
    self.choooseView.layer.cornerRadius = 10.0f;
    self.choooseView.layer.borderWidth = 1.0f;
    self.choooseView.layer.borderColor = [UIColor colorWithHexString:@"dfe2e6"].CGColor;
    self.choooseView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.choooseView];
    
    self.remindLabel = [[UILabel alloc] init];
    self.remindLabel.textColor = [UIColor whiteColor];
    self.remindLabel.backgroundColor = [UIColor colorWithHexString:@"0070c9"];
    self.remindLabel.font = [UIFont systemFontOfSize:12.0f];
    self.remindLabel.text = @"提醒学习";
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.remindLabel];
    
    
    self.statusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"批量操作选择的对号"]];
    [self.choooseView addSubview:self.statusImageView];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.containerView];
}

- (void)setupSwipeLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(self.contentView.mas_width);
    }];
    
    [self.choooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10.0f);
    }];
    
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(15.0f, 15.0f));
        make.center.equalTo(self.choooseView);
    }];
    
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(86.0f,86.0f));
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setIsChooseBool:(BOOL)isChooseBool {
    _isChooseBool = isChooseBool;
    if (_isChooseBool) {
        self.choooseView.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;
        self.choooseView.backgroundColor = [UIColor colorWithHexString:@"0070c9"];
        self.statusImageView.hidden = NO;
    }else{
        self.statusImageView.hidden = YES;
        self.choooseView.layer.borderColor = [UIColor colorWithHexString:@"dfe2e6"].CGColor;
        self.choooseView.backgroundColor = [UIColor whiteColor];
    }
}
- (void)setupModeEditable:(BOOL)edit {
    if (edit) {
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(30.0f);
        }];
    }else{
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
        }];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self modifiDeleteBtn];
    DDLogDebug(@"调用");
}
-(void)modifiDeleteBtn{
    if (@available(iOS 11.0, *)) {
        for (UIView *subview in self.superview.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")])
            {
                subview.backgroundColor=[UIColor colorWithHexString:@"0070c9"];
                for (UIButton *btn in subview.subviews) {
                    if ([btn isKindOfClass:[UIButton class]]) {
                        btn.backgroundColor=[UIColor colorWithHexString:@"0070c9"];
                        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
                        [btn setTitle:@"提醒学习" forState:UIControlStateNormal];
                    }
                }
            }
        }
    }else {
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
                subView.backgroundColor= [UIColor colorWithHexString:@"0070c9"];
                for (UIButton *btn in subView.subviews) {
                    if ([btn isKindOfClass:[UIButton class]]) {
                        btn.backgroundColor=[UIColor colorWithHexString:@"0070c9"];
                        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
                        [btn setTitle:@"提醒学习" forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
}
- (void)setEditing:(BOOL)editing {
    [super setEditing:editing];
    if (editing) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).offset(-86.0f);
            }];
            [self layoutIfNeeded];
        }];
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left);
            }];
            [self layoutIfNeeded];
        }];
    }
}

@end
