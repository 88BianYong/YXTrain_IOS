//
//  ActivityDetailManger.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityListDetailModel.h"

@interface ActivityDetailManger : NSObject
- (void)startRequestActivityListItem:(ActivityListRequestItem_body_activity *)item WithBlock:(void (^)(ActivityListDetailModel *, NSError *))aCompleteBlock;
@end
