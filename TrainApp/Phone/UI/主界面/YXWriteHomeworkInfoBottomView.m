//
//  YXWriteHomeworkInfoFooterView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWriteHomeworkInfoBottomView.h"
#import "SAMTextView.h"
@interface YXWriteHomeworkInfoBottomView()
<
  UITextViewDelegate
>
{
    UILabel *_titleLabel;
    SAMTextView *_textView;
}
@end

@implementation YXWriteHomeworkInfoBottomView
- (void)dealloc{
    [_saveButton removeObserver:self forKeyPath:@"selected"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self layoutInterface];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:_textView];
        [_saveButton addObserver:self forKeyPath:@"selected"options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

#pragma mark - setup UI
- (void)setupUI{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"本次作业的主要知识点~";
    _titleLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _textView = [[SAMTextView alloc] init];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:14.0f];
    _textView.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
    _textView.layer.cornerRadius = YXTrainCornerRadii;
    _textView.textContainerInset = UIEdgeInsetsMake(15.0f, 10.0f, 0.0f, 0.0f);
    [self addSubview:_textView];
    _textView.placeholder = @"内容文字最多显示30字";
    
    _saveButton = [[UIButton alloc] init];
    [_saveButton setImage:[UIImage imageNamed:@"上传视频图标不可点击态"] forState:UIControlStateNormal];
    [_saveButton setImage:[UIImage imageNamed:@"上传视频图标点击态"] forState:UIControlStateHighlighted];
    [_saveButton setImage:[UIImage imageNamed:@"上传视频图标正常态"] forState:UIControlStateSelected];
    [_saveButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
    [_saveButton setTitle:@"保存并上传" forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_saveButton setTitleColor:[UIColor colorWithHexString:@"0070c9"] forState:UIControlStateSelected];
    [_saveButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10.0f, 0, 0)];
    _saveButton.layer.cornerRadius = YXTrainCornerRadii;
    _saveButton.layer.borderWidth = 1.0f;
    _saveButton.layer.borderColor = [UIColor colorWithHexString:@"dfe2e6"].CGColor;
    _saveButton.clipsToBounds = YES;
    _saveButton.layer.masksToBounds = YES;
    _saveButton.selected = NO;
    [self addSubview:_saveButton];
}

- (void)layoutInterface{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(70.0f);
        make.height.mas_offset(45.0f);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(55.0f);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.height.equalTo(_textView.mas_width).multipliedBy(180.0f/610.0f);
    }];
    
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_textView.mas_bottom).offset(30.0f);
        make.height.mas_offset(44.0f);
        make.width.mas_offset(225.0f);
    }];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"selected"]) {
        if (_saveButton.selected) {
             _saveButton.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;
        }else{
             _saveButton.layer.borderColor = [UIColor colorWithHexString:@"dfe2e6"].CGColor;
        }
    }
}
#pragma mark - textViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location >30) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange
{
    if (_textView.text.length > 30) {
        _textView.text = [_textView.text substringToIndex:30];
    }
    BLOCK_EXEC(self.topicStringHandler,_textView.text);
}

@end
