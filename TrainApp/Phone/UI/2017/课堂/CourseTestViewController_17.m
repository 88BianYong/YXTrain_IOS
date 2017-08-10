//
//  CourseTestViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseTestViewController_17.h"
#import "CourseGetQuizesRequest_17.h"
#import "CourseTestCell_17.h"
#import "CourseTestHeaderView_17.h"
#import "CourseTestTableHeaderView_17.h"
#import "UITableView+TemplateLayoutHeaderView.h"
#import "CourseSubmitUserQuizesRequest_17.h"
#import "CourseTestNotPassTableHeaderView_17.h"
#import "CourseTestPassTableHeaderView_17.h"
typedef NS_ENUM(NSInteger,CourseTestSubmitStatus) {
    CourseTestSubmitStatus_NotSubmi = 0,//未作答
    CourseTestSubmitStatus_NotPass = 1,//未通过
    CourseTestSubmitStatus_Pass = 2,//通过
    CourseTestSubmitStatus_FullScore = 3//满分
};
@interface CourseTestViewController_17 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) CourseTestTableHeaderView_17 *headerView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) CourseTestNotPassTableHeaderView_17 *passStatusHeaderView;
@property (nonatomic, strong) CourseTestPassTableHeaderView_17 *fullScoreHeaderView;


@property (nonatomic, strong) CourseGetQuizesRequest_17 *quizesRequest;
@property (nonatomic, strong) CourseGetQuizesRequest_17Item *quizesItem;
@property (nonatomic, strong) CourseSubmitUserQuizesRequest_17 *submitUserQuizesRequest;
@property (nonatomic, strong) CourseSubmitUserQuizesRequest_17Item *submitItem;
@property (nonatomic, assign) CourseTestSubmitStatus submitStatus;
@end

@implementation CourseTestViewController_17
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForGetQuizes];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - set
- (void)setQuizesItem:(CourseGetQuizesRequest_17Item *)quizesItem{
    _quizesItem = quizesItem;
    [_quizesItem.result.questions enumerateObjectsUsingBlock:^(CourseGetQuizesRequest_17Item_Result_Questions *question, NSUInteger idx, BOOL * _Nonnull stop) {
        if (question.question.types.integerValue == 4) {//正确答案的no，判断题比较特殊，1=是(no=1) 0=否(no=2)
            [question.question.answerJson enumerateObjectsUsingBlock:^(CourseGetQuizesRequest_17Item_Result_Questions_Questions_AnswerJson *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.no.integerValue == 2) {
                    obj.no = @"0";
                }
            }];
        }
    }];
    self.headerView.result = _quizesItem.result;
    self.headerView.hidden = NO;
    self.tableView.tableFooterView.hidden = NO;
    [self.tableView reloadData];
}
- (void)setSubmitItem:(CourseSubmitUserQuizesRequest_17Item *)submitItem {
    _submitItem = submitItem;
    self.passStatusHeaderView.quizesItem = _submitItem;
}
- (CourseTestNotPassTableHeaderView_17 *)passStatusHeaderView {
    if (_passStatusHeaderView == nil) {
        _passStatusHeaderView = [[CourseTestNotPassTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 175)];
    }
    return _passStatusHeaderView;
}
- (CourseTestPassTableHeaderView_17 *)fullScoreHeaderView {
    if (_fullScoreHeaderView == nil) {
        _fullScoreHeaderView = [[CourseTestPassTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 145)];
    }
    return _fullScoreHeaderView;
}
- (void)setSubmitStatus:(CourseTestSubmitStatus)submitStatus {
    _submitStatus = submitStatus;
    if (_submitStatus == CourseTestSubmitStatus_NotSubmi) {
        [self.confirmButton setTitle:@"提交" forState:UIControlStateNormal];
    }else {
         [self.confirmButton setTitle:@"继续看课" forState:UIControlStateNormal];
    }
    if (_submitStatus == CourseTestSubmitStatus_Pass || _submitStatus == CourseTestSubmitStatus_FullScore) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainCompleteCourse object:nil userInfo:@{self.cID:YXTrainSpecialCourseActivity}];
    }
}
#pragma mark - setupUI
- (void)setupUI {
    self.navigationItem.title = @"课程测验";
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CourseTestHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"CourseTestHeaderView_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.tableView registerClass:[CourseTestCell_17 class] forCellReuseIdentifier:@"CourseTestCell_17"];
 
    self.headerView = [[CourseTestTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 71.0f)];
    self.headerView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 79.0f)];
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.hidden = YES;
    self.tableView.tableFooterView = footerView;
    
    self.confirmButton = [[UIButton alloc] init];
    self.confirmButton.layer.cornerRadius = YXTrainCornerRadii;
    self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"f3f7fa"].CGColor;
    self.confirmButton.layer.borderWidth = 1.0f;
    self.confirmButton.clipsToBounds = YES;
    [self.confirmButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
    
    [self.confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f3f7fa"]] forState:UIControlStateDisabled];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"]
                             forState:UIControlStateDisabled];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.confirmButton.enabled = NO;
    self.submitStatus = CourseTestSubmitStatus_NotSubmi;
    WEAK_SELF
    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.submitStatus == CourseTestSubmitStatus_NotSubmi) {
            NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
            [self.quizesItem.result.questions enumerateObjectsUsingBlock:^(CourseGetQuizesRequest_17Item_Result_Questions *question, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableArray *answerArray = [[NSMutableArray alloc] initWithCapacity:4];
                [question.question.answerJson enumerateObjectsUsingBlock:^(CourseGetQuizesRequest_17Item_Result_Questions_Questions_AnswerJson *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.isChoose.boolValue) {
                        [answerArray addObject:obj.no];
                    }
                }];
                NSDictionary *dictionary = @{@"type":question.question.types?:@"",@"answer":answerArray,@"id":question.question.qID?:@""};
                [mutableArray addObject:dictionary];
            }];
            [self requestForSubmitUserQuizes:mutableArray];
        }else {
            [self naviLeftAction];
        }
        
    }];
    [footerView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(25.0f);
        make.centerX.equalTo(footerView.mas_centerX);
        make.size.mas_offset(CGSizeMake(160.0f, 39.0f));
    }];
    self.errorView = [[YXErrorView alloc] init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForGetQuizes];
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self requestForGetQuizes];
    };
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)naviLeftAction {
    if (self.submitStatus == CourseTestSubmitStatus_NotSubmi) {
        __block BOOL isChoose = NO;
        [self.quizesItem.result.questions enumerateObjectsUsingBlock:^(CourseGetQuizesRequest_17Item_Result_Questions *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.question.userChoose.integerValue != 0) {
                isChoose = YES;
                *stop = YES;
            }
        }];
        if (isChoose) {
            LSTAlertView *alertView = [[LSTAlertView alloc] init];
            alertView.title = @"已作答的内容将被清除，确定退出?";
            alertView.imageName = @"提醒icon";
            WEAK_SELF
            [alertView addButtonWithTitle:@"取消" style:LSTAlertActionStyle_Cancel action:^{
                STRONG_SELF
                
            }];
            [alertView addButtonWithTitle:@"确定" style:LSTAlertActionStyle_Default action:^{
                STRONG_SELF
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertView show];
            return;
        }
    }
    if (self.submitStatus == CourseTestSubmitStatus_FullScore || self.submitStatus == CourseTestSubmitStatus_Pass) {
        BLOCK_EXEC(self.courseTestQuestionBlock,YES);
    }else {
        BLOCK_EXEC(self.courseTestQuestionBlock,NO);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.submitStatus == CourseTestSubmitStatus_FullScore) {
        return 0;
    }
    return self.quizesItem.result.questions.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CourseGetQuizesRequest_17Item_Result_Questions *question = self.quizesItem.result.questions[section];
    return question.question.answerJson.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseTestCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTestCell_17" forIndexPath:indexPath];
    CourseGetQuizesRequest_17Item_Result_Questions *question = self.quizesItem.result.questions[indexPath.section];
    cell.answer = question.question.answerJson[indexPath.row];
    if (![self isFirstChooseAnswer:indexPath.section] || !cell.answer.isChoose.boolValue) {
        cell.classworkStatus = CourseTestCellStatus_Normal;
    }else {
        CourseSubmitUserQuizesRequest_17Item_Data *data = self.submitItem.data[indexPath.section];
        cell.classworkStatus = data.isCorrect.boolValue ? CourseTestCellStatus_Right : CourseTestCellStatus_Error;
    }
    return cell;
}
- (BOOL)isFirstChooseAnswer:(NSInteger)integer {
    if (self.submitStatus == CourseTestSubmitStatus_NotSubmi || self.submitItem.data.count != self.quizesItem.result.questions.count) {
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    return [tableView fd_heightForCellWithIdentifier:@"CourseTestCell_17" configuration:^(CourseTestCell_17 *cell) {
         @strongify(self);
        CourseGetQuizesRequest_17Item_Result_Questions *question = self.quizesItem.result.questions[indexPath.section];
        cell.answer = question.question.answerJson[indexPath.row];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    @weakify(self);
    return [tableView yx_heightForHeaderWithIdentifier:@"CourseTestHeaderView_17" configuration:^(CourseTestHeaderView_17 *header) {
        @strongify(self);
        header.question = self.quizesItem.result.questions[section];
        header.numberInteger = section;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f/[UIScreen mainScreen].scale;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CourseTestHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CourseTestHeaderView_17"];
    headerView.question = self.quizesItem.result.questions[section];
    headerView.numberInteger = section;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self classworkChooseLogic:indexPath];
   
}
#pragma mark choose
- (void)classworkChooseLogic:(NSIndexPath *)indexPath {
    CourseGetQuizesRequest_17Item_Result_Questions *question = self.quizesItem.result.questions[indexPath.section];
    CourseGetQuizesRequest_17Item_Result_Questions_Questions_AnswerJson *answerJson = question.question.answerJson[indexPath.row];
    question.question.userChoose = @"0";
    if (question.question.types.integerValue == 2) {
        answerJson.isChoose = [NSString stringWithFormat:@"%d",![answerJson.isChoose boolValue]];
        __block BOOL isChoose = NO;
        [question.question.answerJson enumerateObjectsUsingBlock:^( CourseGetQuizesRequest_17Item_Result_Questions_Questions_AnswerJson *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isChoose.boolValue) {
                isChoose = YES;
                question.question.userChoose = @"1";
                *stop = YES;
            }
        }];
    }else {
        [question.question.answerJson enumerateObjectsUsingBlock:^(CourseGetQuizesRequest_17Item_Result_Questions_Questions_AnswerJson *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isChoose = @"0";
        }];
        answerJson.isChoose = @"1";
        question.question.userChoose = @"1";
    }
    __block BOOL isChoose = YES;
    [self.quizesItem.result.questions enumerateObjectsUsingBlock:^(CourseGetQuizesRequest_17Item_Result_Questions *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.question.userChoose.integerValue == 0) {
            isChoose = NO;
             *stop = YES;
        }
    }];
    if (isChoose) {
        self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;
        self.confirmButton.enabled = YES;
    }else {
        self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"f3f7fa"].CGColor;
        self.confirmButton.enabled = NO;
    }
    [self.tableView reloadData];
}
#pragma mark - request
- (void)requestForGetQuizes {
    CourseGetQuizesRequest_17 *request = [[CourseGetQuizesRequest_17 alloc] init];
    request.cid = self.cID;
    request.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.stageid = self.stageString;
    WEAK_SELF
    [request startRequestWithRetClass:[CourseGetQuizesRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        CourseGetQuizesRequest_17Item *item = retItem;
        self.quizesItem = item;
    }];
    self.quizesRequest = request;
}
- (void)requestForSubmitUserQuizes:(NSArray *)answerArray {
    CourseSubmitUserQuizesRequest_17 *request = [[CourseSubmitUserQuizesRequest_17 alloc] init];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:answerArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    request.aj = jsonString;
    request.cid = self.cID;
    request.stageid = self.stageString;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[CourseSubmitUserQuizesRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = YES;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        CourseSubmitUserQuizesRequest_17Item *item = retItem;
        if (item.correctNum.integerValue == item.totalNum.integerValue) {
            self.tableView.tableHeaderView = self.fullScoreHeaderView;
            self.submitStatus = CourseTestSubmitStatus_FullScore;
        }else {
            self.tableView.tableHeaderView = self.passStatusHeaderView;
            self.submitItem = item;
            self.submitStatus = item.isPass.boolValue ? CourseTestSubmitStatus_Pass :CourseTestSubmitStatus_NotPass;
            [self.tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
        }
        [self.tableView reloadData];
    }];
    self.submitUserQuizesRequest = request;
}

@end
