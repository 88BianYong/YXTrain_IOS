//
//  YXCMSManager.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCMSManager.h"
#import "NSString+Hashes.h"

@implementation YXCMSModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
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
    return [NSString stringWithFormat:@"%@/%@", directory, [self.imageUrl md5]];
}

- (void)saveImageToDisk:(UIImage *)image
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = UIImageJPEGRepresentation(image, 1);
        [data writeToFile:[self localImagePath] atomically:YES];
    });
}

+ (instancetype)modelWithItem:(YXRotateListRequestItem_Rotates *)item
{
    YXCMSModel *model = [[YXCMSModel alloc] init];
    model.seconds = 3;
    model.type = [item.type integerValue];
    model.imageUrl = item.pic;
    model.resurl = item.resurl;
    model.topicId = item.pid;
    model.uid = item.uid;
    return model;
}

@end

@interface YXCMSManager()
@property (nonatomic, strong) YXRotateListRequest *listRequest;
@end

@implementation YXCMSManager

+ (instancetype)sharedManager
{
    static YXCMSManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXCMSManager alloc] init];
    });
    return manager;
}

- (void)requestWithType:(NSString *)type
             completion:(void (^)(NSArray *, NSError *))completion
{
    if (self.listRequest) {
       [self.listRequest stopRequest];
    }
    YXRotateListRequest *request = [[YXRotateListRequest alloc] init];
    request.type = type;
    [request startRequestWithRetClass:[YXRotateListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        if (!error) {
            YXRotateListRequestItem *item = retItem;
            completion(item.rotates,error);
        }
    }];
    self.listRequest = request;
}

#pragma mark - mock data

+ (YXCMSModel *)mockData
{
    YXCMSModel *model = [[YXCMSModel alloc] init];
    model.seconds = 3;
    model.imageUrl = @"http://upload.yanxiu.com/resource/index.jsp?action=download&id=12056929";
    int random = arc4random()%100;
    model.type = random % 6;
    model.resurl = @"https://git.oschina.net";
    model.topicId = @"37323";
    model.uid = @"11189602";
    return model;
}

@end
