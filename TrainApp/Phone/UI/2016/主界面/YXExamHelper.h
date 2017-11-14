//
//  YXExamHelper.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/28.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXExamHelper : NSObject
+ (NSAttributedString *)toolCompleteStatusStringWithID:(NSString *)toolid finishNum:(NSString *)finishNum totalNum:(NSString *)totalNum;
@end
