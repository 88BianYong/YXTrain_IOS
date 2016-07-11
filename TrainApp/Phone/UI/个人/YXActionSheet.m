//
//  YXActionSheet.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXActionSheet.h"
#import <objc/runtime.h>

@interface YXActionSheet ()<UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *actions;

@end

@implementation YXActionSheet

- (void)dealloc
{
    self.delegate = nil;
}

- (instancetype)initWithTitle:(NSString *) title
{
    self = [super initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    if (self == nil) return nil;
    _actions = @[];
    return self;
}

+ (instancetype)actionSheetWithTitle:(NSString *)title
{
    return [[self alloc] initWithTitle:title];
}

- (void)addButtonWithTitle:(NSString *)title action:(YXActionSheetBlock)block
{
    NSParameterAssert(title);
    [super addButtonWithTitle:title];
    id blockOrNull = [(id)block copy]?: [NSNull null];
    self.actions = [self.actions arrayByAddingObject:blockOrNull];
}

- (void)addDestructiveButtonWithTitle:(NSString *)title action:(YXActionSheetBlock)block
{
    [self addButtonWithTitle:title action:block];
    self.destructiveButtonIndex = [self.actions count] - 1;
}

- (void)addCancelButtonWithTitle:(NSString *)title action:(YXActionSheetBlock)block
{
    [self addButtonWithTitle:title action:block];
    self.cancelButtonIndex = [self.actions count] - 1;
}

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    self.actions = [self.actions arrayByAddingObject:[NSNull null]];
    return [super addButtonWithTitle:title];
}

- (const void *) associateKey{
    return "retainKey";
}

#pragma mark - delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSParameterAssert(buttonIndex < [self.actions count]);
    if (buttonIndex >= [self.actions count]) return;
    
    id block = self.actions[buttonIndex];
    if (block != [NSNull null]) {
        ((YXActionSheetBlock)block)();
    }
    [self breakRetainCircle];
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [self breakRetainCircle];
}

- (void)addRetainCircle
{
    objc_setAssociatedObject(self, [self associateKey], self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)breakRetainCircle
{
    objc_setAssociatedObject(self, [self associateKey], nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - actionSheet method
- (void)showFromToolbar:(UIToolbar *)view
{
    [self addRetainCircle];
    [super showFromToolbar:view];
}

- (void)showFromTabBar:(UITabBar *)view
{
    [self addRetainCircle];
    [super showFromTabBar:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated NS_AVAILABLE_IOS(3_2)
{
    [self addRetainCircle];
    [super showFromBarButtonItem:item animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated NS_AVAILABLE_IOS(3_2)
{
    [self addRetainCircle];
    [super showFromRect:rect inView:view animated:animated];
}

- (void)showInView:(UIView *)view
{
    [self addRetainCircle];
    [super showInView:view];
}

@end
