//
//  YXWriteHomeworkInfoHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWriteHomeworkInfoTitleView.h"
#import "SAMTextView.h"
@interface YXWriteHomeworkInfoTitleView()
<
  UITextViewDelegate
>
{
    UILabel *_titleLabel;
    SAMTextView *_textView;
}
@end
@implementation YXWriteHomeworkInfoTitleView
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:_textView];
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
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:14.0f];
    _textView.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
    _textView.layer.cornerRadius = YXTrainCornerRadii;
    _textView.textContainerInset = UIEdgeInsetsMake(15.0f, 10.0f, 0.0f, 0.0f);
    _textView.returnKeyType = UIReturnKeyDone;
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
        make.height.equalTo(_textView.mas_width).multipliedBy(180.0f/610.0f);
    }];
}

#pragma mark - textViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (range.location >30) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange
{
    if (_textView.text.length > 30) {
        _textView.text = [_textView.text substringToIndex:30];
        [_textView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    BLOCK_EXEC(self.titleStringHandler,_textView.text);
}
- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    _textView.text = _titleString;
}
@end
