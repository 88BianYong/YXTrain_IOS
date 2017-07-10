//
//  YXRotateListRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXRotateListRequest.h"

@implementation YXRotateListRequestItem_Rotates
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"rotateId"}];
}

- (NSString<Optional> *)resurl
{
    if ([_resurl hasPrefix:@"www"]) {
        _resurl = [NSString stringWithFormat:@"http://%@", _resurl];
    }
    return _resurl;
}
- (NSString <Optional> *)seconds
{
    return [NSString stringWithFormat:@"%ld",(long)YXTrainCornerStartpageTime];
}
- (UIImage *)localImage
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self localImagePath]]) {
        NSData *data = [NSData dataWithContentsOfFile:[self localImagePath]];
        return [UIImage imageWithData:data];
    }
    return nil;
}

- (NSString *)localImagePath
{
    NSString *directory = [NSString stringWithFormat:@"%@/cms", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]];
    BOOL isDirectory = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirectory];
    if (!(isExist && isDirectory)) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:directory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
    return [NSString stringWithFormat:@"%@/%@", directory, [self.startpageurl md5]];
}

- (void)saveImageToDisk:(UIImage *)image
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = UIImageJPEGRepresentation(image, 1);
        [data writeToFile:[self localImagePath] atomically:YES];
    });
}


@end

@implementation YXRotateListRequestItem

@end

@implementation YXRotateListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"main/getRotateList"];
    }
    return self;
}

@end
