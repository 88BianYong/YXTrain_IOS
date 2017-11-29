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
@interface MasterHomeworkSetListDetailViewController_17 ()<UIScrollViewDelegate>
@property (nonatomic, strong) MasterHomeworkSetListDetailRequest_17 *detailRequest;
@property (nonatomic, strong) MasterHomeworkSetListDetailItem_Body *detailItem;


@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UIImageView *recommendImageView;
@property (nonatomic, strong) UIView *firstLineView;
@property (nonatomic, strong) UIView *secondLineView;
@property (nonatomic, strong) MasterHomeworkSetChooseView_17 *chooseView;

@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation MasterHomeworkSetListDetailViewController_17
- (void)dealloc {
    DDLogDebug(@"release=====>%@",NSStringFromClass([self class]));
}
#pragma mark - set
- (void)setDetailItem:(MasterHomeworkSetListDetailItem_Body *)detailItem {
    _detailItem = detailItem;
    if (_detailItem.score.integerValue > 0) {
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"e5581a"];
        self.scoreLabel.text = [NSString stringWithFormat:@"%@分",_detailItem.score];
    }else {
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"334466"];
        self.scoreLabel.text = @"未批阅";
    }
    self.recommendImageView.hidden = !_detailItem.isRecommend.boolValue;
    self.chooseView.homeworkArray = _detailItem.homeworks;
    [_detailItem.homeworks enumerateObjectsUsingBlock:^(MasterHomeworkSetListDetailItem_Body_Homework *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MasterHomeworkSetDetailViewController_17 *VC = [[MasterHomeworkSetDetailViewController_17 alloc] init];
        VC.homeworkId = obj.homeworkId;
        [self addChildViewController:VC];
        [self.scrollView addSubview:VC.view];
        [VC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.mas_left).offset(kScreenWidth * idx);
            make.top.equalTo(self.scrollView.mas_top);
            make.bottom.equalTo(self.scrollView.mas_bottom);
            make.width.mas_offset(kScreenWidth);
        }];
    }];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * _detailItem.homeworks.count, 100.0f);
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.view addSubview:self.scoreLabel];
    
    self.recommendImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"优标签"]];
    [self.view addSubview:self.recommendImageView];
    
    self.firstLineView = [[UIView alloc] init];
    self.firstLineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.view addSubview:self.firstLineView];
    
    self.secondLineView = [[UIView alloc] init];
    self.secondLineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.view addSubview:self.secondLineView];
    
    self.chooseView = [[MasterHomeworkSetChooseView_17 alloc]initWithFrame:CGRectMake(15, 45, kScreenWidth - 30.0f, 45)];
    WEAK_SELF
    self.chooseView.masterHomeworkSetChooseBlock = ^(NSInteger integer) {
        STRONG_SELF
        
    };
    [self.view addSubview:self.chooseView];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
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
@end
