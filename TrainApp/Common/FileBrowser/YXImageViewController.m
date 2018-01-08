//
//  YXImageViewController.m
//  YanXiuApp
//
//  Created by Lei Cai on 6/10/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXImageViewController.h"
#import "ReaderMainToolbar.h"
#import "ReaderDocument.h"
@interface YXImageViewController() //<ReaderMainToolbarDelegate>
@end

@implementation YXImageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    ReaderDocument *d = [[ReaderDocument alloc] init];
//    
//    ReaderMainToolbar *mainToolbar = [[ReaderMainToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44) document:d];
//    mainToolbar.delegate = self; // ReaderMainToolbarDelegate
//    mainToolbar.backgroundColor = [UIColor blueColor];
//    mainToolbar.nameLabel.text = self.title;
//    mainToolbar.rightFavorButton = self.favorWrapper.favorButton;
//    [self.view addSubview:mainToolbar];
    
    [self setupLeftBack];
    self.navigationItem.rightBarButtonItems = [YXNavigationBarController barButtonItemsForView:self.favorWrapper.favorButton];

    UIImageView *imageView = [[UIImageView alloc] init];
    
    if (self.image) {
        imageView.image = self.image;
    }
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.bottom.left.right.mas_equalTo(@0);
    }];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainPushNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        [self naviLeftAction];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"附件浏览页面" withStatus:YES];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"附件浏览页面" withStatus:NO];

    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)naviLeftAction{
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainDocumentRetryTimer object:@(NO)];
    SAFE_CALL(self.exitDelegate, browserExit);
}

//- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar doneButton:(UIButton *)button
//{
//    [self dismissViewControllerAnimated:NO completion:nil];
//    SAFE_CALL(self.exitDelegate, browserExit);
//}
//
//- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar favouriteButton:(UIButton *)button {
//    
//}

@end
