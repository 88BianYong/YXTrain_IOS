//
//  YXFileVideoItem.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileItemBase.h"
@interface YXFileVideoClassworkItem : NSObject
@property (nonatomic, copy) NSString *quizzesID;//随堂练ID
@property (nonatomic, copy) NSString *timeString;//显示时间
@property (nonatomic, assign) BOOL isTrue;//是否正确
@end
@interface YXFileVideoItem : YXFileItemBase
@end
