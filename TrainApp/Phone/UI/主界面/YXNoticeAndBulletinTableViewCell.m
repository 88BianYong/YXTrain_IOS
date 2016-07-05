//
//  YXNoticeAndBulletinTableViewCell.m
//  TrainApp
//
//  Created by 李五民 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXNoticeAndBulletinTableViewCell.h"

@interface YXNoticeAndBulletinTableViewCell ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *middleSircleView;
@property (nonatomic, strong) UILabel *middleSircleLabel;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *contentLabe;


@end

@implementation YXNoticeAndBulletinTableViewCell

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

}

@end
