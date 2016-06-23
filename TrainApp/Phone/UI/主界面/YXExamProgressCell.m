//
//  YXExamProgressCell.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamProgressCell.h"
#import "YXExamProgressView.h"

@interface YXExamProgressCell()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) YXExamProgressView *progressView;
@end

@implementation YXExamProgressCell

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
    self.typeImageView = [[UIImageView alloc]init];
    self.typeImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    
    self.progressView = [[YXExamProgressView alloc]init];
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(6);
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(8);
    }];
    self.progressLabel = [[UILabel alloc]init];
    self.progressLabel.font = [UIFont systemFontOfSize:11];
    self.progressLabel.textColor = [UIColor colorWithHexString:@"0067be"];
    [self.contentView addSubview:self.progressLabel];
    self.statusLabel = [[UILabel alloc]init];
    self.statusLabel.font = [UIFont systemFontOfSize:11];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.statusLabel.textAlignment = NSTextAlignmentRight;
    self.statusLabel.text = @"这是啥";
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.progressView.mas_right);
        make.bottom.mas_equalTo(self.progressView.mas_top).mas_offset(-11);
    }];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.progressView.mas_left);
        make.right.mas_equalTo(self.statusLabel.mas_left).mas_offset(-10);
        make.bottom.mas_equalTo(self.progressView.mas_top).mas_offset(-11);
    }];
    [self.progressLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.progressLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setItem:(YXExamineRequestItem_body_toolExamineVo *)item{
    _item = item;
    self.titleLabel.text = item.name;
    NSString *lStr = [NSString stringWithFormat:@"已完成%@个",item.finishnum];
    NSString *rStr = [NSString stringWithFormat:@"／%@个",item.totalnum];
    NSString *completeStr = [NSString stringWithFormat:@"%@%@",lStr,rStr];
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc]initWithString:completeStr];
    NSRange range = [completeStr rangeOfString:rStr];
    [mStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"505f84"] range:range];
    self.progressLabel.attributedText = mStr;
    CGFloat progress = item.finishnum.floatValue/item.totalnum.floatValue;
    self.progressView.progress = progress;
}


@end
