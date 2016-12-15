//
//  YXCourseFilterView.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/21.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXCourseFilterViewDelegate <NSObject>

- (void)filterChanged:(NSArray *)filterArray;

@end

@interface YXCourseFilterView : UIView

@property (nonatomic, weak) id<YXCourseFilterViewDelegate> delegate;


- (void)addFilters:(NSArray *)filters forKey:(NSString *)key;

- (void)setCurrentIndex:(NSInteger)index forKey:(NSString *)key;

- (void)refreshStudysFilters:(NSArray *)filters forKey:(NSString *)key;
- (void)refreshStagesFilters:(NSArray *)filters forKey:(NSString *)key;

@end
