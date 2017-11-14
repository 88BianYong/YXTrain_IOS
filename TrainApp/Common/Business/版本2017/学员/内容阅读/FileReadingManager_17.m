//
//  FileReadingManager_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FileReadingManager_17.h"

@implementation FileReadingManager_17
+ (BOOL)hasReadingWithFileName:(NSString *)name readingID:(NSString *)rID {
    NSString *rid = [name stringByAppendingString:rID];
    FileRecordEntity *item = [FileRecordEntity MR_findFirstByAttribute:@"rid" withValue:rid];
    if (item) {
        return YES;
    }
    return NO;
}

+ (void)saveReadingWithFileName:(NSString *)name readingID:(NSString *)rID {
    NSString *rid = [name stringByAppendingString:rID];
    FileRecordEntity *item = [FileRecordEntity MR_findFirstByAttribute:@"rid" withValue:rid];
    if (!item) {
        WEAK_SELF
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
            STRONG_SELF
            FileRecordEntity *item = [FileRecordEntity MR_createEntityInContext:localContext];
            item.rid = rid;
        }];
    }
}

@end
