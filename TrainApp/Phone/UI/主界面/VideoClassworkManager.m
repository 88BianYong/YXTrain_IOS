//
//  VideoClassworkManager.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoClassworkManager.h"
#import "YXSubmitAnswerRequest.h"
@interface VideoClassworkManager ()
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, assign) NSInteger lastInteger;//返回上一章节的时间

@property (nonatomic, strong) YXVideoQuestionsRequest *questionsRequest;
@property (nonatomic, strong) YXSubmitAnswerRequest *answerRequest;
@property (nonatomic, strong) YXFileVideoClassworkItem *classworkItem;
@property (nonatomic, strong) NSMutableDictionary *questionsMutableDictionary;
@property (nonatomic, assign) BOOL isRequestFinish;
@property (nonatomic, assign) BOOL isAnswerTrue;

@property (nonatomic, strong) NSMutableArray<__kindof YXVideoQuestionsRequest *> *requestMutableArray;
@end
@implementation VideoClassworkManager
- (void)dealloc {
    [self.requestMutableArray removeAllObjects];
}
- (instancetype)initClassworkRootViewController:(UIViewController *)controller {
    if (self = [super initWithFrame:CGRectZero]) {
        if (controller == nil) {
            return self;
        }
        self.questionsMutableDictionary = [[NSMutableDictionary alloc] init];
        self.requestMutableArray = [[NSMutableArray alloc] init];
        self.rootViewController = controller;
        self.isRequestFinish = YES;
        self.quizzesInteger = 0;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initClassworkRootViewController:nil];
}
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initClassworkRootViewController:nil];
}
#pragma mark - setup UI
- (void)setupUI {
    self.clossworkView = [[VideoClassworkView alloc] init];
    self.clossworkView.hidden = YES;
    WEAK_SELF
    [self.clossworkView setVideoClassworkButtonActionBlock:^(VideoClassworkAnswerStatus status, NSArray * array) {
        STRONG_SELF
        switch (status) {
            case VideoClassworkAnswerStatus_Normal:
            {
                [self requestForSubmitAnswer:array];
            }
                break;
            case VideoClassworkAnswerStatus_Right:
            {
                self.classworkItem.isTrue = YES;
                BLOCK_EXEC(self.videoClassworkManagerBlock,YES,-1);
                self.clossworkView.hidden = YES;
            }
                break;
            case VideoClassworkAnswerStatus_Error:
            {
                self.clossworkView.hidden = YES;
                self.quizzesInteger += VideoClassworkQuizzesTime;
                BLOCK_EXEC(self.videoClassworkManagerBlock,YES,-1);
            }
                break;
            case VideoClassworkAnswerStatus_ForceError:
            {
                self.clossworkView.hidden = YES;
                self.quizzesInteger = self.lastInteger;
                BLOCK_EXEC(self.videoClassworkManagerBlock,YES,self.lastInteger);
            }
                break;
        }
    }];
    [self.rootViewController.view addSubview:self.clossworkView];
}
- (void)setupLayout {
  [self.clossworkView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.rootViewController.view);
  }];
}
- (void)compareClassworkPlayTime:(NSInteger)playProgress {
    __block BOOL isLastBool = YES;
    if ((playProgress >= self.quizzesInteger) && self.isRequestFinish) {
        [self.classworMutableArray enumerateObjectsUsingBlock:^(__kindof YXFileVideoClassworkItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!obj.isTrue && isLastBool) {
                if (idx > 0) {
                    YXFileVideoClassworkItem *item = self.classworMutableArray[idx - 1];
                    self.lastInteger = [item.timeString integerValue];
                }else {
                    self.lastInteger = 0;
                }
                isLastBool = NO;
            }
            if ([self comparisonTime:playProgress originalTime:[obj.timeString integerValue]] && !obj.isTrue) {
                self.quizzesInteger = [obj.timeString integerValue] - 5;
                self.classworkItem = obj;
                if (self.questionsMutableDictionary[obj.quizzesID]) {
                    [self showVideoClassworkView:self.questionsMutableDictionary[obj.quizzesID]];
                }else {
                    [self requestForVideoQuestion:obj.quizzesID];
                }
                return ;
            }
        }];
    }
}
- (BOOL)comparisonTime:(NSInteger)playTime originalTime:(NSInteger)contrastTime {
    return (playTime >= (contrastTime - VideoClassworkTriggerTime)) &&  (playTime <= (contrastTime + VideoClassworkTriggerTime));
}
- (void)showVideoClassworkView:(YXVideoQuestionsRequestItem *)item {
    YXVideoQuestionsRequestItem_Result_Questions *questions = item.result.questions[0];
    self.clossworkView.question = questions.question;
    [questions.question.answerJson enumerateObjectsUsingBlock:^(YXVideoQuestionsRequestItem_Result_Questions_Question_AnswerJson  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isChoose = @"0";
    }];
    [self.clossworkView.superview bringSubviewToFront:self.clossworkView];
    self.clossworkView.hidden = NO;
    BLOCK_EXEC(self.videoClassworkManagerBlock,NO,0);
}
#pragma mark - request
- (void)requestForVideoQuestion:(NSString *)quizzesID {
    self.isRequestFinish = NO;
    YXVideoQuestionsRequest *request = [[YXVideoQuestionsRequest alloc] init];
    request.qID = quizzesID;
    request.cID = self.cid;
    request.src = self.source;
    request.pID = [YXTrainManager sharedInstance].currentProject.pid;
    WEAK_SELF
    [request startRequestWithRetClass:[YXVideoQuestionsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        YXVideoQuestionsRequestItem *item = retItem;
        if (item.code.integerValue == 11) {
            self.classworkItem.isTrue = YES;
        }else if (!error && item.result.questions.count > 0) {
            self.questionsMutableDictionary[quizzesID] = item;
            [self showVideoClassworkView:item];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//TD:因为视频暂停后还会触发一次playTime监控所以延迟0.1秒 避免重复请求;
            self.isRequestFinish =YES;
        });
    }];
    self.questionsRequest = request;
}

- (void)requestForSubmitAnswer:(NSArray *)answerArray {
    NSArray *array = @[@{@"type":self.clossworkView.question.types?:@"",@"answer":answerArray,@"quid":self.classworkItem.quizzesID?:@""}];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    YXSubmitAnswerRequest *request = [[YXSubmitAnswerRequest alloc] init];
    request.qID = self.classworkItem.quizzesID;
    request.src = self.source;
    request.sm = @"1";
    request.aj = jsonString;
    request.cID = self.cid;
    request.pID = [YXTrainManager sharedInstance].currentProject.pid;
    [YXPromtController startLoadingInView:self.rootViewController.view];
    WEAK_SELF
    [request startRequestWithRetClass:[YXSubmitAnswerRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [YXPromtController stopLoadingInView:self.rootViewController.view];
        if (error) {
            if (error.code == 1){
                [YXPromtController showToast:error.localizedDescription inView:self.rootViewController.view];
            }else {
                [YXPromtController showToast:@"提交失败" inView:self.rootViewController.view];
            }
            return ;
        }
        YXSubmitAnswerRequestItem *item = retItem;
        if (item.isCorrect.boolValue){
            [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainSubmitQuestionAnswer object:nil];
        }
        self.isAnswerTrue = item.isCorrect.boolValue;
        [self.clossworkView refreshClassworkViewAnsewr:item.isCorrect.boolValue quizCorrect:self.forcequizcorrect];
    }];
    self.answerRequest = request;
}

- (void)startBatchRequestForVideoQuestions{
    [self.classworMutableArray enumerateObjectsUsingBlock:^(__kindof YXFileVideoClassworkItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXVideoQuestionsRequest *request = [[YXVideoQuestionsRequest alloc] init];
        request.qID = obj.quizzesID;
        request.cID = self.cid;
        request.src = self.source;
        request.pID = [YXTrainManager sharedInstance].currentProject.pid;
        WEAK_SELF
        [request startRequestWithRetClass:[YXVideoQuestionsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            YXVideoQuestionsRequestItem *item = retItem;
            if (item.code.integerValue == 11) {
                obj.isTrue = YES;
            }else if (!error && item.result.questions.count > 0) {
                self.questionsMutableDictionary[obj.quizzesID] = item;
            }
        }];
        [self.requestMutableArray addObject:request];
    }];
}

- (void)setClassworMutableArray:(NSMutableArray<__kindof YXFileVideoClassworkItem *> *)classworMutableArray {
    NSArray *sorte = [classworMutableArray sortedArrayUsingComparator:^NSComparisonResult(YXFileVideoClassworkItem *obj1, YXFileVideoClassworkItem *obj2) {
        if (obj1.timeString.integerValue < obj2.timeString.integerValue) {
            return(NSComparisonResult)NSOrderedAscending;
        }else {
            return(NSComparisonResult)NSOrderedDescending;
        }
        
    }];
    _classworMutableArray = [NSMutableArray arrayWithArray:sorte];
}
- (BOOL)isHidden {
    return self.clossworkView.hidden;
}
- (void)clear {
    [self.clossworkView removeFromSuperview];
}
@end
