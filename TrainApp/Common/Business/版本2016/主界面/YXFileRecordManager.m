//
//  YXFileRecordManager.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileRecordManager.h"
#import "FileRecordEntity.h"

@implementation YXFileRecordManager
- (BOOL)hasRecordWithFilename:(NSString *)name url:(NSString *)url{
    NSString *uid = [name stringByAppendingString:[url md5]];
    FileRecordEntity *item = [FileRecordEntity MR_findFirstByAttribute:@"uid" withValue:uid];
    if (item) {
        return YES;
    }
    return NO;
}

- (void)saveRecordWithFilename:(NSString *)name url:(NSString *)url{
    NSString *uid = [name stringByAppendingString:[url md5]];
    FileRecordEntity *item = [FileRecordEntity MR_findFirstByAttribute:@"uid" withValue:uid];
    if (!item) {
        WEAK_SELF
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
            STRONG_SELF
            FileRecordEntity *item = [FileRecordEntity MR_createEntityInContext:localContext];
            item.uid = uid;
        }];
    }
}

@end
