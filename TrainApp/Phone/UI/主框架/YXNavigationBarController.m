//
//  YXNavigationBarController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXNavigationBarController.h"

@implementation YXNavigationBarController

+ (void)setup{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage yx_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorWithHexString:@"334466"], NSForegroundColorAttributeName,
                                                [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                nil]];
}

+ (void)setLeftWithNavigationItem:(UINavigationItem *)item imageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName action:(actionBlock)action{
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIImage *highlightImage = [UIImage imageNamed:highlightImageName];
    CGFloat width = normalImage.size.width + 20.0f;
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, normalImage.size.height + 20)];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setImage:normalImage forState:UIControlStateNormal];
    [backButton setImage:highlightImage forState:UIControlStateHighlighted];
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        BLOCK_EXEC(action);
    }];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    item.leftBarButtonItems = @[[self negativeBarButtonItem],leftItem];
}

+ (void)setLeftWithNavigationItem:(UINavigationItem *)item customView:(UIView *)view{
    CGRect rect = view.bounds;
    CGFloat width = rect.size.width + 20.0f;
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 11.0f) {
        width = rect.size.width;
    }
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:view];
    view.center = CGPointMake(containerView.bounds.size.width/2, containerView.bounds.size.height/2);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:containerView];
    
    item.leftBarButtonItems = @[[self negativeBarButtonItem],rightItem];
}

+ (void)setRightWithNavigationItem:(UINavigationItem *)item imageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName action:(actionBlock)action{
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIImage *highlightImage = [UIImage imageNamed:highlightImageName];
    CGFloat width = normalImage.size.width + 20.0f;
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 11.0f) {
        width = normalImage.size.width;
    }
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, normalImage.size.height)];
    [rightButton setImage:normalImage forState:UIControlStateNormal];
    [rightButton setImage:highlightImage forState:UIControlStateHighlighted];
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        BLOCK_EXEC(action);
    }];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    item.rightBarButtonItems = @[[self negativeBarButtonItem],rightItem];
}

+ (void)setRightWithNavigationItem:(UINavigationItem *)item title:(NSString *)title action:(actionBlock)action{
    UIButton *b = [[UIButton alloc]init];
    b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
//    [b setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    b.titleLabel.font = [UIFont systemFontOfSize:13];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:b.titleLabel.font}];
    b.frame = CGRectMake(0, 0, ceilf(size.width)+20, ceilf(size.height));
    [[b rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        BLOCK_EXEC(action);
    }];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:b];
    item.rightBarButtonItems = @[[self negativeBarButtonItem],rightItem];
}

+ (void)setRightWithNavigationItem:(UINavigationItem *)item customView:(UIView *)view{
    CGRect rect = view.bounds;
    CGFloat width = rect.size.width + 20.0f;
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, rect.size.height)];
    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:view];
    view.center = CGPointMake(containerView.bounds.size.width/2 + 10.0f, containerView.bounds.size.height/2);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:containerView];
    
    item.rightBarButtonItems = @[[self negativeBarButtonItem],rightItem];
}

+ (UIBarButtonItem *)negativeBarButtonItem{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSpacer.width = ;
    return negativeSpacer;
}

+ (void)enableRightNavigationItem:(UINavigationItem *)naviItem{
    for (UIBarButtonItem *item in naviItem.rightBarButtonItems) {
        item.enabled = YES;
    }
}

+ (void)disableRightNavigationItem:(UINavigationItem *)naviItem{
    for (UIBarButtonItem *item in naviItem.rightBarButtonItems) {
        item.enabled = NO;
    }
}

+ (UIButton *)naviButtonForTitle:(NSString *)title {
    UIButton *b = [[UIButton alloc]init];
    [b setImage:[UIImage imageNamed:@"收藏正常态"] forState:UIControlStateNormal];
//    [b setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    b.titleLabel.font = [UIFont systemFontOfSize:13];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:b.titleLabel.font}];
    b.frame = CGRectMake(0, 0, ceilf(size.width)+20, ceilf(size.height));
    return b;
}

+ (NSArray *)barButtonItemsForView:(UIView *)view{
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    return @[[self negativeBarButtonItem],buttonItem];
}

@end
