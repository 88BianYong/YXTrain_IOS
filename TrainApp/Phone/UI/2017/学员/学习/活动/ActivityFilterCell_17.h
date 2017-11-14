//
//  ActivityFilterCell_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityFilterCell_17 : UICollectionViewCell
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isCurrent;
@property (nonatomic, strong) void(^activityFilterButtonActionBlock) (void);

+ (CGSize)sizeForTitle:(NSString *)title;
@end
