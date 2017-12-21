//
//  MasterHomeworkSetListDetailViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkSetListDetailViewController_17.h"
#import "MasterHomeworkSetListDetailRequest_17.h"
#import "MasterHomeworkSetChooseView_17.h"
#import "MasterHomeworkSetDetailViewController_17.h"
#import "MasterHomeworkSetScrollView_17.h"
#import "MasterHomeworkSetCancelRecommendRequest_17.h"
#import "MasterHomeworkSetRecommendRequest_17.h"
#import "MasterHomeworkSetScoreRequest_17.h"
#import "MasterInputView_17.h"
@interface MasterHomeworkSetListDetailViewController_17 ()<UIScrollViewDelegate>
@property (nonatomic, strong) MasterHomeworkSetListDetailRequest_17 *detailRequest;
@property (nonatomic, strong) MasterHomeworkSetListDetailItem_Body *detailItem;
@property (nonatomic, strong) MasterHomeworkSetRecommendRequest_17 *recommendRequest;
@property (nonatomic, strong) MasterHomeworkSetCancelRecommendRequest_17 *cancleRequest;
@property (nonatomic, strong) MasterHomeworkSetScoreRequest_17 *scoreHomework;

@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UIImageView *recommendImageView;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) MasterHomeworkSetChooseView_17 *chooseView;
@property (nonatomic, strong) MasterHomeworkSetScrollView_17 *scrollView;

@property (nonatomic, strong) MasterInputView_17 *inputView;
@property (nonatomic, strong) UIView *translucentView;
@property (nonatomic, strong) YXEmptyView *supportView;


@property (nonatomic, strong) UIButton *remarkButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) NSInteger chooseIndex;
@property (nonatomic, assign) BOOL isButtonHidden;

@end

@implementation MasterHomeworkSetListDetailViewController_17
- (void)dealloc {
    DDLogDebug(@"release=====>%@",NSStringFromClass([self class]));
    [self.inputView removeFromSuperview];
    self.inputView = nil;
    [self.translucentView removeFromSuperview];
    self.translucentView = nil;
}
#pragma mark - set
- (void)setIsButtonHidden:(BOOL)isButtonHidden {
    _isButtonHidden = isButtonHidden;
    self.remarkButton.hidden = _isButtonHidden;
    self.commentButton.hidden = _isButtonHidden;
    self.lineView.hidden = _isButtonHidden;
}
- (void)setDetailItem:(MasterHomeworkSetListDetailItem_Body *)detailItem {
    _detailItem = detailItem;
    self.bgView.hidden = NO;
    if (!_detailItem.supportTemplate.boolValue) {
        self.supportView.hidden = NO;
        return;
    }
    self.isButtonHidden = NO;
    [self reloadContentView];
    self.chooseView.homeworkArray = _detailItem.homeworks;
    [_detailItem.homeworks enumerateObjectsUsingBlock:^(MasterHomeworkSetListDetailItem_Body_Homework *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MasterHomeworkSetDetailViewController_17 *VC = [[MasterHomeworkSetDetailViewController_17 alloc] init];
        VC.homeworkId = obj.homeworkId;
        VC.homeworkSetId = self.detailItem.homeworkSetId;
        VC.isSupportBool = obj.supportTemplate.boolValue;
        VC.tagInteger = idx + 10086;
        [self addChildViewController:VC];
        [self.scrollView addSubview:VC.view];
        [VC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.mas_left).offset(kScreenWidth * idx);
            make.top.equalTo(self.scrollView.mas_top);
            make.bottom.equalTo(self.view.mas_bottom).offset(-50.0f);
            make.width.mas_offset(kScreenWidth);
        }];
    }];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * _detailItem.homeworks.count, 100.0f);
}
- (void)setChooseIndex:(NSInteger)chooseIndex {
    if (_chooseIndex == chooseIndex) {
        return;
    }
    _chooseIndex = chooseIndex;
    MasterHomeworkSetDetailViewController_17 *VC = self.childViewControllers[_chooseIndex];
    [VC reloadMasterHomeworkSetRemark];
    self.isButtonHidden = !VC.isSupportBool;
}
- (void)reloadContentView {
    self.scoreLabel.hidden = NO;
    self.firstLineView.hidden = NO;
    self.secondLineView.hidden = NO;
    self.chooseView.hidden = NO;
    if (_detailItem.score.integerValue > 0) {
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
        self.scoreLabel.text = [NSString stringWithFormat:@"%@分",_detailItem.score];
    }else {
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"334466"];
        self.scoreLabel.text = @"未批阅";
    }
    self.recommendImageView.hidden = !_detailItem.isRecommend.boolValue;
    if (_detailItem.isMyRecommend.boolValue) {
        [self.remarkButton setTitle:@"取消推优" forState:UIControlStateNormal];
    }else {
        [self.remarkButton setTitle:@"推优" forState:UIControlStateNormal];
    }
    if (_detailItem.myScore.integerValue > 0) {
        [self.commentButton setTitle:@"再次点评" forState:UIControlStateNormal];
    }else {
        [self.commentButton setTitle:@"点评" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.navigationItem.title = self.titleString;
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForHomeworkSetListDetail];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    [YXDataStatisticsManger trackPage:@"作品集详情" withStatus:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
    [YXDataStatisticsManger trackPage:@"作品集详情" withStatus:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.hidden = YES;
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(100.0f);
        make.top.equalTo(self.view.mas_top);
    }];
    
    
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.scoreLabel.hidden = YES;
    [self.view addSubview:self.scoreLabel];
    
    self.recommendImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"优标签"]];
    self.recommendImageView.hidden = YES;
    [self.view addSubview:self.recommendImageView];
    
    self.firstLineView = [[UIView alloc] init];
    self.firstLineView.hidden = YES;
    self.firstLineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.view addSubview:self.firstLineView];
    
    self.secondLineView = [[UIView alloc] init];
    self.secondLineView.hidden = YES;
    self.secondLineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.view addSubview:self.secondLineView];
    
    self.chooseView = [[MasterHomeworkSetChooseView_17 alloc]initWithFrame:CGRectMake(15, 45, kScreenWidth - 30.0f, 45)];
    self.chooseView.layer.cornerRadius = YXTrainCornerRadii;
    self.chooseView.hidden = YES;
    WEAK_SELF
    self.chooseView.masterHomeworkSetChooseBlock = ^(NSInteger integer) {
        STRONG_SELF
        [self.scrollView setContentOffset:CGPointMake(integer * kScreenWidth, 0) animated:NO];
        self.chooseIndex = integer;
    };
    [self.view addSubview:self.chooseView];
    self.scrollView = [[MasterHomeworkSetScrollView_17 alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.errorView = [[YXErrorView alloc] init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForHomeworkSetListDetail];
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForHomeworkSetListDetail];
    };
    [self setupBottomView];
    [self setupInputView];
    self.supportView = [[YXEmptyView alloc] init];
    self.supportView.title = @"作业类型暂不支持,请通过电脑查看";
    self.supportView.imageName = @"无内容";
    self.supportView.hidden = YES;
    [self.view addSubview:self.supportView];
}
- (void)setupBottomView {
    self.remarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.remarkButton setTitle:@"推优" forState:UIControlStateNormal];
    [self.remarkButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
    [self.remarkButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateNormal];
    [self.remarkButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]] forState:UIControlStateHighlighted];
    self.remarkButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    WEAK_SELF
    [[self.remarkButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.detailItem.isMyRecommend.boolValue) {
            [self showAlertCancleRemark];
        }else {
            [UIView animateWithDuration:0.25 animations:^{
                self.translucentView.alpha = 1.0f;
            }];
            self.inputView.inputStatus = MasterInputStatus_Recommend;
        }
    }];
    [self.view addSubview:self.remarkButton];
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentButton setTitle:@"点评" forState:UIControlStateNormal];
    [self.commentButton setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
    [self.commentButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateNormal];
    [self.commentButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]] forState:UIControlStateHighlighted];
    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [[self.commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [UIView animateWithDuration:0.25 animations:^{
            self.translucentView.alpha = 1.0f;
        }];
        self.inputView.placeholderScoreString = @"60";
        if (self.detailItem.myScore.integerValue > 0) {
            self.inputView.placeholderScoreString = self.detailItem.score;
        }
        self.inputView.minScoreString = self.detailItem.myScore;
        self.inputView.inputStatus = MasterInputStatus_Score;
    }];
    [self.view addSubview:self.commentButton];
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49.0f);
        make.height.mas_equalTo(1.0f);
    }];
    
    [self.remarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width).multipliedBy(1.0f/2.0f);
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.width.equalTo(self.view.mas_width).multipliedBy(1.0f/2.0f);
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.isButtonHidden = YES;
}
- (void)showAlertCancleRemark{
    LSTAlertView *alertView = [[LSTAlertView alloc]init];
    alertView.title = @"确认取消推优吗?";
    alertView.imageName = @"失败icon";
    WEAK_SELF
    [alertView addButtonWithTitle:@"取消" style:LSTAlertActionStyle_Cancel action:^{
        STRONG_SELF
        
    }];
    [alertView addButtonWithTitle:@"确认" style:LSTAlertActionStyle_Default action:^{
        STRONG_SELF
        [UIView animateWithDuration:0.25 animations:^{
            self.translucentView.alpha = 1.0f;
        }];
        self.inputView.inputStatus = MasterInputStatus_Cancle;
    }];
    [alertView show];
}
- (void)setupInputView{
    self.translucentView = [[UIView alloc] init];
    self.translucentView.alpha = 0.0f;
    self.translucentView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self.navigationController.view addSubview:self.translucentView];
    [self.translucentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    WEAK_SELF
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    [[recognizer rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *sender) {
        STRONG_SELF
        CGPoint point = [sender locationInView:self.translucentView];
        if (sender.state == UIGestureRecognizerStateEnded &&
            !CGRectContainsPoint(self.inputView.frame,point)) {
            [self hiddenInputView];
        }
    }];
    [self.translucentView addGestureRecognizer:recognizer];
    self.inputView = [[MasterInputView_17 alloc] initWithFrame:CGRectZero];
    self.inputView.masterInputViewBlock = ^(MasterInputStatus status) {
        STRONG_SELF
        if (status == MasterInputStatus_Cancle) {
            [self requestForCancelRecommendHomework:self.inputView.commentTextView.text];
        }else if (status == MasterInputStatus_Recommend) {
            [self requestForRecommendHomework:self.inputView.commentTextView.text];
        }else if (status == MasterInputStatus_Comment) {
            if (self.inputView.scoreTextView.text.integerValue <= self.detailItem.score.integerValue) {
            }else {
                [self requestForScoreHomework:self.inputView.commentTextView.text withScore:self.inputView.scoreTextView.text];
            }
        }
        [self hiddenInputView];
    };
    [self.navigationController.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationController.view.mas_left);
        make.right.equalTo(self.navigationController.view.mas_right);
        make.bottom.mas_equalTo(105.0f);
    }];
}
- (void)hiddenInputView {
    [self.inputView.scoreTextView resignFirstResponder];
    [self.inputView.commentTextView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.translucentView.alpha = 0.0f;
    }];
}
- (void)setupLayout {
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15.0f);
        make.height.mas_offset(44.0f);
        make.top.equalTo(self.view.mas_top);
    }];
    
    [self.recommendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scoreLabel.mas_right).offset(10.0f);
        make.centerY.equalTo(self.scoreLabel.mas_centerY);
    }];
    
    [self.firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(1.0f);
        make.top.equalTo(self.scoreLabel.mas_bottom);
    }];
    
    [self.secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(1.0f);
        make.top.equalTo(self.firstLineView.mas_bottom).offset(45.0f);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.secondLineView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.supportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - request
- (void)requestForHomeworkSetListDetail {
    MasterHomeworkSetListDetailRequest_17 *request = [[MasterHomeworkSetListDetailRequest_17  alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.homeworkSetId = self.homeworkSetId;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterHomeworkSetListDetailItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        self.detailItem = ((MasterHomeworkSetListDetailItem *)retItem).body;
    }];
    self.detailRequest = request;
}
- (void)requestForRecommendHomework:(NSString *)content {
    MasterHomeworkSetRecommendRequest_17 *request = [[MasterHomeworkSetRecommendRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.homeworkSetId = self.homeworkSetId;
    request.content = content;
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self showToast:error.localizedDescription];
        }else {
            self.detailItem.isMyRecommend = @"1";
            self.detailItem.isRecommend = @"1";
            [self.inputView clearContent:MasterInputStatus_Recommend];
            MasterHomeworkSetDetailViewController_17 *VC = self.childViewControllers[self.chooseIndex];
            [VC reloadMasterHomeworkSetRemark];
            BLOCK_EXEC(self.masterHomeworkSetRecommendBlock,YES);
            [self.remarkButton setTitle:@"取消推优" forState:UIControlStateNormal];
        }
    }];
    self.recommendRequest = request;
}
- (void)requestForCancelRecommendHomework:(NSString *)content {
    MasterHomeworkSetCancelRecommendRequest_17 *request = [[MasterHomeworkSetCancelRecommendRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.homeworkSetId = self.homeworkSetId;
    request.content = content;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterHomeworkSetCancelRecommendItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self showToast:error.localizedDescription];
        }else {
            MasterHomeworkSetCancelRecommendItem *item = retItem;
            self.detailItem.isMyRecommend = @"0";
            self.detailItem.isRecommend = item.body.isRecommend;
            [self reloadContentView];
            [self.inputView clearContent:MasterInputStatus_Cancle];
            MasterHomeworkSetDetailViewController_17 *VC = self.childViewControllers[self.chooseIndex];
            [VC reloadMasterHomeworkSetRemark];
            [self.remarkButton setTitle:@"推优" forState:UIControlStateNormal];
            BLOCK_EXEC(self.masterHomeworkSetRecommendBlock,self.detailItem.isRecommend.boolValue);
        }
    }];
    self.cancleRequest = request;
}
- (void)requestForScoreHomework:(NSString *)content withScore:(NSString *)score {
    MasterHomeworkSetScoreRequest_17 *request = [[MasterHomeworkSetScoreRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.homeworkSetId = self.homeworkSetId;
    request.content = content;
    request.score = score;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterHomeworkSetScoreItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self showToast:error.localizedDescription];
        }else {
            MasterHomeworkSetScoreItem *item = retItem;
            self.detailItem.score = item.body.hwscore;
            self.detailItem.myScore = item.body.myscore;
            [self reloadContentView];
            [self.inputView clearContent:MasterInputStatus_Comment];
            MasterHomeworkSetDetailViewController_17 *VC = self.childViewControllers[self.chooseIndex];
            [VC reloadMasterHomeworkSetRemark];
            BLOCK_EXEC(self.masterHomeworkSetCommendBlock);
            [self.commentButton setTitle:@"再次点评" forState:UIControlStateNormal];
        }
    }];
    self.scoreHomework = request;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.chooseIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self.chooseView chooseHomeworkDetail:self.chooseIndex];
}
@end
