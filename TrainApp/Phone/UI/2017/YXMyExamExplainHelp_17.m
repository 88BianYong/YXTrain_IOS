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
    if (self.toolID.integerValue == 201) {
        if (self.type.integerValue == 0) {
            lStr = [NSString stringWithFormat:@"必修: 需要观看%@分钟,",self.totalNum];
            rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
        }else {
            lStr = [NSString stringWithFormat:@"必修: 需要观看%@门课程,",self.totalNum];
            rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
        }
    }else if (self.toolID.integerValue == 223){
        if (self.type.integerValue == 0) {
            lStr = [NSString stringWithFormat:@"选修: 需要观看%@分钟,",self.totalNum];
            rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
        }else {
            lStr = [NSString stringWithFormat:@"选修: 需要观看%@门课程,",self.totalNum];
            rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
        }
    }else if (self.toolID.integerValue == 301){
        if (self.type.integerValue == 0) {
            lStr = [NSString stringWithFormat:@"课程: 需要观看%@分钟,",self.totalNum];
            rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
        }else {
            lStr = [NSString stringWithFormat:@"课程: 需要观看%@门课程,",self.totalNum];
            rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
        }
    }else if (self.toolID.integerValue == 202 || self.toolID.integerValue == 302){
        if(self.totalScore.integerValue == 0 && self.finishScore.integerValue == 0) {
            lStr = @"无考核要求";
            rStr = @"";
        }else if (self.totalScore.integerValue == 0) {
            lStr = [NSString stringWithFormat:@"活动: 需要参加%@个,",self.totalNum];
            rStr = @"";
        }else {
            lStr = [NSString stringWithFormat:@"活动: 需要参加%@个,",self.totalNum];
            rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
        }
    }else if (self.toolID.integerValue == 103 || self.toolID.integerValue == 203 || self.toolID.integerValue == 303){
        lStr = [NSString stringWithFormat:@"作业: 需要完成%@篇,",self.totalNum];
        rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
    }else if (self.toolID.integerValue == 219){
        lStr = [NSString stringWithFormat:@"互评作业: 需要互评%@篇,",self.totalNum];
        rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
    }else if (self.toolID.integerValue == 216){
        lStr = [NSString stringWithFormat:@"小组作业: 需要完成%@篇,",self.totalNum];
        rStr = [NSString stringWithFormat:@"总分%@分\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t小组作业线下完成,由组长线上提交",self.totalScore];
    }else if (self.toolID.integerValue == 205){
        lStr = [NSString stringWithFormat:@"研修总结: 需要完成%@篇得%@分,",self.totalNum,self.totalScore];
        if(self.passTotalScore.floatValue > 0.0f) {
            rStr = [NSString stringWithFormat:@"\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t研修总结评分满分%@分",self.passTotalScore];
        }else {
            rStr = @"";
        }
    }else if (self.toolID.integerValue == 222 || self.toolID.integerValue == 322){
        lStr = [NSString stringWithFormat:@"阅读文本: 需要阅读%@篇,",self.totalNum];
        rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
    }else if (self.toolID.integerValue == 207){
        lStr = [NSString stringWithFormat:@"测评: 需要完成%@个,",self.totalNum];
        rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
    }else if (self.toolID.integerValue == 215 || self.toolID.integerValue == 315){
        lStr = [NSString stringWithFormat:@"选课中心: 需要完成%@个,",self.totalNum];
        rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
    }else if (self.toolID.integerValue == 217 || self.toolID.integerValue == 317){
        lStr = [NSString stringWithFormat:@"本地课程: 需要观看%@分钟,",self.totalNum];
        rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
    }else if (self.toolID.integerValue == 218){
        lStr = [NSString stringWithFormat:@"线下活动: 需要参加%@个得%@分",self.totalNum,self.totalScore];
        if(self.passTotalScore.floatValue > 0.0f) {
            rStr = [NSString stringWithFormat:@"\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t线下活动评分满分%@分",self.passTotalScore];
        }else {
            rStr = @"";
        }
    }else if (self.toolID.integerValue == 212 || self.toolID.integerValue == 312){
        lStr = [NSString stringWithFormat:@"作品集: 需要完成%@个得%@分",self.totalNum,self.totalScore];
        if(self.passTotalScore.floatValue > 0.0f) {
            rStr = [NSString stringWithFormat:@"\n\t\t\t\t\t\t\t\t\t\t\t\t 作品集评分满分%@分",self.passTotalScore];
        }else {
            rStr = @"";
        }
    }else if (self.toolID.integerValue == 208){
        lStr = [NSString stringWithFormat:@"自荐作业: 需要完成%@个得%@分",self.totalNum,self.totalScore];
        if(self.passTotalScore.floatValue > 0.0f) {
            rStr = [NSString stringWithFormat:@"\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t自荐作业评分满分%@分",self.passTotalScore];
        }else {
            rStr = @"";
        }
    }else if (self.toolID.integerValue == 220){
        lStr = [NSString stringWithFormat:@"作业质量: 我的作业被其他同学互评%@篇,",self.totalNum];
        rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
    }else if (self.toolID.integerValue == 306){
        lStr = [NSString stringWithFormat:@"综合评定: 综合评定评分满分%@分,",self.passTotalScore];
        rStr = @"";
    }else if (self.toolID.integerValue == 121212121212){
        lStr = [NSString stringWithFormat:@"在线考试: 需要完成%@个,",self.totalNum];
        rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
    }else{
        lStr = [NSString stringWithFormat:@"已完成%@个,",self.finishNum];
        rStr = [NSString stringWithFormat:@"完成%@个",self.totalNum];
    }
    NSString *completeStr = [NSString stringWithFormat:@"%@%@",lStr,rStr];
    return completeStr;
}
@end
