//
//  YXDatumSearchView.h
//  TrainApp
//
//  Created by 李五民 on 16/6/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXDatumSearchView : UIView
@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, copy)void(^textBeginEdit)();
@property (nonatomic, copy)void(^textShouldClear)();
@property (nonatomic, copy)void(^textShouldReturn)(NSString *);
@property (nonatomic, copy)void(^texEndEdit)();
@property (nonatomic, copy)void(^cancelButtonClickedBlock)();

- (void)setFirstResponse;

- (void)setTextFieldWithString:(NSString *)string;
@end
