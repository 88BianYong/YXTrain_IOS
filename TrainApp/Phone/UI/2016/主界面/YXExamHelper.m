//
//  YXExamHelper.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/28.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamHelper.h"

@implementation YXExamHelper
+ (NSAttributedString *)toolCompleteStatusStringWithID:(NSString *)toolid finishNum:(NSString *)finishNum totalNum:(NSString *)totalNum{
    NSString *lStr = nil;
    NSString *rStr = nil;
    if (toolid.integerValue == 201 || toolid.integerValue == 301 || toolid.integerValue == 215 || toolid.integerValue == 315 || toolid.integerValue == 217 || toolid.integerValue == 317) {
        lStr = [NSString stringWithFormat:@"已观看%@分钟",finishNum];
        rStr = [NSString stringWithFormat:@"／%@分钟",totalNum];
    }else if (toolid.integerValue == 202 || toolid.integerValue == 302){
        lStr = [NSString stringWithFormat:@"已参加%@个",finishNum];
        rStr = [NSString stringWithFormat:@"／%@个",totalNum];
    }else if (toolid.integerValue == 204 || toolid.integerValue == 304){
        lStr = [NSString stringWithFormat:@"已通过%@个",finishNum];
        rStr = [NSString stringWithFormat:@"／%@个",totalNum];
    }else if (toolid.integerValue == 206 || toolid.integerValue == 306){
        lStr = [NSString stringWithFormat:@"已获得%@分",finishNum];
        rStr = [NSString stringWithFormat:@"／%@分",totalNum];
    }else if (toolid.integerValue == 210 || toolid.integerValue == 310){
        lStr = [NSString stringWithFormat:@"已上传%@个",finishNum];
        rStr = [NSString stringWithFormat:@"／%@个",totalNum];
    }else if (toolid.integerValue == 211 || toolid.integerValue == 311){
        lStr = [NSString stringWithFormat:@"已提问%@个",finishNum];
        rStr = [NSString stringWithFormat:@"／%@个",totalNum];
    }else if (toolid.integerValue == 220 || toolid.integerValue == 320){
        lStr = [NSString stringWithFormat:@"已被点评%@篇",finishNum];
        rStr = [NSString stringWithFormat:@"／%@篇",totalNum];
    }else if (toolid.integerValue == 221 || toolid.integerValue == 321){
        lStr = [NSString stringWithFormat:@"已答对%@个",finishNum];
        rStr = [NSString stringWithFormat:@"／%@个",totalNum];
    }else{
        lStr = [NSString stringWithFormat:@"已完成%@个",finishNum];
        rStr = [NSString stringWithFormat:@"／%@个",totalNum];
    }
    NSString *completeStr = [NSString stringWithFormat:@"%@%@",lStr,rStr];
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc]initWithString:completeStr];
    NSRange range = [completeStr rangeOfString:rStr];
    [mStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"505f84"] range:range];
    return mStr;
}


@end
