//
//  YXQiNiuVideoUpload.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
#import "YXQiNiuVideoUpload.h"

@interface YXQiNiuVideoUpload()
@property (nonatomic, copy) NSString *fileCachePath;//最终文件路径为fileCachePath／key
@property (nonatomic, strong) QNFileRecorder *fileRecorder;
@property (nonatomic, strong) QNUploadManager *upManager;
@property (nonatomic, strong) QNUploadOption *opt;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, copy) NSString *qiNiuToken;
@property (nonatomic, copy) NSString *keyName;


@end
@implementation YXQiNiuVideoUpload
- (id)initWithFileName:(NSString *)fileName qiNiuToken:(NSString *)qiNiuToken{
    self = [super init];
    if (self) {
        
        self.isCancel = NO;
        NSError *error = nil;
        self.fileCachePath = PATH_OF_VIDEO_CACHE ;
        self.fileRecorder = [QNFileRecorder fileRecorderWithFolder:self.fileCachePath error:&error];
        self.filePath = [PATH_OF_VIDEO stringByAppendingPathComponent:fileName];
        self.qiNiuToken = qiNiuToken;
        self.keyName = [NSString stringWithFormat:@"%@.mp4",[FileHash md5HashOfFileAtPath:[PATH_OF_VIDEO stringByAppendingPathComponent:fileName]]];
        
        self.upManager = [[QNUploadManager alloc] initWithRecorder:self.fileRecorder
                          ];
        WEAK_SELF
        self.opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
            STRONG_SELF
            if ([self.delegate respondsToSelector:@selector(uploadProgress:)] && self.delegate) {
                [self.delegate uploadProgress:percent];
            }
        } params:nil checkCrc:NO cancellationSignal:^BOOL{
            
            return self.isCancel;
        }];
    }
    return self;
}
- (void)startUpload{
    self.isCancel = NO;
    NSString *keyUp = self.keyName;
    __block NSString *key = nil;
    __block QNResponseInfo *info = nil;
    [_upManager putFile: self.filePath key:keyUp token:self.qiNiuToken   complete: ^(QNResponseInfo *i, NSString *k, NSDictionary *resp) {
        key = k;
        info = i;
        if (i.statusCode == 200) {
            if ([self.delegate respondsToSelector:@selector(uploadCompleteWithHash:andVideoKey:)]) {
                [self.delegate uploadCompleteWithHash:resp[@"hash"] andVideoKey:resp[@"key"]];
            }
        } else if (i.statusCode == 614) {
            if ([self.delegate respondsToSelector:@selector(uploadCompleteWithHash:andVideoKey:)]) {
                [self.delegate uploadCompleteWithHash:resp[@"hash"] andVideoKey:resp[@"key"]];
            }
        }else {
            NSString *error = [NSString stringWithFormat:@"error=%@,reqid=%@,xlog=%@,host=%@,id=%@,hash=%@,key=%@",i.error,i.reqId,i.xlog,i.host,i.id,resp[@"hash"],resp[@"key"]];
            NSDictionary *dict = @{
                                   @"token": [YXUserManager sharedManager].userModel.token?:@"",
                                   @"uid": [YXUserManager sharedManager].userModel.uid?:@"",
                                   @"error": error?:@""};
            [YXDataStatisticsManger trackEvent:@"上传视频七牛" label:@"出错信息" parameters:dict];
        }
    } option:self.opt];
}
- (void)cancelUpload{
    self.isCancel = YES;
}
@end
