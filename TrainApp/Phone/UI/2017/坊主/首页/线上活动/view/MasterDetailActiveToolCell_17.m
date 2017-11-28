//
//  MasterDetailActiveToolCell_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterDetailActiveToolCell_17.h"
@interface MasterDetailActiveToolCell_17 ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *joinUserLabel;
@property (nonatomic, strong) UILabel *discussLabel;
@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UILabel *uploadLabel;

@end
@implementation MasterDetailActiveToolCell_17
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
- (void)setTool:(MasterCountActiveItem_Body_CountTool *)tool {
    _tool = tool;
    self.titleLabel.text = _tool.title;
    self.joinUserLabel.text = [NSString stringWithFormat:@"成员: %@",_tool.total.joinUserNum];
    self.discussLabel.text = [NSString stringWithFormat:@"回复: %@",_tool.total.discussNum];
    self.likeLabel.text = [NSString stringWithFormat:@"点赞: %@",_tool.total.likeNum];
    self.uploadLabel.text = [NSString stringWithFormat:@"上传: %@",_tool.total.uploadNum];
}
#pragma mark - setupUI
- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.contentView addSubview:self.titleLabel];
    
    self.joinUserLabel = [self fomartLabel];
    [self.contentView addSubview:self.joinUserLabel];
    self.discussLabel = [self fomartLabel];
    [self.contentView addSubview:self.discussLabel];
    self.likeLabel = [self fomartLabel];
    [self.contentView addSubview:self.likeLabel];
    self.uploadLabel = [self fomartLabel];
    [self.contentView addSubview:self.uploadLabel];
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
    [self.joinUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14.0f);
        make.width.mas_offset((kScreenWidth- 30.0f)/4.0f);
    }];
    
    [self.discussLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.joinUserLabel.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14.0f);
        make.width.mas_offset((kScreenWidth- 30.0f)/4.0f);
    }];
    
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discussLabel.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14.0f);
        make.width.mas_offset((kScreenWidth- 30.0f)/4.0f);
    }];
    
    [self.uploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeLabel.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14.0f);
        make.width.mas_offset((kScreenWidth- 30.0f)/4.0f);
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

@end
