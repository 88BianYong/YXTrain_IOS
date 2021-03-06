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
//    help.toolName ==> obj.name;
//    help.toolID ==>obj.toolID;
//    help.type ==> obj.type;
//    help.finishNum ==> obj.finishNum;
//    help.finishScore ==> obj.passFinishScore;
//    help.totalNum ==> obj.totalNum;
//    help.totalScore ==> obj.totalScore;
//    help.passTotalScore ==> obj.passTotalScore;
//    help.passScore ==> obj.passScore;
//    help.isExamPass ==> self.examine.isExamPass;
//    help.isShowChoose ==> self.isShowChoose;

    
//    if (process.toolExamineVoList.count > tagInteger) {
//        ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList *voList = process.toolExamineVoList[tagInteger];
//        [voList.toolExamineVoList enumerateObjectsUsingBlock:^(ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ((obj.toolID.integerValue == 223) || (obj.toolID.integerValue == 201 && obj.type.integerValue == 1)) {
//                isShowChoose = YES;
//                *stop = YES;
//            }
//        }];
//    }
    
    if(self.totalScore.integerValue == 0 && self.passTotalScore.integerValue == 0 && self.totalNum.integerValue == 0) {
        lStr = @"";
        rStr = @"";
    }else if (self.toolID.integerValue == 201) {
        if (self.type.integerValue == 0) {
            lStr = [NSString stringWithFormat:@"必修: 需要观看%@分钟",self.totalNum];
            rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
            if (self.totalScore.integerValue == 0) {
                rStr = @"";
            }
        }else {
            lStr = [NSString stringWithFormat:@"必修: 需要观看%@门课程",self.totalNum];
            rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
            if (self.totalScore.integerValue == 0) {
                rStr = @"";
            }
        }
        if (!self.isShowChoose) {
            lStr = [NSString stringWithFormat:@"观看课程: 需要观看%@分钟",self.totalNum];
            rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
            if (self.totalScore.integerValue == 0) {
                rStr = @"";
            }
        }
    }else if (self.toolID.integerValue == 223){
        if (self.type.integerValue == 0) {
            lStr = [NSString stringWithFormat:@"选修: 需要观看%@分钟",self.totalNum];
            rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
            if (self.totalScore.integerValue == 0) {
                rStr = @"";
            }
        }else {
            lStr = [NSString stringWithFormat:@"选修: 需要观看%@门课程",self.totalNum];
            rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
            if (self.totalScore.integerValue == 0) {
                rStr = @"";
            }
        }
        if (!self.isShowChoose) {
            lStr = [NSString stringWithFormat:@"观看课程: 需要观看%@分钟",self.totalNum];
            rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
            if (self.totalScore.integerValue == 0) {
                rStr = @"";
            }
        }
    }else if (self.toolID.integerValue == 202 || self.toolID.integerValue == 302){
            lStr = [NSString stringWithFormat:@"活动: 需要参加%@个",self.totalNum];
            rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
        if (self.totalScore.integerValue == 0) {
            rStr = @"";
        }
    }else if (self.toolID.integerValue == 103 || self.toolID.integerValue == 203 || self.toolID.integerValue == 303){
        lStr = [NSString stringWithFormat:@"作业: 需要完成%@篇",self.totalNum];
        rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
        if (self.totalScore.integerValue == 0) {
            rStr = @"";
        }
    }else if (self.toolID.integerValue == 219){
        lStr = [NSString stringWithFormat:@"互评作业: 需要互评%@篇",self.totalNum];
        rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
        if (self.totalScore.integerValue == 0) {
            rStr = @"";
        }
    }else if (self.toolID.integerValue == 216){
        lStr = [NSString stringWithFormat:@"小组作业: 需要完成%@篇,",self.totalNum];
        rStr = [NSString stringWithFormat:@"总分%@分\n小组作业线下完成,由组长线上提交",self.totalScore];
    }else if (self.toolID.integerValue == 205){
        lStr = [NSString stringWithFormat:@"研修总结: 需要完成%@篇得%@分,",self.totalNum,self.totalScore];
         rStr = [NSString stringWithFormat:@"\n研修总结评分大于%@分后,按比例得分,满分%@分",self.passScore,self.passTotalScore];
    }else if (self.toolID.integerValue == 222 || self.toolID.integerValue == 322){
        lStr = [NSString stringWithFormat:@"任务说明: 需要阅读%@篇",self.totalNum];
        rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
        if (self.totalScore.integerValue == 0) {
            rStr = @"";
        }
    }else if (self.toolID.integerValue == 207){
        lStr = [NSString stringWithFormat:@"测评: 需要完成%@个",self.totalNum];
        rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
        if (self.totalScore.integerValue == 0) {
            rStr = @"";
        }
    }else if (self.toolID.integerValue == 215 || self.toolID.integerValue == 315){
        if (self.type.integerValue == 0) {
            lStr = [NSString stringWithFormat:@"选课中心: 需要观看%@分钟",self.totalNum];
            rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
            if (self.totalScore.integerValue == 0) {
                rStr = @"";
            }
        }else {
            lStr = [NSString stringWithFormat:@"选课中心: 需要观看%@门课程",self.totalNum];
            rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
            if (self.totalScore.integerValue == 0) {
                rStr = @"";
            }
        }
    }else if (self.toolID.integerValue == 217 || self.toolID.integerValue == 317){
        if (self.type.integerValue == 0) {
            lStr = [NSString stringWithFormat:@"本地课程: 需要观看%@分钟",self.totalNum];
            rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
            if (self.totalScore.integerValue == 0) {
                rStr = @"";
            }
        }else {
            lStr = [NSString stringWithFormat:@"本地课程: 需要观看%@门课程",self.totalNum];
            rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
            if (self.totalScore.integerValue == 0) {
                rStr = @"";
            }
        }
    }else if (self.toolID.integerValue == 218){
        lStr = [NSString stringWithFormat:@"线下活动: 需要参加%@个得%@分",self.totalNum,self.totalScore];
             rStr = [NSString stringWithFormat:@"\n线下活动达到%@分后,按比例得分,满分%@分",self.passScore,self.passTotalScore];
    }else if (self.toolID.integerValue == 212 || self.toolID.integerValue == 312){
        lStr = [NSString stringWithFormat:@"作品集: 需要完成%@个得%@分",self.totalNum,self.totalScore];
        rStr = [NSString stringWithFormat:@"\n作品集达到%@分后,按比例得分,满分%@分",self.passScore,self.passTotalScore];
    }else if (self.toolID.integerValue == 208){
        lStr = [NSString stringWithFormat:@"自荐作业: 需要完成%@个得%@分",self.totalNum,self.totalScore];
        rStr = [NSString stringWithFormat:@"\n自荐作业评分达到%@分后按比例得分,满分%@分",self.passScore,self.passTotalScore];
    }else if (self.toolID.integerValue == 220){
        lStr = [NSString stringWithFormat:@"作业质量: 我的作业被其他同学互评%@篇",self.totalNum];
        rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
        if (self.totalScore.integerValue == 0) {
            rStr = @"";
        }
    }else if (self.toolID.integerValue == 306 || self.toolID.integerValue == 206){
        lStr = [NSString stringWithFormat:@"综合评定: 综合评定评分满分%@分",self.passTotalScore];
        rStr = @"";
    }else if (self.toolID.integerValue == 204){
        lStr = [NSString stringWithFormat:@"在线考试: 需要通过%@个,",self.totalNum];
        if (self.isExamPass.integerValue == -1) {
            rStr = [NSString stringWithFormat:@"总分%@分",self.totalScore];
        }else if (self.isExamPass.integerValue == 0){
            rStr = [NSString stringWithFormat:@"总分%@分\n在线考试最终考核结果未合格",self.totalScore];
        }else if (self.isExamPass.integerValue == 1){
            rStr = [NSString stringWithFormat:@"总分%@分\n在线考试最终考核结果未合格",self.totalScore];
        }else {
            rStr = [NSString stringWithFormat:@"总分%@分\n在线考试最终考核结果合格",self.totalScore];
        }
    }else if (self.toolID.integerValue == 309 || self.toolID.integerValue == 209){
        lStr = [NSString stringWithFormat:@"日志: 需要完成%@篇",self.totalNum];
        rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
        if (self.totalScore.integerValue == 0) {
            rStr = @"";
        }
    }else if (self.toolID.integerValue == 310 || self.toolID.integerValue == 210){
        lStr = [NSString stringWithFormat:@"资源: 需要上传%@个",self.totalNum];
        rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
        if (self.totalScore.integerValue == 0) {
            rStr = @"";
        }
    }else if (self.toolID.integerValue == 211 || self.toolID.integerValue == 311){
        lStr = [NSString stringWithFormat:@"问答: 需要回答%@个提问",self.totalNum];
        rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
        if (self.totalScore.integerValue == 0) {
            rStr = @"";
        }
    }else if (self.toolID.integerValue == 221 || self.toolID.integerValue == 321){
        lStr = [NSString stringWithFormat:@"随堂练: 需要答对%@个",self.totalNum];
        rStr = [NSString stringWithFormat:@",总分%@分",self.totalScore];
        if (self.totalScore.integerValue == 0) {
            rStr = @"";
        }
    }else{
        lStr = [NSString stringWithFormat:@"%@: 需要完成%@个",self.toolName,self.totalNum];
        rStr = [NSString stringWithFormat:@",总分%@个",self.totalScore];
        if (self.totalScore.integerValue == 0) {
            rStr = @"";
        }
    }
    NSString *completeStr = [NSString stringWithFormat:@"%@%@",lStr,rStr];
    return completeStr;
}
//\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t
@end
