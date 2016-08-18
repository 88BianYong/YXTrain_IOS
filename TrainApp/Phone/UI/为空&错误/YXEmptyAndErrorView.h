//
//  YXEmptyAndErrorView.h
//  TrainApp
//
//  Created by Lei Cai on 8/18/16.
//  Copyright © 2016 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  由于image + label总是居中于view，所以如果UI是居中于整个window，则添加时需要手工加上statusBar和navigationBar
 *  eg : make.edges.mas_equalTo(UIEdgeInsetsMake(-20-44, 0, 0, 0));
 */

@interface YXEmptyAndErrorView : UIView
- (void)updateWithImageNamed:(NSString *)imagename andTitle:(NSString *)title;
@end


// 测试方法

//- (void)test {
//    NSArray *arr = @[
//                     @"abcd",
//                     @"abc\nabc\nabc\nabc",
//                     @"look into my eye, you will see, what you mean to me"
//                     ];
//    
//    
//    YXEmptyAndErrorView *eeview = [[YXEmptyAndErrorView alloc] init];
//    [self.view addSubview:eeview];
//    [eeview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(-20-44-44, 0, 0, 0));
//    }];
//    [eeview updateWithImageNamed:nil andTitle:@"abcasdasdga\nsdgas\ndgasd\ngasdgasdgasdgasdg"];
//    for (int i = 0; i < 10; i++) {
//        NSString *str = arr[i%3];
//        [self performSelector:@selector(test2:) withObject:str afterDelay:i*3];
//    }
//    
//    _eeview = eeview;
//}
//
//- (void)test2:(NSString *)str {
//    [_eeview updateWithImageNamed:@"数据错误" andTitle:str];
//}
