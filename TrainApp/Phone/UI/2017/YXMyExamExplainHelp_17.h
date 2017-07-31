//
//  YXMyExamExplainHelp_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXMyExamExplainHelp_17 : NSObject
@property (nonatomic, copy) NSString *toolName;
@property (nonatomic, copy) NSString *toolID;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *finishNum;
@property (nonatomic, copy) NSString *finishScore;
@property (nonatomic, copy) NSString *totalNum;
@property (nonatomic, copy) NSString *totalScore;
@property (nonatomic, copy) NSString *passTotalScore;
- (NSString *)toolCompleteStatusExplain;
@end
