//
//  MasterDetailActiveMemeberCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterDetailActiveMemeberCell_17.h"
@interface MasterDetailActiveMemeberCell_17 ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *oneLabel;
@property (nonatomic, strong) UILabel *twoLabel;
@property (nonatomic, strong) UILabel *threeLabel;
@property (nonatomic, assign) NSInteger showInteger;
@end
@implementation MasterDetailActiveMemeberCell_17
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setTotal:(MasterCountActiveItem_Body_CountMemeber_TotalArray *)total{
    /// 1"讨论":"discuss"  2"投票":"vote"   3 "资源分享":"resources"     4"问卷":"wenjuan"   5"视频" ："video"
    _total = total;
    self.titleLabel.text = _total.title;
    switch (_total.toolType.integerValue) {
        case 1:
        {
            self.oneLabel.text = [NSString stringWithFormat:@"评论次数: %@",_total.voteNum];
            self.twoLabel.text = [NSString stringWithFormat:@"点赞次数: %@",_total.likeNum];
            self.threeLabel.hidden = YES;
        }
            break;
        case 2:
        {
            self.oneLabel.text = _total.voteNum.integerValue > 0 ? @"已参与" : @"未参与";
            self.twoLabel.text = [NSString stringWithFormat:@"评论次数: %@",_total.voteNum];
            self.threeLabel.hidden = NO;
            self.threeLabel.text = [NSString stringWithFormat:@"点赞次数: %@",_total.likeNum];
        }
            break;
        case 3:
        {
            self.oneLabel.text = [NSString stringWithFormat:@"评论次数: %@",_total.voteNum];
            self.twoLabel.text = [NSString stringWithFormat:@"点赞次数: %@",_total.likeNum];
            self.threeLabel.hidden = NO;
            self.threeLabel.text = [NSString stringWithFormat:@"上传个数: %@",_total.uploadNum];
        }
            break;
        case 4:
        {
            self.oneLabel.text = _total.voteNum.integerValue > 0 ? @"已参与" : @"未参与";
            self.twoLabel.text = [NSString stringWithFormat:@"评论次数: %@",_total.voteNum];
            self.threeLabel.hidden = NO;
            self.threeLabel.text = [NSString stringWithFormat:@"点赞次数: %@",_total.likeNum];
        }
            break;
        case 5:
        {
            self.oneLabel.text = [NSString stringWithFormat:@"评论次数: %@",_total.voteNum];
            self.twoLabel.text = [NSString stringWithFormat:@"点赞次数: %@",_total.likeNum];
            self.threeLabel.hidden = YES;
        }
            break;
        default:
            break;
    }
}
#pragma mark - setupUI
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    
    self.oneLabel = [self fomartLabel];
    [self.contentView addSubview:self.oneLabel];
    self.twoLabel = [self fomartLabel];
    [self.contentView addSubview:self.twoLabel];
    self.threeLabel = [self fomartLabel];
    [self.contentView addSubview:self.threeLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(1.0f);
    }];
}
- (UILabel *)fomartLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"334466"];
    label.font = [UIFont systemFontOfSize:12.0f];
    return label;
}
- (void)setupLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(13.0f);
    }];
    [self.oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14.0f);
        make.width.mas_offset((kScreenWidth- 30.0f)/3.0f);
    }];
    
    [self.twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.oneLabel.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14.0f);
        make.width.mas_offset((kScreenWidth- 30.0f)/3.0f);
    }];
    
    [self.threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.twoLabel.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14.0f);
        make.width.mas_offset((kScreenWidth- 30.0f)/3.0f);
    }];
}
@end
