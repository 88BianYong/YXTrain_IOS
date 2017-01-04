//
//  CommentPageListViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/14.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "CommentPageListViewController.h"
#import "MJRefresh.h"
#import "CommentPagedListFetcher.h"
#import "ActitvityCommentHeaderView.h"
#import "ActitvityCommentCell.h"
#import "ActitvityCommentFooterView.h"
#import "ActivityCommentInputView.h"
#import "SendCommentView.h"
#import "CommentReplyRequest.h"
#import "CommentLaudRequest.h"
#import "YXUserProfile.h"
#import "UITableView+TemplateLayoutHeaderView.h"
#import "SecondCommentViewController.h"
@interface CommentPageListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) int totalPage;
@property (nonatomic, strong) MJRefreshFooterView *footerView;
@property (nonatomic, strong) MJRefreshHeaderView *headerView;
@property (nonatomic, strong) ActivityCommentInputView *inputTextView;
@property (nonatomic, strong) UIView *translucentView;
@property (nonatomic, strong) SendCommentView *sendView;

@property (nonatomic, strong) CommentReplyRequest *replyRequest;
@property (nonatomic, strong) CommentLaudRequest *laudRequest;
@property (nonatomic, assign) NSInteger replyInteger;


@end

@implementation CommentPageListViewController
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
    self.title = @"讨论";
    if (self.dataFetcher == nil) {
        self.dataFetcher = [[CommentPagedListFetcher alloc] init];
        self.dataFetcher.aid = self.tool.aid;
        self.dataFetcher.toolid = self.tool.toolid;
        self.dataFetcher.w = [YXTrainManager sharedInstance].trainHelper.w;
        self.dataFetcher.pageIndex = 1;
        self.dataFetcher.pageSize = 20;
    }
    self.replyInteger = -1;
    self.dataMutableArray = [[NSMutableArray alloc] initWithCapacity:10];
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self firstPageFetch];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.inputTextView inputTextViewClear];
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.tableHeaderView = headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ActitvityCommentCell class] forCellReuseIdentifier:@"ActitvityCommentCell"];
    [self.tableView registerClass:[ActitvityCommentHeaderView class] forHeaderFooterViewReuseIdentifier:@"ActitvityCommentHeaderView"];
    [self.tableView registerClass:[ActitvityCommentFooterView class] forHeaderFooterViewReuseIdentifier:@"ActitvityCommentFooterView"];
    [self.view addSubview:self.tableView];
    self.emptyView = [[YXEmptyView alloc] init];
    self.emptyView.imageName = @"暂无评论";
    self.emptyView.title = @"暂无评论";
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.hidden = YES;
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self startLoading];
        [self firstPageFetch];
    }];
    [self.view addSubview:self.errorView];
    
    self.dataErrorView = [[DataErrorView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.dataErrorView];
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
    [self.view addSubview:self.sendView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPublishComment)];
    [self.sendView addGestureRecognizer:recognizer];
    self.translucentView = [[UIView alloc] init];
    self.translucentView.alpha = 0.0f;
    self.translucentView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self.navigationController.view addSubview:self.translucentView];
    UITapGestureRecognizer *showRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCommentInputView)];
    [self.translucentView addGestureRecognizer:showRecognizer];
    
    self.inputTextView = [[ActivityCommentInputView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64.0f - 44.0f, kScreenWidth, 44.0f)];
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
- (void)startLoading {
    [YXPromtController startLoadingInView:self.tableView];
}
- (void)stopLoading {
    [YXPromtController stopLoadingInView:self.tableView];
}
- (void)setupLayout {
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

- (void)updateLyout {
    
}
#pragma mark - request
- (void)firstPageFetch {
    if (!self.dataFetcher) {
        return;
    }
    [self.dataFetcher stop];
    self.dataFetcher.pageIndex = 1;
    if (!self.dataFetcher.pageSize) {
        self.dataFetcher.pageSize = 20;
    }
    WEAK_SELF
    [self.dataFetcher startWithBlock:^(int totalPage, int currentPage, int totalNum, NSMutableArray *retItemArray, NSError *error) {
        STRONG_SELF
        [self stopLoading];
        [self stopAnimation];
        self.tableView.tableHeaderView.hidden = NO;
        if (error) {
            if (isEmpty(self.dataMutableArray)) {
                self.totalPage = 0;
                if (error.code == -2) {
                    [self showDataErrorView];
                }else{
                    [self showErroView];
                }
            } else {
                self.totalPage = 0;
                [self showToast:error.localizedDescription];
            }
        }else {
            [self.dataMutableArray removeAllObjects];
            [self formatCommentContent];
            self.totalNum = totalNum;
            self.errorView.hidden = YES;
            self.dataErrorView.hidden = YES;
            [self.headerView setLastUpdateTime:[NSDate date]];
            self.totalPage = totalPage;
            [self.dataMutableArray addObjectsFromArray:retItemArray];
            if (isEmpty(self.dataMutableArray)) {
                self.emptyView.hidden = NO;
            } else {
                self.emptyView.hidden = YES;
                [self pullupViewHidden:!(totalPage > currentPage)];
            }
            [self.tableView reloadData];
            self.tableView.contentOffset = CGPointZero;
        }

    }];
}
- (void)morePageFetch {
    [self.dataFetcher stop];
    self.dataFetcher.pageIndex++;
    WEAK_SELF
    [self.dataFetcher startWithBlock:^(int totalPage, int currentPage, int totalNum, NSMutableArray *retItemArray, NSError *error) {
        STRONG_SELF
        [self.footerView endRefreshing];
        if (error) {
            self.dataFetcher.pageIndex--;
            [self showToast:error.localizedDescription];
        }else {
            self.totalNum = totalNum;
            [self.dataMutableArray addObjectsFromArray:retItemArray];
            self.totalPage = totalPage;
            [self.tableView reloadData];
            [self pullupViewHidden:!(totalPage > currentPage)];
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
    [self.view bringSubviewToFront:self.errorView];
}

- (void)showDataErrorView {
    self.dataErrorView.hidden = NO;
    [self.view bringSubviewToFront:self.dataErrorView];
}

- (void)requestForCommentReply:(NSString *)inputString {
    if (self.replyRequest) {
        [self.replyRequest stopRequest];
    }
    [self startLoading];
    CommentReplyRequest *request = [[CommentReplyRequest alloc] init];
    if (self.replyInteger >= 0) {
        ActivityFirstCommentRequestItem_Body_Replies *temp = self.dataMutableArray[self.replyInteger];
        request.parentid = temp.replyID;
        request.topicid = temp.topicid;
        if ([YXTrainManager sharedInstance].trainHelper.w.integerValue <= 3) {
            inputString = [NSString stringWithFormat:@"回复%@%@%@%@",kNameSeparator,temp.userName,kContentSeparator,inputString];
        }
    }
    request.content = inputString;
    request.aid = self.tool.aid;
    request.tooltype = self.tool.toolType;
    request.toolid = self.tool.toolid;
    request.w = [YXTrainManager sharedInstance].trainHelper.w;
    WEAK_SELF
    [request startRequestWithRetClass:[CommentReplyRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        CommentReplyRequestItem *item = retItem;
        if (error) {
            if (error.code == -2) {
                [self showToast:@"数据错误"];
            }else{
                [self showToast:@"网络异常,请稍后重试"];
            }
        }else if (item.body.reply != nil){
            if (self.isFullReply) {
                [self.dataMutableArray insertObject:item.body.reply atIndex:1];
                self.totalNum ++;
            }else {
                [self.dataMutableArray insertObject:item.body.reply atIndex:0];
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
    if (self.laudRequest) {
        [self.laudRequest stopRequest];
    }
    CommentLaudRequest *request = [[CommentLaudRequest alloc] init];
    request.aid = self.tool.aid;
    request.toolid = self.tool.toolid;
    request.w = [YXTrainManager sharedInstance].trainHelper.w;
    ActivityFirstCommentRequestItem_Body_Replies *reply = self.dataMutableArray[integer];
    request.replyid = reply.replyID;
    request.topicid = reply.topicid;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            if (error.code == -2) {
                [self showToast:@"数据异常"];
            }else{
                [self showToast:@"网络异常,请稍后重试"];
            }
        }else {
            ActivityFirstCommentRequestItem_Body_Replies *reply = self.dataMutableArray[integer];
            reply.isRanked = @"true";
            reply.up = [NSString stringWithFormat:@"%d",(int)(reply.up.integerValue + 1)];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:integer] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    self.laudRequest = request;
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataMutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[indexPath.section];
    ActivityFirstCommentRequestItem_Body_Replies *reply = replie.replies[indexPath.row];
    ActitvityCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActitvityCommentCell" forIndexPath:indexPath];
    cell.reply = reply;
    if (replie.childNum.integerValue <= 1) {
        cell.cellStatus = ActitvityCommentCellStatus_Top | ActitvityCommentCellStatus_Bottom;
    }else {
        if (indexPath.row == 0) {
            cell.cellStatus = ActitvityCommentCellStatus_Top;
        } else if ((replie.childNum.integerValue == replie.replies.count) && (indexPath.row == replie.replies.count - 1)) {
            cell.cellStatus = ActitvityCommentCellStatus_Bottom;
        } else {
            cell.cellStatus = ActitvityCommentCellStatus_Middle;
        }
    }
    WEAK_SELF
    [cell setActitvityCommentCellFavorBlock:^{
        STRONG_SELF
        if ([self isCheckActivityStatus]){
            //[self requestForCommentLaud:indexPath];
        }
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"ActitvityCommentCell" configuration:^(ActitvityCommentCell *cell) {
        ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[indexPath.section];
        ActivityFirstCommentRequestItem_Body_Replies *reply = replie.replies[indexPath.row];
        cell.reply = reply;
        if (replie.childNum.integerValue <= 1) {
            cell.cellStatus = ActitvityCommentCellStatus_Top | ActitvityCommentCellStatus_Bottom;
        }else {
            if (indexPath.row == 0) {
                cell.cellStatus = ActitvityCommentCellStatus_Top;
            } else if ((replie.childNum.integerValue == replie.replies.count) && (indexPath.row == replie.replies.count - 1)) {
                cell.cellStatus = ActitvityCommentCellStatus_Bottom;
            } else {
                cell.cellStatus = ActitvityCommentCellStatus_Middle;
            }
        }
    }];
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[section];
    ActitvityCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ActitvityCommentHeaderView"];
    headerView.isFontBold = YES;
    headerView.replie = replie;
    if (section == 0 && self.dataErrorView.isActivityVideo) {//只有视频的第一个评论显示高度不同
        headerView.distanceTop = kDistanceTopMiddle;
    }else {
        if (section == 0) {
            headerView.distanceTop = kDistanceTopLong;
        }else {//没有二级评论间距缩小
            headerView.distanceTop = kDistanceTopShort;
        }
    }
    WEAK_SELF
    [headerView setActitvityCommentReplyBlock:^(ActivityFirstCommentRequestItem_Body_Replies *replie) {
        STRONG_SELF
        if ([YXTrainManager sharedInstance].trainHelper.w.integerValue <= 3) {
            if ([self isCheckActivityStatus]) {
                if (self.replyInteger != section) {
                    [self.inputTextView inputTextViewClear];
                }
                self.replyInteger = section;
                [self inputActitvityCommentReply:replie];
            }
        }else {
            SecondCommentViewController *VC = [[SecondCommentViewController alloc] init];
            VC.tool = self.tool;
            VC.parentID = replie.replyID;
            VC.replie = replie;
            VC.chooseInteger = section;
            WEAK_SELF
            [VC setRefreshBlock:^(NSInteger integer, NSString *isRanked, NSInteger totalInteger) {
                STRONG_SELF
                replie.isRanked = isRanked;
                replie.childNum = [NSString stringWithFormat:@"%ld",(long)totalInteger];
                [self.tableView beginUpdates];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:integer] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }];
    [headerView setActitvityCommentFavorBlock:^{
        STRONG_SELF
        if ([self isCheckActivityStatus]) {
            [self requestForCommentLaud:section];
        }
    }];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [tableView yx_heightForCellWithIdentifier:@"ActitvityCommentHeaderView" configuration:^(ActitvityCommentHeaderView *headerView) {
        ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[section];
        headerView.isFontBold = YES;
        headerView.replie = replie;
        if (section == 0 && self.dataErrorView.isActivityVideo){
            headerView.distanceTop = kDistanceTopMiddle;
        }else {
            if (section == 0) {
                headerView.distanceTop = kDistanceTopLong;
            }else {
                if (section == 0) {
                    headerView.distanceTop = kDistanceTopLong;
                }else {//没有二级评论间距缩小
                    headerView.distanceTop = kDistanceTopShort;
                }
            }
        }
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[section];
    if (replie.childNum.integerValue <= 0) {
        return nil;
    }else {
        if ([YXTrainManager sharedInstance].trainHelper.w.integerValue > 3) {
            ActitvityCommentFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ActitvityCommentFooterView"];
            footerView.tag = section + 1000;
            footerView.childNum = replie.childNum;
            return footerView;
        }else {
            return nil;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[section];
    if (replie.childNum.integerValue <= 0) {
        return 0.0001f;
    }else {
        if ([YXTrainManager sharedInstance].trainHelper.w.integerValue > 3) {
            return 29.0f;
        }else {
            return 0.0001f;
        }
    }
}

#pragma mark - inputView
- (void)userPublishComment{
    if ([self isCheckActivityStatus]) {
        self.replyInteger = self.isFullReply ? 0 : -1;
        if (self.replyInteger >= 0) {
            ActivityFirstCommentRequestItem_Body_Replies *temp = self.dataMutableArray[self.replyInteger];
            [self inputActitvityCommentReply:temp];
        }else {
            self.inputTextView.textView.placeholder = @"评论 :";
            [self showCommentInputView];
        }
    }
}

- (void)showCommentInputView {
    [self.inputTextView.textView becomeFirstResponder];
}
- (void)hiddenCommentInputView {
    [self.inputTextView.textView resignFirstResponder];
}

- (void)inputActitvityCommentReply:(ActivityFirstCommentRequestItem_Body_Replies *)replies {
    self.inputTextView.textView.placeholder = [NSString stringWithFormat:@"回复 %@:",replies.userName];
    [self showCommentInputView];
}

- (BOOL)isCheckActivityStatus {
    if (self.status.integerValue == 3) {
        [self showToast:@"活动已结束"];
        return NO;
    }else {
        return YES;
    }
}
- (void)formatCommentContent{
    
}
@end
