//
//  ResourceMessageView.m
//  TrainApp
//
//  Created by ZLL on 2016/11/18.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ResourceMessageView.h"

@interface ResourceMessageView ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *uploadInfoLabel;
//@property (nonatomic, assign) CGFloat dateLbelWidth;
//@property (nonatomic, assign) CGFloat sizeLabelWidth;
@end

@implementation ResourceMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 2.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
    self.iconView = [[UIImageView alloc]init];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.numberOfLines = 2;
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    
    self.sizeLabel = [[UILabel alloc]init];
    self.sizeLabel.font = [UIFont systemFontOfSize:12];
    self.sizeLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.sizeLabel.textAlignment = NSTextAlignmentCenter;
    
    self.uploadInfoLabel = [[UILabel alloc]init];
    self.uploadInfoLabel.font = [UIFont systemFontOfSize:12];
    self.uploadInfoLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.uploadInfoLabel.textAlignment = NSTextAlignmentCenter;
}
- (void)setupLayout {
    [self addSubview:self.iconView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.dateLabel];
    [self addSubview:self.sizeLabel];
    [self addSubview:self.uploadInfoLabel];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(24);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(15);
        make.centerX.equalTo(self.iconView);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.titleLabel);
        make.width.mas_equalTo(315);
        make.height.mas_equalTo(0.5);
    }];
    CGFloat dateLbelWidth = [self.dateLabel.text sizeWithAttributes:@{NSFontAttributeName:self.dateLabel.font}].width;
    CGFloat sizeLabelWidth = [self.sizeLabel.text sizeWithAttributes:@{NSFontAttributeName:self.sizeLabel.font}].width;
    CGFloat margin = (self.bounds.size.width - dateLbelWidth - sizeLabelWidth - 13) * 0.5;
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.left.mas_equalTo(margin);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel);
        make.left.equalTo(self.dateLabel.mas_right).offset(13);
    }];
    [self.uploadInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
}
- (void)updateLayout {
    CGFloat dateLbelWidth = [self.dateLabel.text sizeWithAttributes:@{NSFontAttributeName:self.dateLabel.font}].width;
    CGFloat sizeLabelWidth = [self.sizeLabel.text sizeWithAttributes:@{NSFontAttributeName:self.sizeLabel.font}].width;
    CGFloat margin = (self.bounds.size.width - dateLbelWidth - sizeLabelWidth - 13) * 0.5;
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.left.mas_equalTo(margin);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel);
        make.left.equalTo(self.dateLabel.mas_right).offset(13);
    }];
}
- (void)setData:(YXDatumCellModel *)data {
    _data =data;
    self.iconView.image = data.image;
    self.titleLabel.text = data.title;
    self.dateLabel.text = data.date;
    self.sizeLabel.text = [BaseDownloader sizeStringForBytes:data.size];
    self.uploadInfoLabel.text = [NSString stringWithFormat:@"上传  %@",data.createUsername];
    if (data.isFavor) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    }
    [self updateLayout];
}
@end
