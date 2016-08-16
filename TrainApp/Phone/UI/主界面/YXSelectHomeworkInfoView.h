//
//  YXSelectHomeworkInfoView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCategoryListRequest.h"
@interface YXSelectHomeworkInfoView : UIView
@property (nonatomic, copy) void(^didSeletedItem)(NSInteger index ,YXWriteHomeworkListStatus status);
@property (nonatomic, copy)void(^tapCloseView)(YXWriteHomeworkListStatus status);
- (void)setViewWithDataArray:(NSArray *)itemArray
                 withStatus:(YXWriteHomeworkListStatus)status
              withSelectedId:(NSString *)integerId
                 withOriginY:(CGFloat)y;

@end
