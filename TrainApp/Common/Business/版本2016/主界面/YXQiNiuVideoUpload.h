//
//  YXQiNiuVideoUpload.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileHash.h"
@protocol YXQiNiuUploadDelegate;
@interface YXQiNiuVideoUpload : NSObject
@property (nonatomic, weak) id<YXQiNiuUploadDelegate> delegate;
- (id)initWithFileName:(NSString *)fileName qiNiuToken:(NSString *)qiNiuToken;
- (void)startUpload;
- (void)cancelUpload;
@end
@protocol YXQiNiuUploadDelegate <NSObject>

- (void)uploadProgress:(float)progress;

- (void)uploadCompleteWithHash:(NSString *)hashStr andVideoKey:(NSString *)keyString;

@end
