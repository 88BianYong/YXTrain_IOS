//
//  YXMessageCell_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, YXMessageCellStatus) {
    YXMessageCellStatus_Hotspot = 0,//热点
    YXMessageCellStatus_Dynamic = 1
    
};
@interface YXMessageCell_17 : UITableViewCell
@property (nonatomic ,strong) NSDictionary *nameDictionary;
@property (nonatomic, assign) YXMessageCellStatus cellStatus;
@end
