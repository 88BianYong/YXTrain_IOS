//
//  YXSideTableViewCell.h
//  TrainApp
//
//  Created by 李五民 on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, YXSideTableViewCellStatus) {
    YXSideTableViewCellStatus_Hotspot,//热点
    YXSideTableViewCellStatus_Datum,
    YXSideTableViewCellStatus_Workshop,
    YXSideTableViewCellStatus_Dynamic
    
};

@interface YXSideTableViewCell : UITableViewCell
@property (nonatomic ,strong) NSDictionary *nameDictionary;
@property (nonatomic, assign) YXSideTableViewCellStatus cellStatus;
@end
