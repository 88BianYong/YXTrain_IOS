//
//  YXDatumSearchBarView.h
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/1.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXDatumSearchBarViewDelegate <NSObject>

- (void)searchWithText:(NSString *)text;
- (void)searchCancel;

@end

@interface YXDatumSearchBarView : UIView
@property (nonatomic, weak) id<YXDatumSearchBarViewDelegate> delegate;

- (void)hideKeyboard;
@end
