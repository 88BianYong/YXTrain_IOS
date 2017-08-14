//
//  HomeworkListGroupCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/4.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "HomeworkListGroupDefaultCell_17.h"
@interface HomeworkListGroupDefaultCell_17 ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *groupImageView;
@end
@implementation HomeworkListGroupDefaultCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
}
#pragma mark - set
- (void)setHomework:(HomeworkListRequest_17Item_Homeworks *)homework {
    _homework = homework;
    self.titleLabel.text= _homework.title;
}
#pragma mark - setup UI
- (void)setupUI{
    self.groupImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"组"]];
    [self.contentView addSubview:self.groupImageView];
    [self.groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 1;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.groupImageView.mas_right).offset(10.0f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
    }];
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_offset(1.0f/[UIScreen mainScreen].scale);
    }];
}

@end
