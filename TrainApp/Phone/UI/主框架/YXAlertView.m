//
//  YXAlertView.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXAlertView.h"
#import <objc/runtime.h>

@interface YXAlertView ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *actions;

@end

@implementation YXAlertView

- (void)dealloc
{
    objc_removeAssociatedObjects(self);
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    if (self == nil) return nil;
    _actions = @[];
    return self;
}

+ (instancetype)alertViewWithTitle:(NSString *)title
{
    return [[self alloc] initWithTitle:title message:nil];
}

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message
{
    return [[self alloc] initWithTitle:title message:message];
}

- (void)addButtonWithTitle:(NSString *)title action:(YXAlertViewBlock)block
{
    NSParameterAssert(title);
    
    [super addButtonWithTitle:title];
    id blockOrNull = [block copy] ?: [NSNull null];
    self.actions = [self.actions arrayByAddingObject:blockOrNull];
}

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    self.actions = [self.actions arrayByAddingObject:[NSNull null]];
    return [super addButtonWithTitle:title];
}

- (void)show
{
    [self addRetainCircle];
    [super show];
}

#pragma mark -

- (const void *)associateKey
{
    return "retainKey";
}

- (void)addRetainCircle
{
    objc_setAssociatedObject(self, [self associateKey], self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)breakCircle
{
    objc_setAssociatedObject(self, [self associateKey], nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSParameterAssert(buttonIndex < [self.actions count]);
    if (buttonIndex >= [self.actions count]) return;
    
    id block = self.actions[buttonIndex];
    if (block != [NSNull null]) {
        ((YXAlertViewBlock)block)();
    }
    [self breakCircle];
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    [self breakCircle];
}

@end


@implementation YXAlertView (YXConfirmMethod)

+ (void)showAlertViewWithMessage:(NSString *)message
{
    YXAlertView *alertView = [YXAlertView alertViewWithTitle:@"提示" message:message];
    [alertView addButtonWithTitle:@"确定"];
    [alertView show];
}

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message hint:(NSString *)hint
{
    YXAlertView *alertView = [YXAlertView alertViewWithTitle:title message:message];
    [alertView addButtonWithTitle:hint];
    [alertView show];
}
@end

