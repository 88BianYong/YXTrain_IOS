//
//  FileReadingManager_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileRecordEntity.h"
@interface FileReadingManager_17 : NSObject
+ (BOOL)hasReadingWithFileName:(NSString *)name readingID:(NSString *)rID;
+ (void)saveReadingWithFileName:(NSString *)name readingID:(NSString *)rID;
@end
