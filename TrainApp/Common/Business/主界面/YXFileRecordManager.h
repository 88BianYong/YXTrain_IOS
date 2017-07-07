//
//  YXFileRecordManager.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXFileRecordManager : NSObject
- (BOOL)hasRecordWithFilename:(NSString *)name url:(NSString *)url;
- (void)saveRecordWithFilename:(NSString *)name url:(NSString *)url;

@end
