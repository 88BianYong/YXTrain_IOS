//
//  ReadingDetailHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadingDetailTableHeaderView_17 : UIView
@property (nonatomic, copy) NSString *contentString;
@property (nonatomic, copy) void(^readingDetailHeaderHeightChangeBlock)(CGFloat height);
- (void)relayoutHtmlText;
@end
