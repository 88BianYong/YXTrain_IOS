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
@interface CommentPageListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) int totalPage;
@property (nonatomic, strong) MJRefreshFooterView *footerView;
@property (nonatomic, strong) MJRefreshHeaderView *headerView;
@property (nonatomic, strong) ActivityCommentInputView *inputTextView;
@property (nonatomic, strong) UIView *translucentView;
@property (nonatomic, strong) SendCommentView *sendView;

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
    [self setupUI];
    [self setupLayout];
    [self firstPageFetch:YES];
    [self setupMorkData];
}
- (void)setupMorkData {
    ActivityFirstCommentRequestItem_Body *body = [[ActivityFirstCommentRequestItem_Body alloc] init];
    ActivityFirstCommentRequestItem_Body_Replies *replie = [[ActivityFirstCommentRequestItem_Body_Replies alloc] init];
    replie.headUrl = @"http://s1.jsyxw.cn/yanxiu/u/32/81/Img828132_60.jpg";
    replie.time = @"2016年11月09日 13:54";
    replie.userName = @"李四";
    replie.up = @"5";
    replie.childNum = @"5";
    replie.content = @"是分开了涉及到法律会计师的两款发动机谁离开就疯了空间上浪费的空间个";
    NSMutableArray<ActivityFirstCommentRequestItem_Body_Replies> *mutableArray = [@[replie,replie,replie,replie,replie] mutableCopy];
    NSMutableArray<ActivityFirstCommentRequestItem_Body_Replies> *mutableArrayA = [@[replie,replie] mutableCopy];
    replie.reply = mutableArrayA;
    body.replies = mutableArray;
    self.dataMutableArray = body.replies;
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 44.0f;
    [self.tableView registerClass:[ActitvityCommentCell class] forCellReuseIdentifier:@"ActitvityCommentCell"];
    [self.tableView registerClass:[ActitvityCommentHeaderView class] forHeaderFooterViewReuseIdentifier:@"ActitvityCommentHeaderView"];
    [self.tableView registerClass:[ActitvityCommentFooterView class] forHeaderFooterViewReuseIdentifier:@"ActitvityCommentFooterView"];
    [self.view addSubview:self.tableView];
    
    self.emptyView = [[YXEmptyView alloc] init];
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.hidden = YES;
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self startLoading];
        [self firstPageFetch:YES];
    }];
    [self.view addSubview:self.errorView];
    
    self.dataErrorView = [[DataErrorView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.dataErrorView];
    self.dataErrorView.hidden = YES;
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self firstPageFetch:YES];
    };
    
    self.footerView = [MJRefreshFooterView footer];
    self.footerView.scrollView = self.tableView;
    self.footerView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self morePageFetch];
    };
    self.footerView.alpha = 0;
    
    self.headerView = [MJRefreshHeaderView header];
    self.headerView.scrollView = self.tableView;
    self.headerView.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self firstPageFetch:NO];
    };
    self.dataMutableArray = [[NSMutableArray alloc] initWithCapacity:10];
    self.totalPage = (int)[self.dataMutableArray count];
    
    if (!self.isHiddenInputView) {
        self.sendView = [[SendCommentView alloc] init];
        [self.view addSubview:self.sendView];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCommentInputView)];
        [self.sendView addGestureRecognizer:recognizer];
        
        
        self.translucentView = [[UIView alloc] init];
        self.translucentView.alpha = 0.0f;
        self.translucentView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self.navigationController.view addSubview:self.translucentView];
        UITapGestureRecognizer *showRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCommentInputView)];
        [self.translucentView addGestureRecognizer:showRecognizer];
        
        self.inputTextView = [[ActivityCommentInputView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64.0f - 44.0f, kScreenWidth, 44.0f)];
        WEAK_SELF
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
            
        }];
        [self.navigationController.view addSubview:self.inputTextView];
    }
}

- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
    
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
    
    [self.translucentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    if (!self.isHiddenInputView) {
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
}

#pragma mark - request
- (void)firstPageFetch:(BOOL)isShow {
    if (!self.dataFetcher) {
        return;
    }
    [self.dataFetcher stop];
    self.dataFetcher.pageindex = 0;
    if (!self.dataFetcher.pageSize) {
        self.dataFetcher.pageSize = 20;
    }
    if (isShow) {
        //[self startLoading];
    }
    WEAK_SELF
    [self.dataFetcher startWithBlock:^(int totalPage, int currentPage, NSMutableArray *retItemArray, NSError *error) {
        STRONG_SELF
        WEAK_SELF
        dispatch_async(dispatch_get_main_queue(), ^{
            STRONG_SELF
            [self stopLoading];
            [self stopAnimation];
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
                [self pullupViewHidden:!(totalPage >= currentPage)];
            }else {
                self.errorView.hidden = YES;
                self.dataErrorView.hidden = YES;
                [self.headerView setLastUpdateTime:[NSDate date]];
                self.totalPage = totalPage;
                [self.dataMutableArray removeAllObjects];
                if (isEmpty(retItemArray)) {
                    self.emptyView.hidden = NO;
                } else {
                    self.emptyView.hidden = YES;
                    [self.dataMutableArray addObjectsFromArray:retItemArray];
                    [self pullupViewHidden:!(totalPage >= currentPage)];
                }
                [self.tableView reloadData];
                self.tableView.contentOffset = CGPointZero;
            }
        });
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

- (void)morePageFetch {
    [self.dataFetcher stop];
    self.dataFetcher.pageindex++;
    WEAK_SELF
    [self.dataFetcher startWithBlock:^(int totalPage, int currentPage, NSMutableArray *retItemArray, NSError *error) {
        STRONG_SELF
        WEAK_SELF
        dispatch_async(dispatch_get_main_queue(), ^{
            STRONG_SELF
            [self.footerView endRefreshing];
            if (error) {
                self.dataFetcher.pageindex--;
                [self showToast:error.localizedDescription];
                return;
            }else {
                [self.dataMutableArray addObjectsFromArray:retItemArray];
                self.totalPage = totalPage;
                [self.tableView reloadData];
                [self pullupViewHidden:!(totalPage >= currentPage)];
            }
        });
    }];
}

- (void)showErroView {
    self.errorView.hidden = NO;
    [self.view bringSubviewToFront:self.errorView];
}

- (void)showDataErrorView {
    self.dataErrorView.hidden = NO;
    [self.view bringSubviewToFront:self.dataErrorView];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataMutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[section];
    return replie.reply.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[indexPath.section];
    ActivityFirstCommentRequestItem_Body_Replies *reply = replie.reply[indexPath.row];
    ActitvityCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActitvityCommentCell" forIndexPath:indexPath];
    cell.reply = reply;
    if (cell.reply.childNum.integerValue <= 1) {
        cell.cellStatus = ActitvityCommentCellStatus_Top | ActitvityCommentCellStatus_Bottom;
    }else {
        if (indexPath.row == 0) {
            cell.cellStatus = ActitvityCommentCellStatus_Top;
        } else if ((replie.childNum.integerValue == reply.reply.count) && (indexPath.row == reply.reply.count - 1)) {
            cell.cellStatus = ActitvityCommentCellStatus_Bottom;
        } else {
            cell.cellStatus = ActitvityCommentCellStatus_Middle;
        }
    }
    return cell;
}

#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ActivityFirstCommentRequestItem_Body_Replies *replie = self.dataMutableArray[section];
    ActitvityCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ActitvityCommentHeaderView"];
    headerView.replie = replie;
    WEAK_SELF
    [headerView setActitvityCommentReplyBlock:^(ActivityFirstCommentRequestItem_Body_Replies *replie) {
        STRONG_SELF
        [self inputActitvityCommentReply:replie];
    }];
    [headerView setActitvityCommentFavorBlock:^(ActivityFirstCommentRequestItem_Body_Replies *replie) {
        STRONG_SELF
        
    }];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ActitvityCommentFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ActitvityCommentFooterView"];
    footerView.tag = section + 1000;
    WEAK_SELF
    [footerView setActitvitySeeAllCommentReplyBlock:^(NSInteger tagInteger) {
        STRONG_SELF
        NSString *string = @"SecondCommentViewController";
        UIViewController *VC = [[NSClassFromString(string) alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 29.0f;
}

#pragma mark - inputView
- (void)showCommentInputView {
    [self.inputTextView.textView becomeFirstResponder];
}
- (void)hiddenCommentInputView {
    [self.inputTextView.textView resignFirstResponder];
}

- (void)inputActitvityCommentReply:(ActivityFirstCommentRequestItem_Body_Replies *)replies {
    self.inputTextView.textView.placeholder = [NSString stringWithFormat:@"回复 %@:",replies.userName];
    [self showCommentInputView];
    DDLogDebug(@">>>>%@",self.inputTextView.textView.placeholder);
    
}

- (void)reportActitvityCommentReply:(NSString *)replyString {
    
}

@end
