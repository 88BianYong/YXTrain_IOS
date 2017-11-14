//
//  YXDatumSearchBarView.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/1.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXDatumSearchBarView.h"

@interface YXDatumSearchBarView()<UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation YXDatumSearchBarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.searchBar = [[UISearchBar alloc]init];
    if ([self.searchBar respondsToSelector:@selector(setReturnKeyType:)]) {
        self.searchBar.returnKeyType = UIReturnKeySearch; // Pick a type
    }
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.placeholder = @"输入文件名称搜索";
    self.searchBar.tintColor = [UIColor grayColor];
    self.searchBar.delegate = self;
    [self addSubview:self.searchBar];
    
    self.cancelButton = [[UIButton alloc]init];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.cancelButton.mas_left).mas_offset(-8);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-8);
    }];
}

- (void)cancelAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchCancel)]) {
        [self.delegate searchCancel];
    }
}

- (void)hideKeyboard{
    [self.searchBar resignFirstResponder];
}

#pragma UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchWithText:)]) {
        [self.delegate searchWithText:searchBar.text];
    }
}
@end
