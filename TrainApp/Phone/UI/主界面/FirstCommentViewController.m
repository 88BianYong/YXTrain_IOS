//
//  FirstCommentViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "FirstCommentViewController.h"
#import "ActivityCommentInputView.h"
#import "SendCommentView.h"
@interface FirstCommentViewController ()
@property (nonatomic, strong) ActivityCommentInputView *inputTextView;
@property (nonatomic, strong) SendCommentView *sendView;
@end

@implementation FirstCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    [super setupUI];
    self.sendView = [[SendCommentView alloc] init];
    [self.view addSubview:self.sendView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCommentInputView)];
    [self.sendView addGestureRecognizer:recognizer];
    
    self.inputTextView = [[ActivityCommentInputView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64.0f - 44.0f, kScreenWidth, 44.0f)];
    [self.view addSubview:self.inputTextView];

}

- (void)setupLayout {
    [super setupLayout];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-44.0f);
        make.top.equalTo(self.view.mas_top);
    }];
    [self.inputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_bottom);
        make.height.mas_offset(140.0f);
    }];
    [self.sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_offset(44.0f);
    }];
}
- (void)showCommentInputView {
    [self.inputTextView.textView becomeFirstResponder];
}
@end
