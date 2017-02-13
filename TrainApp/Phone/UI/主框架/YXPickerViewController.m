//
//  YXPickerViewController.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/12.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPickerViewController.h"

@interface YXPickerViewController ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *cancelButton;
//@property (nonatomic, strong) UIView *blankView;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation YXPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubviews];
    [self hidePickerView:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        [self setUpSubviews];
    }
    return _pickerView;
}

- (void)reloadPickerView
{
    [self showPickerView:YES];
    [self.pickerView reloadAllComponents];
}

#pragma mark - touches

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (!CGRectContainsPoint(self.contentView.frame, point)) {
        [self hidePickerView:YES];
    }
}

#pragma mark -

- (void)setUpSubviews
{
    self.view.backgroundColor = [UIColor clearColor];
    _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.5f;
    [self.view addSubview:_backgroundView];
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_contentView addSubview:_cancelButton];
    
    _confirmButton = [[UIButton alloc] init];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.titleLabel.font = _cancelButton.titleLabel.font;
    [_contentView addSubview:_confirmButton];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
    [_contentView addSubview:bottomLineView];
    
    _pickerView = [[UIPickerView alloc] init];
    [_contentView addSubview:_pickerView];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.height.equalTo(@246);
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.height.equalTo(@40);
        make.left.mas_equalTo(self.contentView.mas_left).offset(40);
    }];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.height.equalTo(self->_cancelButton.mas_height);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-40);
    }];
    
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self->_cancelButton.mas_bottom);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.top.equalTo(self->_cancelButton.mas_bottom);
    }];
    [self clearSeparatorWithView:_pickerView];
}

- (void)showPickerView:(BOOL)animated
{
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat contentHeight = CGRectGetHeight(self.contentView.bounds);
    CGRect frame = CGRectMake(0, height - contentHeight, width, contentHeight);
    self.contentView.frame = CGRectMake(0, height, width, contentHeight);
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.contentView.frame = frame;
                     } completion:^(BOOL finished) {
                         
                     }];
    self.view.hidden = NO;
}

- (void)hidePickerView:(BOOL)animated
{
    if (animated) {
        CGFloat height = CGRectGetHeight(self.view.bounds);
        CGFloat width = CGRectGetWidth(self.view.bounds);
        CGFloat contentHeight = CGRectGetHeight(self.contentView.bounds);
        CGRect frame = CGRectMake(0, height, width, contentHeight);
        self.contentView.frame = CGRectMake(0, height - contentHeight, width, contentHeight);
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.contentView.frame = frame;
                         } completion:^(BOOL finished) {
                             self.view.hidden = YES;
                         }];
    } else {
        self.view.hidden = YES;
    }
}

- (void)cancelAction:(id)sender
{
    [self hidePickerView:YES];
}

- (void)confirmAction:(id)sender
{
    [self hidePickerView:YES];
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}
- (void)clearSeparatorWithView:(UIView * )view
{
    if(view.subviews != 0  )
    {
        if(view.bounds.size.height < 5)
        {
            view.backgroundColor = [UIColor clearColor];
        }
        
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
    
}

@end
