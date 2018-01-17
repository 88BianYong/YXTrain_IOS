//
//  LSTCollectionFilterView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/9/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTCollectionFilterModel.h"
@interface LSTCollectionFilterView : UIView
@property (nonatomic, strong) LSTCollectionFilterModel *filterModel;
@property (nonatomic, assign) CGFloat maxHeight;

@property (nonatomic, copy) void(^filterSelectedBlock)(LSTCollectionFilterModel_ItemName *itemName);
@property (nonatomic, assign) CGSize collectionSize;
- (void)cancleUserSelected;
@end
