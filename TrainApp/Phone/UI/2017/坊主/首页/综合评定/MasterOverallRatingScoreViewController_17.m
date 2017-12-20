//
//  MasterOverallRatingScoreViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOverallRatingScoreViewController_17.h"
#import "MasterOverallRatingScoreInputView_17.h"
#import "MasterOverallRatingScoreRequet_17.h"
@interface MasterOverallRatingScoreViewController_17 ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *segmentLabel;
@property (nonatomic, strong) UILabel *studyLabel;
@property (nonatomic, strong) UILabel *schooleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) MasterOverallRatingScoreInputView_17 *inputView;
@property (nonatomic, strong) MasterOverallRatingScoreRequet_17 *scoreRequest;

@end

@implementation MasterOverallRatingScoreViewController_17
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"综合评定";
    [self setupUI];
    [self setupLayout];
    [self addNotification];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"打分页面" withStatus:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"打分页面" withStatus:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}
#pragma mark - setupUI
- (void)setupUI {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.view addSubview:self.topView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.nameLabel.text = self.userScore.userName;
    [self.view addSubview:self.nameLabel];
    
    self.segmentLabel = [[UILabel alloc] init];
    self.segmentLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.segmentLabel.font = [UIFont systemFontOfSize:12.0f];
    self.segmentLabel.text = [NSString stringWithFormat:@"年级: %@",self.userScore.segmentName];
    [self.view addSubview:self.segmentLabel];
    
    self.studyLabel = [[UILabel alloc] init];
    self.studyLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.studyLabel.font = [UIFont systemFontOfSize:12.0f];
    self.studyLabel.text = [NSString stringWithFormat:@"科目: %@",self.userScore.studyName];
    [self.view addSubview:self.studyLabel];
    
    self.schooleLabel = [[UILabel alloc] init];
    self.schooleLabel.textColor = [UIColor colorWithHexString:@"334466"];
    self.schooleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.schooleLabel.textAlignment = NSTextAlignmentRight;
    self.schooleLabel.text = self.userScore.schoolName;
    [self.view addSubview:self.schooleLabel];
    
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.view addSubview:self.lineView];
    
    self.inputView = [[MasterOverallRatingScoreInputView_17 alloc] init];
    [self.view addSubview:self.inputView];
    
    [self setupScoreNavgationRightView];
    WEAK_SELF
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    [[recognizer rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *sender) {
        STRONG_SELF
        [self.inputView.textField resignFirstResponder];
    }];
    [self.view addGestureRecognizer:recognizer];
}
- (void)setupScoreNavgationRightView {
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"0070c9"] forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"] forState:UIControlStateDisabled];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.confirmButton.frame = CGRectMake(0, 0, 40.0f, 30.0f);
    self.confirmButton.enabled = NO;
    WEAK_SELF
    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self startLoading];
        [self requestForMasterOverallRatingScore];
    }];
    [self setupRightWithCustomView:self.confirmButton];
}
- (void)setupLayout {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_offset(5.0f);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15.0f);
        make.top.equalTo(self.topView.mas_bottom).offset(15.0f);
    }];
    
    [self.segmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15.0f);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(13.0f);
    }];
    [self.studyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentLabel.mas_right).offset(20.0f);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(13.0f);
    }];
    
    [self.schooleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15.0f);
        make.top.equalTo(self.view.mas_top).offset(5.0f);
        make.height.mas_offset(69.0f);
        make.width.mas_offset(kScreenWidth - 100.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15.0f);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.studyLabel.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(1.0f);
    }];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_offset(45.0f);
    }];
}
- (void)addNotification {
    @weakify(self);
    RACSignal *scoreSignal =
    [self.inputView.textField.rac_textSignal
     map:^id(NSString *text) {
         @strongify(self);
         return @([self isTitleLength:text]);
     }];
    RACSignal *activeSignal =
    [RACSignal combineLatest:@[scoreSignal]
                      reduce:^id(NSNumber *titleValid) {
                          return @([titleValid boolValue]);
                      }];
    [activeSignal subscribeNext:^(NSNumber *signupActive) {
        STRONG_SELF
        self.confirmButton.enabled = [signupActive boolValue];
    }];
}

- (BOOL)isTitleLength:(NSString *)contentString {
    return (contentString.length > 0 && contentString.length <= 3 && contentString.integerValue >= 0 && contentString.integerValue <= 100) ? YES : NO;
}
#pragma mark - request
- (void)requestForMasterOverallRatingScore {
    MasterOverallRatingScoreRequet_17 *request = [[MasterOverallRatingScoreRequet_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.userId = self.userScore.userId;
    request.score = self.inputView.textField.text;
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
        }else {
            self.userScore.score = self.inputView.textField.text;
            BLOCK_EXEC(self.masterOverallRatingScoreBlock);
            self.inputView.textField.text = nil;
            [self.inputView.textField resignFirstResponder];
            [self showToast:@"打分成功"];
        }
    }];
    self.scoreRequest = request;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
