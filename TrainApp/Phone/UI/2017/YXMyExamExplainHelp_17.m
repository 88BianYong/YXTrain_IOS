//
//  YXMyExamExplainHelp_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXMyExamExplainHelp_17.h"

@implementation YXMyExamExplainHelp_17
- (NSString *)toolCompleteStatusExplain {
    NSString *lStr = nil;
    NSString *rStr = nil;
    if (self.toolID.integerValue == 201 || self.toolID.integerValue == 301 || self.toolID.integerValue == 215 || self.toolID.integerValue == 315 || self.toolID.integerValue == 217 || self.toolID.integerValue == 317) {
        lStr = [NSString stringWithFormat:@"已观看%@分钟",self.finishNum];
        rStr = [NSString stringWithFormat:@"观看%@分钟",self.totalNum];
    }else if (self.toolID.integerValue == 202 || self.toolID.integerValue == 302){
        lStr = [NSString stringWithFormat:@"已参加%@个",self.finishNum];
        rStr = [NSString stringWithFormat:@"参加%@个",self.totalNum];
    }else if (self.toolID.integerValue == 204 || self.toolID.integerValue == 304){
        lStr = [NSString stringWithFormat:@"已通过%@个",self.finishNum];
        rStr = [NSString stringWithFormat:@"通过%@个",self.totalNum];
    }else if (self.toolID.integerValue == 206 || self.toolID.integerValue == 306){
        lStr = [NSString stringWithFormat:@"已获得%@分",self.finishNum];
        rStr = [NSString stringWithFormat:@"获得%@分",self.totalNum];
    }else if (self.toolID.integerValue == 210 || self.toolID.integerValue == 310){
        lStr = [NSString stringWithFormat:@"已上传%@个",self.finishNum];
        rStr = [NSString stringWithFormat:@"上传%@个",self.totalNum];
    }else if (self.toolID.integerValue == 211 || self.toolID.integerValue == 311){
        lStr = [NSString stringWithFormat:@"已提问%@个",self.finishNum];
        rStr = [NSString stringWithFormat:@"提问%@个",self.totalNum];
    }else if (self.toolID.integerValue == 220 || self.toolID.integerValue == 320){
        lStr = [NSString stringWithFormat:@"已被点评%@篇",self.finishNum];
        rStr = [NSString stringWithFormat:@"被点评%@篇",self.totalNum];
    }else if (self.toolID.integerValue == 221 || self.toolID.integerValue == 321){
        lStr = [NSString stringWithFormat:@"已答对%@个",self.finishNum];
        rStr = [NSString stringWithFormat:@"答对%@个",self.totalNum];
    }else{
        lStr = [NSString stringWithFormat:@"已完成%@个",self.finishNum];
        rStr = [NSString stringWithFormat:@"完成%@个",self.totalNum];
    }
    
    NSString *completeStr = [NSString stringWithFormat:@"%@: 需要%@,总分%@, %@, 获得%@分",self.toolName,rStr,self.totalScore,lStr,self.finishScore];
    return completeStr;
}
@end
