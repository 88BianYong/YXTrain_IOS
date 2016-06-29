//
//  YXTopFilterView.h
//  TrainApp
//
//  Created by 李五民 on 16/6/28.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXTopFilterView : UIView

- (void)viewWithNameArray:(NSArray *)nameArray;
@property (nonatomic, copy) void(^buttonClicked)(NSInteger index);

- (void)btnTitileWithString:(NSString *)title index:(NSInteger)index;

@end
