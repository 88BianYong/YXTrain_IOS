//
//  BeijingHomeworkInfoViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/22.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingHomeworkInfoViewController.h"
#import "BeijingHomeworkInfoView.h"
#import "YXHomeworkInfoRequest.h"
static  NSString *const trackPageName = @"作业详情页面";
@interface BeijingHomeworkInfoViewController ()
@property (nonatomic, strong) BeijingHomeworkInfoView *infoView;
@property (nonatomic, strong) YXHomeworkInfoRequest *infoRequest;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation BeijingHomeworkInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isJudgmentChooseCourse]) {
        [self setupRightWithTitle:@"       "];
        [self setupUI];
        [self requestForHomeworkInfo];
    }
}
- (BOOL)isJudgmentChooseCourse{
    if ([YXTrainManager sharedInstance].currentProject.isOpenTheme.boolValue) {
        self.emptyView = [[YXEmptyView alloc]init];
        self.emptyView.title = @"您还没有选课";
        self.emptyView.imageName = @"没选课";
        [self.view addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        self.title = @"作业详情";
        return NO;
    }else {
        return YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.infoView = [[BeijingHomeworkInfoView alloc] init];
    self.infoView.hidden = YES;
    [self.scrollView addSubview:self.infoView];
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForHomeworkInfo];
    };
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self requestForHomeworkInfo];
    };
}
- (void)setupLayoutWithHeight:(CGFloat)height {
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, height);
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(height);
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}
#pragma mark - request
- (void)requestForHomeworkInfo{
    YXHomeworkInfoRequest *request = [[YXHomeworkInfoRequest alloc] init];
    request.pid = self.itemBody.pid;
    request.requireid = self.itemBody.requireId;
    request.hwid = self.itemBody.homeworkid;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXHomeworkInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = retItem != nil;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        YXHomeworkInfoRequestItem *item = retItem;
        [self setupLayoutWithHeight:[self scrollViewContentSizeWithDescription:item.body.depiction ?: @" "].height + 247 + 22];
        self.title = item.body.title;
        self.infoView.hidden = NO;
        self.infoView.body = item.body;
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainFirstGoInHomeworkInfo]) {
            static NSString * staticString = @"YXHomeworkPromptView";
            UIView *promptView = [[NSClassFromString(staticString) alloc] init];
            [self.view addSubview:promptView];
            [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainFirstGoInHomeworkInfo];
        }
    }];
    self.infoRequest = request;
}

- (CGSize)scrollViewContentSizeWithDescription:(NSString*)desc{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    CGRect rect = [desc boundingRectWithSize:CGSizeMake(kScreenWidth - 50.0f, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSParagraphStyleAttributeName:paragraphStyle} context:NULL];
    return rect.size;
}
@end
