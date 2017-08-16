//
//  YXCourseDetailPlayerViewController_17+Detection.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXCourseDetailPlayerViewController_17+Detection.h"

@implementation YXCourseDetailPlayerViewController_17 (Detection)
- (void)setupClassworkManager:(YXFileItemBase *)fileItem {
    //随堂练
    [self.classworkManager clear];
    self.classworkManager = nil;
    self.classworkManager = [[VideoClassworkManager alloc] initClassworkRootViewController:self.navigationController];
    self.classworkManager.classworkMutableArray = [self quizeesExercisesFormatSgqz:fileItem.sgqz];
    self.classworkManager.cid = fileItem.cid;
    self.classworkManager.source = fileItem.source;
    self.classworkManager.forcequizcorrect = fileItem.forcequizcorrect.boolValue;
    [self.classworkManager startBatchRequestForVideoQuestions];
    WEAK_SELF
    [self.classworkManager setVideoClassworkManagerBlock:^(BOOL isPlay, NSInteger playTime) {
        STRONG_SELF
        self.playMangerView.topView.alpha = isPlay ? 1.0f : 0.0f;
        self.playMangerView.bottomView.alpha = isPlay ? 1.0f : 0.0f;
        if (isPlay) {
            if (playTime >= 0) {
                [self.playMangerView.player seekTo:playTime];
            }
            self.playMangerView.pauseStatus = YXPlayerManagerPause_Not;
        }else {
            self.playMangerView.bottomView.slideProgressControl.bSliding = NO;
            [self.playMangerView.player pause];
            self.playMangerView.pauseStatus = YXPlayerManagerPause_Test;
        }
    }];
    self.classworkManager.clossworkView.isFullscreen = self.isFullscreen;
}
-(NSMutableArray<YXFileVideoClassworkItem *> *)quizeesExercisesFormatSgqz:(NSString *)sgqz {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSArray *quizees = [sgqz componentsSeparatedByString:@","];
    [quizees enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *temp = [obj componentsSeparatedByString:@"_"];
        if (temp.count == 2) {
            YXFileVideoClassworkItem *item = [[YXFileVideoClassworkItem alloc] init];
            item.quizzesID = temp[0];
            item.timeString = temp[1];
            item.isTrue = NO;
            [mutableArray addObject:item];
        }
    }];
    return mutableArray;
}
@end
