//
//  VideoCourseCommentViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseCommentViewController.h"
#import "MJRefresh.h"
#import "VideoCourseCommentsFetcher.h"
#import "VideoCourseCommentHeaderView.h"
#import "VideoCourseCommentFooterView.h"
#import "ActivityCommentInputView.h"
#import "SendCommentView.h"
#import "VideoCourseReplyCommnetRequest.h"
#import "CommentLaudRequest.h"
#import "UITableView+TemplateLayoutHeaderView.h"
#import "VideoCourseSecondCommentViewController.h"
#import "VideoCourseReplyCommnetViewController.h"
#import "YXNavigationController.h"
@interface VideoCourseCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) int totalPage;
@property (nonatomic, strong) MJRefreshFooterView *footerView;
@property (nonatomic, strong) MJRefreshHeaderView *headerView;
@property (nonatomic, strong) ActivityCommentInputView *inputTextView;
@property (nonatomic, strong) UIView *translucentView;
@property (nonatomic, strong) SendCommentView *sendView;

@property (nonatomic, strong) VideoCourseReplyCommnetRequest *replyRequest;
@property (nonatomic, strong) CommentLaudRequest *laudRequest;
@property (nonatomic, assign) BOOL isFirstShowInput;
@property (nonatomic, strong) VideoCourseReplyCommnetViewController *replyCommnetVC;

@end

@implementation VideoCourseCommentViewController

- (void)dealloc {
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
    [self.headerView free];
    [self.footerView free];
    [self.dataFetcher stop];
    [self.inputTextView removeFromSuperview];
    self.inputTextView = nil;
    [self.translucentView removeFromSuperview];
    self.translucentView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstShowInput = YES;
    if (self.dataFetcher == nil) {
        self.dataFetcher = [[VideoCourseCommentsFetcher alloc] init];
        self.dataFetcher.courseID = self.courseId;
    }
    self.dataMutableArray = [[NSMutableArray alloc] initWithCapacity:10];
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self firstPageFetch];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.translucentView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.inputTextView inputTextViewClear];
    self.translucentView.hidden = YES;
}

#pragma mark - setupUI
- (void)setupUI {
    self.contentView = [[UIView alloc] init];
    [self.view addSubview:self.contentView];
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[VideoCourseCommentHeaderView class] forHeaderFooterViewReuseIdentifier:@"VideoCourseCommentHeaderView"];
    [self.tableView registerClass:[VideoCourseCommentFooterView class] forHeaderFooterViewReuseIdentifier:@"VideoCourseCommentFooterView"];
    [self.contentView addSubview:self.tableView];
    self.emptyView = [[YXEmptyView alloc] init];
    self.emptyView.imageName = @"暂无评论";
    self.emptyView.title = @"暂无评论";
    self.emptyView.hidden = YES;
    self.emptyView.isVideo = YES;
    [self.contentView addSubview:self.emptyView];
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.hidden = YES;
    self.errorView.isVideo = YES;
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self startLoading];
        [self firstPageFetch];
    }];
    [self.contentView addSubview:self.errorView];
    
    self.dataErrorView = [[DataErrorView alloc]initWithFrame:self.view.bounds];
    self.dataErrorView.isVideo = YES;
    [self.contentView addSubview:self.dataErrorView];
    self.dataErrorView.hidden = YES;
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self firstPageFetch];
    };
    
    self.footerView = [MJRefreshFooterView footer];
    self.footerView.scrollView = self.tableView;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 365.0f)];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.footerView addSubview:bottomView];
    [self.footerView sendSubviewToBack:bottomView];
    self.footerView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self morePageFetch];
    };
    self.footerView.alpha = 0;
    
    self.headerView = [MJRefreshHeaderView header];
    self.headerView.scrollView = self.tableView;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.view.bounds.size.width, 365.0f)];
    topView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.headerView addSubview:topView];
    [self.headerView sendSubviewToBack:topView];
    self.headerView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self firstPageFetch];
    };
    self.dataMutableArray = [[NSMutableArray alloc] initWithCapacity:10];
    self.totalPage = (int)[self.dataMutableArray count];
    self.sendView = [[SendCommentView alloc] init];
    [self.contentView addSubview:self.sendView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPublishComment)];
    [self.sendView addGestureRecognizer:recognizer];
    self.translucentView = [[UIView alloc] init];
    self.translucentView.alpha = 0.0f;
    self.translucentView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self.navigationController.view addSubview:self.translucentView];
    UITapGestureRecognizer *showRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCommentInputView)];
    [self.translucentView addGestureRecognizer:showRecognizer];
    
    self.inputTextView = [[ActivityCommentInputView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64.0f - 44.0f, kScreenWidth, 44.0f)];
    self.inputTextView.stageId = @"0";
    self.inputTextView.hidden = !self.isFullReply;
    [self.inputTextView setActivityCommentShowInputViewBlock:^(BOOL isShow) {
        STRONG_SELF
        if (isShow) {
            [UIView animateWithDuration:0.25 animations:^{
                self.translucentView.alpha = 1.0f;
            }];
        }else {
            [UIView animateWithDuration:0.25 animations:^{
                self.translucentView.alpha = 0.0f;
            }];
        }
    }];
    [self.inputTextView setActivityCommentInputTextBlock:^(NSString *inputText) {
        STRONG_SELF
        [self requestForCommentReply:inputText];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hiddenCommentInputView];
        });
    }];
    [self.navigationController.view addSubview:self.inputTextView];
}
- (void)setupLayout {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-41.0f);
        make.top.equalTo(self.view.mas_top);
    }];
    
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
    [self.dataErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.errorView.mas_left);
        make.right.equalTo(self.errorView.mas_right);
        make.bottom.equalTo(self.errorView.mas_bottom);
        make.top.equalTo(self.errorView.mas_top);
    }];
    
    [self.translucentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-44.0f);
        make.top.equalTo(self.view.mas_top);
    }];
    [self.inputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationController.view.mas_left);
        make.right.equalTo(self.navigationController.view.mas_right);
        make.bottom.equalTo(self.navigationController.view.mas_bottom).offset(140.0f);
        make.height.mas_offset(140.0f);
    }];
    [self.sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_offset(44.0f);
    }];
}
#pragma mark - request
- (void)firstPageFetch {
    if (!self.dataFetcher) {
        return;
    }
    [self.dataFetcher stop];
    self.dataFetcher.commentID = nil;
    WEAK_SELF
    [self.dataFetcher startWithBlock:^(BOOL isNext, NSMutableArray *retItemArray, NSError *error) {
        STRONG_SELF
        [self stopLoading];
        [self stopAnimation];
        if (error) {
            if (isEmpty(self.dataMutableArray)) {
                if (error.code == -2) {
                    [self showDataErrorView];
                }else{
                    [self showErroView];
                }
            } else {
                [self showToast:error.localizedDescription];
            }
            self.isFirstShowInput = NO;
        }else {
            [self.dataMutableArray removeAllObjects];
            [self formatCommentContent];
            self.errorView.hidden = YES;
            self.dataErrorView.hidden = YES;
            [self.headerView setLastUpdateTime:[NSDate date]];
            [self.dataMutableArray addObjectsFromArray:retItemArray];
            if (isEmpty(self.dataMutableArray)) {
                self.emptyView.hidden = NO;
            } else {
                self.emptyView.hidden = YES;
                [self pullupViewHidden:!isNext];
            }
            [self.tableView reloadData];
            self.tableView.contentOffset = CGPointZero;
            if (self.isFirstShowInput) {
                [self firstShowInputView];
                self.isFirstShowInput = NO;
            }
        }
        
        
    }];
}
- (void)morePageFetch {
    [self.dataFetcher stop];
    self.dataFetcher.commentID = self.dataMutableArray.lastObject.commentID;
    WEAK_SELF
    [self.dataFetcher startWithBlock:^(BOOL isNext, NSMutableArray *retItemArray, NSError *error) {
        STRONG_SELF
        [self.footerView endRefreshing];
        if (error) {
            [self showToast:error.localizedDescription];
        }else {
            [self.dataMutableArray addObjectsFromArray:retItemArray];
            [self.tableView reloadData];
            [self pullupViewHidden:!isNext];
        }
        
    }];
}
- (void)stopAnimation
{
    [self.headerView endRefreshing];
}
- (void)pulldownViewHidden:(BOOL)hidden
{
    self.headerView.alpha = hidden ? 0:1;
}
- (void)pullupViewHidden:(BOOL)hidden
{
    self.footerView.alpha = hidden ? 0:1;
}
- (void)showErroView {
    self.errorView.hidden = NO;
    [self.contentView bringSubviewToFront:self.errorView];
}

- (void)showDataErrorView {
    self.dataErrorView.hidden = NO;
    [self.contentView bringSubviewToFront:self.dataErrorView];
}

- (void)requestForCommentReply:(NSString *)inputString {
    if (self.replyRequest) {
        [self.replyRequest stopRequest];
    }
    [self startLoading];
    VideoCourseReplyCommnetRequest *request = [[VideoCourseReplyCommnetRequest alloc] init];
    request.content = inputString;
    request.courseID = self.courseId;
    request.commentID = self.parentID;
    WEAK_SELF
    [request startRequestWithRetClass:[VideoCourseReplyCommnetRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        VideoCourseReplyCommnetRequestItem *item = retItem;
        if (error) {
            [self showErrorTotal:error];
        }else if (item.body.comment){
            if (self.isFullReply) {
                [self.dataMutableArray insertObject:item.body.comment atIndex:1];
            }else {
                [self.dataMutableArray insertObject:item.body.comment atIndex:0];
            }
            [self.tableView reloadData];
            self.emptyView.hidden = YES;
            [self.inputTextView inputTextViewClear];
        }else {
            [self showToast:@"数据错误"];
        }
    }];
    self.replyRequest = request;
}

- (void)requestForCommentLaud:(NSInteger)integer {
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataMutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.0001f;
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VideoCourseCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"VideoCourseCommentHeaderView"];
    headerView.comment = self.dataMutableArray[section];
    headerView.isShowLine = self.dataMutableArray[section].childNum.integerValue <= 0;
    if (self.isFullReply && section == 0) {
        headerView.isShowLine = NO;
    }
    WEAK_SELF
    [headerView setCourseCommentsFavorBlock:^{
        STRONG_SELF
        [self requestForCommentLaud:section];
    }];
    [headerView setCourseCommentsFullReplyBlock:^(VideoCourseCommentsRequestItem_Body_Comments *replie) {
        STRONG_SELF
        [self showFullReply:section withShow:YES];

    }];

    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {;
    return [tableView yx_heightForHeaderWithIdentifier:@"VideoCourseCommentHeaderView" configuration:^(VideoCourseCommentHeaderView *headerView) {
        headerView.comment = self.dataMutableArray[section];
        headerView.isShowLine = self.dataMutableArray[section].childNum.integerValue <= 0;
        if (self.isFullReply && section == 0) {
            headerView.isShowLine = NO;
        }
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.dataMutableArray[section].childNum.integerValue <= 0) {
        return nil;
    }else {
        VideoCourseCommentFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"VideoCourseCommentFooterView"];
        footerView.childNum = self.dataMutableArray[section].childNum;
        WEAK_SELF
        [footerView setVideoCourseAllCommentReplyBlock:^() {
            STRONG_SELF
            [self showFullReply:section withShow:NO];
        }];
        return footerView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.dataMutableArray[section].childNum.integerValue <= 0 ? 0.0001f : 29.0f;
}

#pragma mark - inputView
- (void)userPublishComment{
    if (self.isFullReply) {
        self.inputTextView.textView.placeholder = @"评论 :";
        [self showCommentInputView];
    }else {
        YXNavigationController *nav = [[YXNavigationController alloc] initWithRootViewController:self.replyCommnetVC];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }

}

- (void)showCommentInputView {
    [self.inputTextView.textView becomeFirstResponder];
}
- (void)hiddenCommentInputView {
    [self.inputTextView.textView resignFirstResponder];
}
- (void)showErrorTotal:(NSError *)error {
    if (error.code == -2) {
        [self showToast:@"数据异常"];
    }else{
        [self showToast:@"网络异常,请稍后重试"];
    }
}
- (void)showFullReply:(NSInteger)section withShow:(BOOL)isShow {
    VideoCourseSecondCommentViewController *VC = [[VideoCourseSecondCommentViewController alloc] init];
    VC.courseId = self.courseId;
    VC.parentID = self.dataMutableArray[section].commentID;
    VC.comment = self.dataMutableArray[section];
    VC.chooseInteger = section;
    VC.isShowInputView = isShow;
    WEAK_SELF
    [VC setVideoCourseSecondCommentRefreshBlock:^(NSInteger chooseInteger, NSInteger totalNumber) {
        STRONG_SELF
        self.dataMutableArray[section].childNum = [NSString stringWithFormat:@"%ld",(long)totalNumber];
        [self.tableView reloadData];
    }];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)formatCommentContent{
    
}
- (void)firstShowInputView {
    
}
#pragma mark - set
- (VideoCourseReplyCommnetViewController *)replyCommnetVC {
    if (!_replyCommnetVC) {
        _replyCommnetVC = [[VideoCourseReplyCommnetViewController alloc] init];
        WEAK_SELF
        [_replyCommnetVC setVideoCourseReplyCommnetBlock:^(VideoCourseCommentsRequestItem_Body_Comments *comment) {
            STRONG_SELF
            [self.dataMutableArray insertObject:comment atIndex:0];
            [self.tableView reloadData];
            self.emptyView.hidden = YES;
        }];
        _replyCommnetVC.courseId = self.courseId;
    }
    return _replyCommnetVC;
}

@end
