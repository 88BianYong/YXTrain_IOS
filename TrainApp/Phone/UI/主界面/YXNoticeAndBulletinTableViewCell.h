//
//  YXNoticeAndBulletinTableViewCell.h
//  TrainApp
//
//  Created by 李五民 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXNoticeListRequest.h"
@interface YXNoticeAndBulletinTableViewCell : UITableViewCell

- (void)configUIwithItem:(YXNoticeAndBulletinItem *)item isFirstOne:(BOOL)isFirstOne isLastOne:(BOOL)isLastOne;

@end
