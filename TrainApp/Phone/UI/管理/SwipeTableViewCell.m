//
//  SwipeTableViewCell.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "SwipeTableViewCell.h"
@interface SwipeTableViewCell ()
@property (nonatomic, strong) UIImageView *statusImageView;
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
    self.statusImageView = [[UIImageView alloc] init];
    self.statusImageView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.statusImageView];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.containerView];
}

- (void)setupSwipeLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(self.contentView.mas_width);
    }];
    
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(20.0f);
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
        self.statusImageView.backgroundColor = [UIColor blueColor];
    }else{
        self.statusImageView.backgroundColor = [UIColor grayColor];
    }
}
- (void)setupModeEditable:(BOOL)edit
{
    if (edit) {
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(50.0f);
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
}
-(void)modifiDeleteBtn{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            subView.backgroundColor= [UIColor blueColor];
            for (UIButton *btn in subView.subviews) {
                if ([btn isKindOfClass:[UIButton class]]) {
                    btn.backgroundColor=[UIColor blueColor];
                }
            }
        }
    }
}

@end
