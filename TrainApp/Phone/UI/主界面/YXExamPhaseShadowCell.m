//
//  YXExamPhaseShadowCell.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamPhaseShadowCell.h"
#import "YXGradientView.h"

@interface YXExamPhaseShadowCell()
@property (nonatomic, strong) YXGradientView *gradientView;
@end

@implementation YXExamPhaseShadowCell

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
    UIColor *color = [UIColor colorWithHexString:@"f1f1f1"];
    self.gradientView = [[YXGradientView alloc]initWithStartColor:color endColor:[color colorWithAlphaComponent:0] orientation:YXGradientTopToBottom];
    [self.contentView addSubview:self.gradientView];
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end
