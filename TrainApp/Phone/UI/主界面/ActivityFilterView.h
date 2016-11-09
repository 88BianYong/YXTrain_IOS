//
//  ActivityFilterView.h
//  TrainApp
//
//  Created by ZLL on 2016/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ActivityFilterViewDelegate <NSObject>

- (void)filterChanged:(NSArray *)filterArray;

@end


@interface ActivityFilterView : UIView

@property (nonatomic, weak) id<ActivityFilterViewDelegate> delegate;

- (void)addFilters:(NSArray *)filters forKey:(NSString *)key;

- (void)setCurrentIndex:(NSInteger)index forKey:(NSString *)key;
@end
