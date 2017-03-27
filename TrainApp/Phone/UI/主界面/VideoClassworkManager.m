//
//  VideoClassworkManager.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoClassworkManager.h"
#import "VideoClassworkView.h"
#import "YXSubmitAnswerRequest.h"
@interface VideoClassworkManager ()
@property (nonatomic, strong) VideoClassworkView *clossworkView;
@property (nonatomic, weak) YXBaseViewController *rootViewController;
@property (nonatomic, assign) NSInteger quizzesInteger;
@property (nonatomic, assign) NSInteger lastInteger;
@property (nonatomic, strong) YXVideoQuestionsRequest *questionsRequest;
@property (nonatomic, strong) YXSubmitAnswerRequest *answerRequest;
@property (nonatomic, strong) YXFileVideoClassworkItem *classworkItem;
@property (nonatomic, assign) BOOL isRequestFinish;
@end
@implementation VideoClassworkManager
- (instancetype)initClassworkRootViewController:(YXBaseViewController *)controller {
    if (self = [super init]) {
        self.rootViewController = controller;
        self.isRequestFinish = YES;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setup UI
- (void)setupUI {
    self.clossworkView = [[VideoClassworkView alloc] init];
    self.clossworkView.hidden = YES;
    WEAK_SELF
    [self.clossworkView setVideoClassworkButtonActionBlock:^(VideoClassworkButtonStatus status, NSArray * array) {
        STRONG_SELF
        if (status == VideoClassworkButtonStatus_Confirm) {
            [self requestForSubmitAnswer:array];
        }else if (status == VideoClassworkButtonStatus_Back){
            BLOCK_EXEC(self.videoClassworkManagerBlock,YES,self.lastInteger);
            self.clossworkView.hidden = YES;
        }else {
            self.classworkItem.isTrue = YES;
            BLOCK_EXEC(self.videoClassworkManagerBlock,YES,-1);
            self.clossworkView.hidden = YES;
        }
        
    }];
    [self.rootViewController.view addSubview:self.clossworkView];
}
- (void)setupLayout {
  [self.clossworkView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.rootViewController.view);
  }];
}
- (void)showVideoClassworkView:(NSInteger)playProgress {
    if ((playProgress >= self.quizzesInteger) && self.isRequestFinish) {
        [self.classworMutableArray enumerateObjectsUsingBlock:^(__kindof YXFileVideoClassworkItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isTrue) {
                self.lastInteger = [obj.timeString integerValue];
            }
            if ([self comparisonTime:playProgress originalTime:[obj.timeString integerValue]] && !obj.isTrue) {
                self.quizzesInteger = [obj.timeString integerValue] - 5;
                self.classworkItem = obj;
                [self requestForVideoQuestions:obj.quizzesID];
                return ;
            }
        }];
    }
}
- (BOOL)comparisonTime:(NSInteger)playTime originalTime:(NSInteger)contrastTime {
    return (playTime >= (contrastTime - 5)) &&  (playTime <= (contrastTime + 5));
}
#pragma mark - request
- (void)requestForVideoQuestions:(NSString *)quizzesID {
    self.isRequestFinish = NO;
    YXVideoQuestionsRequest *request = [[YXVideoQuestionsRequest alloc] init];
    request.qID = quizzesID;
    request.cID = self.cid;
    request.pID = [YXTrainManager sharedInstance].currentProject.pid;
    WEAK_SELF
    [request startRequestWithRetClass:[YXVideoQuestionsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        YXVideoQuestionsRequestItem *item = retItem;
        if (!error && item.result.questions.count > 0) {
#warning quizzesID
            YXVideoQuestionsRequestItem_Result_Questions *questions = item.result.questions[quizzesID.integerValue];
            self.clossworkView.question = questions.question;
            self.clossworkView.hidden = NO;
            BLOCK_EXEC(self.videoClassworkManagerBlock,NO,0);
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
    [self.rootViewController startLoading];
    [request startRequestWithRetClass:[YXSubmitAnswerRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        [self.rootViewController stopLoading];
        if (error) {
            [self.rootViewController showToast:error.localizedDescription];
            return ;
        }
        YXSubmitAnswerRequestItem *item = retItem;
        [self.clossworkView refreshClassworkViewAnsewr:!item.isCorrect.boolValue quizCorrect:self.forcequizcorrect];
    }];
    self.answerRequest = request;
}
@end
