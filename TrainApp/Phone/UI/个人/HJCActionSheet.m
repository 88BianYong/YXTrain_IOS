//
//  HJCActionSheet.m
//  wash
//
//  Created by weixikeji on 15/5/11.
//

#import "HJCActionSheet.h"

#define kActionSheetButtonHeight 45.f
#define kActionSheetTitleHeight 45.f
#define kActionSheetMargin 0
#define kActionSheetScreenWidth [UIScreen mainScreen].bounds.size.width
#define kActionSheetScreenHeight [UIScreen mainScreen].bounds.size.height
#define kActionSheetButtonTitleStyle(f) [UIFont systemFontOfSize:f]
#define kActionSheetButtonTitleFontSize kActionSheetScreenWidth>320?kActionSheetButtonTitleStyle(15.f):kActionSheetButtonTitleStyle(15.f)
#define kActionSheetBackgroundColor [UIColor colorWithRed:237/255.0 green:240/255.0f blue:242/255.0f alpha:1]
#define kActionSheetButtonBackgroundColor [UIColor whiteColor]

static CGFloat const spaceLine = 0;

@interface HJCActionSheet (){
    int _tag;
    BOOL _contentTitle;
}

@property (nonatomic, weak) HJCActionSheet *actionSheet;
@property (nonatomic, weak) UIView *sheetView;
@property (nonatomic, copy) NSString *labelText;

@end

@implementation HJCActionSheet

- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<HJCActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    HJCActionSheet *actionSheet = [self init];
    self.actionSheet = actionSheet;
    actionSheet.delegate = delegate;
    _labelText = title;
    _contentTitle = (title.length > 0) && ![title isEqual:@""] && (title != nil);
    // 黑色遮盖
    actionSheet.frame = [UIScreen mainScreen].bounds;
    actionSheet.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:actionSheet];
    actionSheet.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeActionSheetView)];
    [actionSheet addGestureRecognizer:tap];
    
    // sheet
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kActionSheetScreenWidth, 0)];
    sheetView.backgroundColor = kActionSheetBackgroundColor;
//    sheetView.alpha = 0.9;
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    sheetView.hidden = YES;
    _tag = 1;
    
    NSString* curStr;
    va_list list;
    if(otherButtonTitles){
        [self setupBtnWithTitle:otherButtonTitles];
        
        va_start(list, otherButtonTitles);
        while ((curStr = va_arg(list, NSString*))) {
            [self setupBtnWithTitle:curStr];
            
        }
        va_end(list);
    }
    
    CGRect sheetViewF = sheetView.frame;
    
#pragma mark - add
    sheetViewF.size.height = kActionSheetButtonHeight * _tag + kActionSheetMargin + (_contentTitle?kActionSheetTitleHeight+spaceLine:0) + spaceLine * (_tag - 1);
    sheetView.frame = sheetViewF;
    
    // cancel button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, sheetView.frame.size.height - kActionSheetButtonHeight - spaceLine, kActionSheetScreenWidth, kActionSheetButtonHeight);
    [btn setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    btn.titleLabel.font = kActionSheetButtonTitleFontSize;
    btn.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    btn.tag = 0;
    [btn addTarget:self action:@selector(sheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetView addSubview:btn];
    
    return actionSheet;
}

- (void)show{
    
    self.sheetView.hidden = NO;
    CGRect sheetViewF = self.sheetView.frame;
    sheetViewF.origin.y = kActionSheetScreenHeight;
    self.sheetView.frame = sheetViewF;
    
    CGRect newSheetViewF = self.sheetView.frame;
    newSheetViewF.origin.y = kActionSheetScreenHeight - self.sheetView.frame.size.height - kVerticalBottomUpwardHeight;
    
    [UIView animateWithDuration:0.3 animations:^{

        self.sheetView.frame = newSheetViewF;
        self.actionSheet.alpha = 0.5;
    }];
}

- (void)setupBtnWithTitle:(NSString *)title{
    
#pragma mark - add label
    if (_contentTitle) {
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kActionSheetScreenWidth, kActionSheetTitleHeight)];
        titleLbl.text = _labelText;
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.font = [UIFont systemFontOfSize:14.0f];
        titleLbl.textColor = [UIColor grayColor];
        titleLbl.backgroundColor = [UIColor whiteColor];
        [self.sheetView addSubview:titleLbl];
    }
    
    // other button
    CGFloat padding = (_contentTitle?kActionSheetTitleHeight + spaceLine:0) + (kActionSheetButtonHeight + spaceLine) * (_tag - 1);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0 ,padding, kActionSheetScreenWidth, kActionSheetButtonHeight);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
    btn.titleLabel.font = kActionSheetButtonTitleFontSize;
    btn.backgroundColor = kActionSheetButtonBackgroundColor;
    btn.tag = _tag;
    [btn addTarget:self action:@selector(sheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetView addSubview:btn];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(15, kActionSheetButtonHeight - 0.5, kActionSheetScreenWidth - 30, 0.5)];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [btn addSubview:bottomView];
    
    _tag ++;
}

- (void)removeActionSheetView{
    CGRect sheetViewF = self.sheetView.frame;
    sheetViewF.origin.y = kActionSheetScreenHeight;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.sheetView.frame = sheetViewF;
        self.actionSheet.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.actionSheet removeFromSuperview];
        [self.sheetView removeFromSuperview];
    }];
}

- (void)sheetBtnClick:(UIButton *)btn{
    if (btn.tag == 0) {
        [self removeActionSheetView];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self.actionSheet clickedButtonAtIndex:btn.tag];
        [self removeActionSheetView];
    }
}

- (UIImage *)createImageWithColor:(UIColor*)color{
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
