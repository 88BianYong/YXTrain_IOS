//
//  YXWorkshopDetailGroupCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YXWorkshopDetailGroupCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray *memberMutableArray;
- (void)reloadWithTitle:(NSString *)titleString
                content:(NSString *)contentString;
@end
