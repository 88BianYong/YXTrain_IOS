//
//  YXAboutCell.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXAboutCell.h"

@implementation YXAboutCell
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuHidden:) name:UIMenuControllerWillHideMenuNotification object:nil];
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    UIView *selectedBgView = [[UIView alloc]init];
    selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
    self.selectedBackgroundView = selectedBgView;
    _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(50.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-50.0f);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(0.5f);
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
#pragma mark -showMenu
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showMenu:)]) {
        [self.delegate performSelector:@selector(showMenu:) withObject:self];
    }
    [super setHighlighted:highlighted animated:animated];
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(cut:)){
        return NO;
    }
    else if(action == @selector(copy:)){
        return YES;
    }
    else if(action == @selector(paste:)){
        return NO;
    }
    else if(action == @selector(select:)){
        return NO;
    }
    else if(action == @selector(selectAll:)){
        return NO;
    }else{
        return [super canPerformAction:action withSender:sender];
    }
}
- (void)copy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:@"lstong910"];
}
#pragma mark -UIMenuControllerWillHideMenuNotification
- (void)menuHidden:(NSNotification *)notif
{
    self.selected = NO;
}
@end
