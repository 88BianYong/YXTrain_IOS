//
//  YXWriteHomeworkInfoHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWriteHomeworkInfoHeaderView.h"
#import "SAMTextView.h"
@interface YXWriteHomeworkInfoHeaderView()
{
    UILabel *_titleLabel;
    SAMTextView *_textView;
}
@end
@implementation YXWriteHomeworkInfoHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self layoutInterface];
    }
    return self;
}

#pragma mark - setupUI
- (void)setupUI{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"标题";
    _titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    _textView = [[SAMTextView alloc] init];
    _textView.font = [UIFont systemFontOfSize:14.0f];
    _textView.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
    _textView.textContainerInset = UIEdgeInsetsMake(15.0f, 15.0f, 0.0f, 0.0f);
    [self.contentView addSubview:_textView];
    _textView.placeholder = @"标题文字最多显示30字";
}

- (void)layoutInterface{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(22.0f);
        make.left.equalTo(self.contentView.mas_left);
        make.width.mas_offset(55.0f);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right);
        make.top.equalTo(self.contentView.mas_top).offset(10.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.height.equalTo(_textView.mas_width).priority(180.0f/610.0f);
    }];
}
@end
