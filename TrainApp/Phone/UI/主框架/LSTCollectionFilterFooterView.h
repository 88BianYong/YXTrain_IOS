//
//  LSTCollectionFilterFooterView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/9/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSTCollectionFilterFooterView : UICollectionReusableView
@property (nonatomic, copy) void(^courseFilterCompleteBlock)(BOOL isCancleBool);

@end
