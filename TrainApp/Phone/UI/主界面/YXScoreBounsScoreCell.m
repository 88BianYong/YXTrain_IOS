//
//  YXScoreTaskScoreHeaderView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXScoreBounsScoreCell.h"
#import "YXScoreNoScoreView.h"

@interface YXScoreBounsScoreCell()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *totalScoreLabel;
@property (nonatomic, strong) YXScoreNoScoreView *noScoreView;
@end

@implementation YXScoreBounsScoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.0f);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.font = [UIFont fontWithName:YXFontMetro_DemiBold size:13];
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    
    self.totalScoreLabel = [[UILabel alloc]init];
    self.totalScoreLabel.font = [UIFont systemFontOfSize:12];
    self.totalScoreLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.totalScoreLabel.textAlignment = NSTextAlignmentRight;
    
    self.noScoreView = [[YXScoreNoScoreView alloc]init];
    
    [self.nameLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.totalScoreLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.totalScoreLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setData:(YXExamineRequestItem_body_bounsVoData *)data{
    _data = data;
    [self.nameLabel removeFromSuperview];
    [self.scoreLabel removeFromSuperview];
    [self.totalScoreLabel removeFromSuperview];
    [self.noScoreView removeFromSuperview];
    if (data.userscore.length == 0) {
        [self.contentView addSubview:self.noScoreView];
        [self.noScoreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0).offset(-5.0f);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(2);
        }];
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.text = data.name;
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0).offset(-5.0f);
            make.right.mas_equalTo(self.noScoreView.mas_left).mas_offset(-10).priorityHigh();
        }];
        [self.contentView addSubview:self.totalScoreLabel];
        self.totalScoreLabel.attributedText = [self totalScoreStringWithScore:data.totalscore];
        [self.totalScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(self.noScoreView.mas_right).mas_offset(10).priorityHigh();
            make.centerY.mas_equalTo(0).offset(-5.0f);
        }];
    }else{
        [self.contentView addSubview:self.scoreLabel];
        self.scoreLabel.text = data.userscore;
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(-30.0f);
            make.centerY.mas_equalTo(0.0f).offset(-5.0f);
            make.width.mas_offset(60.0f);
        }];
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.text = data.name;
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0).offset(-5.0f);
            make.right.mas_equalTo(self.scoreLabel.mas_left).mas_offset(-10).priorityHigh();
        }];
        [self.contentView addSubview:self.totalScoreLabel];
        self.totalScoreLabel.attributedText = [self totalScoreStringWithScore:data.totalscore];
        [self.totalScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.left.mas_equalTo(self.scoreLabel.mas_right).mas_offset(10).priorityHigh();
            make.centerY.mas_equalTo(0).offset(-5.0f);
        }];
    }
}

- (NSMutableAttributedString *)totalScoreStringWithScore:(NSString *)score{
    NSString *completeStr = [NSString stringWithFormat:@"满分%@",score];
    NSRange range = [completeStr rangeOfString:score];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:completeStr];
    [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:YXFontMetro_DemiBold size:13] range:range];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"a1a7ae"] range:range];
    return attr;
}

@end
