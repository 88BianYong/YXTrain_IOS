//
//  LSTCollectionFilterDefaultView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTCollectionFilterDefaultModel.h"
@interface LSTCollectionFilterDefaultView : UIView
@property (nonatomic, strong) NSArray<LSTCollectionFilterDefaultModel *> *filterModel;
@property (nonatomic, copy) void(^filterSelectedBlock)(BOOL isChange);
@property (nonatomic, assign) CGSize collectionSize;
- (void)reloadData;
@end
