//
//  YXHelpHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHelpHeaderView.h"
@interface YXHelpHeaderView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *openButton;
@end
@implementation YXHelpHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self layoutInterface];
    }
    return self;
}

- (void)setupUI{
    self.imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:self.titleLabel];
    
    self.openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.openButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.openButton];
    
}

- (void)layoutInterface{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
        make.centerY.equalTo(self.contentView.mas_centerY).offset(3.5f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(12.0f);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(3.5f);
    }];
    

    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.titleLabel.text = _titleString;
}

- (void)setIsOpen:(BOOL)isOpen{
    _isOpen = isOpen;
    if (_isOpen) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"a53027"];
        self.imageView.image = [UIImage imageNamed:@"Q--展开"];
    }else{
     self.titleLabel.textColor = [UIColor colorWithHexString:@"334466"];
        self.imageView.image = [UIImage imageNamed:@"Q--未展开"];
    }
}
- (void)buttonAction:(UIButton *)sender{
    BLOCK_EXEC(self.openAndClosedHandler,self.isOpen);
}
@end
