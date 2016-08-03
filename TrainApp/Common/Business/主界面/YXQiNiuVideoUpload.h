//
//  YXQiNiuVideoUpload.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXQiNiuVideoUpload : NSObject
- (id)initWithFileName:(NSString *)fileName qiNiuToken:(NSString *)qiNiuToken;
- (void)startUpload;
@end
