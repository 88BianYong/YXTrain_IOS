//
//  YXCourseFilterCell.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/21.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseFilterCell.h"

@interface YXCourseFilterCell()
@property (nonatomic, strong) UILabel *filterLabel;
@end

@implementation YXCourseFilterCell

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

- (void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.filterLabel = [[UILabel alloc]init];
    self.filterLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.filterLabel];
    [self.filterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
}

- (void)setFilterName:(NSString *)filterName{
    _filterName = filterName;
    self.filterLabel.text = filterName;
}

@end
