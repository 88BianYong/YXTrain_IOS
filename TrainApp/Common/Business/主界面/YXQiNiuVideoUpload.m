//
//  YXQiNiuVideoUpload.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
#import "YXQiNiuVideoUpload.h"
#import "FileHash.h"

@interface YXQiNiuVideoUpload()
@property (nonatomic, copy) NSString *fileCachePath;//最终文件路径为fileCachePath／key
@property (nonatomic, strong) QNFileRecorder *fileRecorder;
@property (nonatomic, strong) QNUploadManager *upManager;
@property (nonatomic, strong) QNUploadOption *opt;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *qiNiuToken;
@property (nonatomic, copy) NSString *keyName;


@end
@implementation YXQiNiuVideoUpload
- (id)initWithFileName:(NSString *)fileName qiNiuToken:(NSString *)qiNiuToken{
    self = [super init];
    if (self) {
        NSError *error = nil;
        self.fileCachePath = PATH_OF_VIDEO_CACHE ;
        self.fileRecorder = [QNFileRecorder fileRecorderWithFolder:self.fileCachePath error:&error];
        NSLog(@"recorder error %@", error);
        self.filePath = [PATH_OF_VIDEO stringByAppendingPathComponent:fileName];
        self.qiNiuToken = qiNiuToken;
        self.keyName = [NSString stringWithFormat:@"%@.mp4",[FileHash md5HashOfFileAtPath:[PATH_OF_VIDEO stringByAppendingPathComponent:fileName]]];
        
        self.upManager = [[QNUploadManager alloc] initWithRecorder:self.fileRecorder
                          ];
        self.opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
            NSLog(@"<<<<<<%@",key);
            
        } params:nil checkCrc:NO cancellationSignal:^BOOL{
            return NO;
        }];
    }
    return self;
}
- (void)startUpload{
    NSString *keyUp = self.keyName;
    __block NSString *key = nil;
    __block QNResponseInfo *info = nil;
    [_upManager putFile: self.filePath key:keyUp token:self.qiNiuToken   complete: ^(QNResponseInfo *i, NSString *k, NSDictionary *resp) {
        key = k;
        info = i;
        NSLog(@">>>%@=====%@",i,k);
//        if(self.isDiscard && self.isCancel) {
//            [QNFileRecorder removeKey:self.keyName directory:self.fileCachePath encodeKey:NO];
//        }
//        if (i.statusCode == 200) {
//            if ([self.delegate respondsToSelector:@selector(uploadCompleteWithHash:)]) {
//                [self.delegate uploadCompleteWithHash:[resp objectForKey:@"hash"]];
//            }
//        } else if (i.statusCode == 614) {
//            if ([self.delegate respondsToSelector:@selector(uploadCompleteWithHash:)]) {
//                [self.delegate uploadCompleteWithHash:nil];
//            }
//        }
        //        if (i.statusCode == -999||i.statusCode == -2) {
        //            if ([self.delegate respondsToSelector:@selector(susuPendUploadWithProgress:)]) {
        //                [self.delegate susuPendUploadWithProgress:self.percent];
        //            }
        //        }
    } option:self.opt];
}
@end
