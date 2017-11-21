//
//  MasterHomeworkDetailViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkDetailViewController_17.h"
#import "MasterHomeworkDetailTableHeaderView_17.h"
#import "MasterHomeworkDetailRequest_17.h"
#import "MJRefresh.h"
#import "MasterHomeworkAffixsCell_17.h"
#import "MasterHomeworkCommentCell_17.h"
#import "MasterHomeworkRemarkRequest_17.h"
#import "MasterHomeworkCommentHeaderView_17.h"
#import "YXMyExamExplainView_17.h"
@interface MasterHomeworkDetailViewController_17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MasterHomeworkDetailTableHeaderView_17 *headerView;
@property (nonatomic, strong) MasterHomeworkDetailRequest_17 *detailRequest;
@property (nonatomic, strong) MasterHomeworkDetailItem_Body *detailItem;
@property (nonatomic, strong) MasterHomeworkRemarkRequest_17 *remarkRequest;
@property (nonatomic, strong) NSMutableArray *remarkMutableArray;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) MJRefreshFooterView *footer;
@property (nonatomic, assign) NSInteger startPage;

@property (nonatomic, strong) UIButton *remarkButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation MasterHomeworkDetailViewController_17

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titleString;
    self.remarkMutableArray = [[NSMutableArray alloc] init];
    self.startPage = 1;
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForHomeworkDetail];
    [self requestForHomeworkRemark];
    
}
#pragma mark - set
- (void)setDetailItem:(MasterHomeworkDetailItem_Body *)detailItem {
    _detailItem = detailItem;
    MasterHomeworkDetailItem_Body_Template_Affixs *affix = [[MasterHomeworkDetailItem_Body_Template_Affixs alloc] init];
    affix.resId = @"32323";
    affix.resName = @"西十区 第二十七期 送积分卡乐山大佛卡拉胶法警队;是发空间啊;贷款纠纷;爱空间的身份看来就爱迪生;李开复-3.mp4";
    affix.resType = @"mp4";
    _detailItem.template.affixs = @[affix];
    _detailItem.template.keyword = @"期 送积分卡乐山大佛卡拉胶法期 送积分卡乐山大佛卡拉胶法期 送积分卡乐山大佛卡拉胶法期 送积分卡乐山大佛卡拉胶法期 送积分卡乐山大佛卡拉胶法期 送积分卡乐山大佛卡拉胶法期 送积分卡乐山大佛卡拉胶法期 送积分卡乐山大佛卡拉胶法期 送积分卡乐山大佛卡拉胶法期 送积分卡乐山大佛卡拉胶法";
    self.headerView.body = _detailItem;
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 407.0f - 30.0f + self.headerView.keywordHeight);
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.hidden = NO;
    MasterHomeworkRemarkItem_Body_Remark *remark = [[MasterHomeworkRemarkItem_Body_Remark alloc] init];
    remark.content = @"三角阀;浪费;拉开发;啦;浪费空间啊离开的加法路口见对方;了看见爱的是;联发科";
    remark.userName = @"坊主日期若群无";
    remark.publishDate = @"2013.10.02";
    remark.headUrl = @"http://s1.jsyxw.cn/yanxiu/avatar_new_middle_60_60.png";
    [self.remarkMutableArray addObject:remark];
    [self setPullupViewHidden:YES];
    self.tableView.hidden = NO;
    if (_detailItem.isMyRecommend.boolValue) {
        [self.remarkButton setTitle:@"已推优" forState:UIControlStateNormal];
    }else {
        [self.remarkButton setTitle:@"推优" forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}
#pragma mark - setup UI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MasterHomeworkCommentCell_17 class] forCellReuseIdentifier:@"MasterHomeworkCommentCell_17"];
    [self.tableView registerClass:[MasterHomeworkAffixsCell_17 class] forCellReuseIdentifier:@"MasterHomeworkAffixsCell_17"];
    [self.tableView registerClass:[MasterHomeworkCommentHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"MasterHomeworkCommentHeaderView_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    self.headerView = [[MasterHomeworkDetailTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 500.0f)];
    self.tableView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    WEAK_SELF
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        self.startPage = 1;
        [self requestForHomeworkDetail];
    };
    self.footer = [MJRefreshFooterView footer];
    self.footer.scrollView = self.tableView;
    self.footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        self.startPage ++;
        [self requestForHomeworkDetail];
    };
    [self setupHomeworkRightView];
    [self setupBottomView];
    self.errorView = [[YXErrorView alloc] init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForHomeworkDetail];
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForHomeworkDetail];
    };
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
    }];
    [self.view addSubview:self.commentButton];
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.view addSubview:self.lineView];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50.0f);
        make.top.equalTo(self.view.mas_top);
    }];
    
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
}
- (void)setupHomeworkRightView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"作业要求" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"0067b8"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    button.frame = CGRectMake(0, 0, 80.0f, 30.0f);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 20.0f, 0.0f, -20.0f);
    WEAK_SELF
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self showMarkWithOriginRect:CGRectMake(200, 30.0f, 80, 30.0f) explain:self.detailItem.require.descrip];
    }];
    [self setupRightWithCustomView:button];
}
- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    YXMyExamExplainView_17 *v = [[YXMyExamExplainView_17 alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    [v setupOriginRect:rect withToTop:(rect.origin.y - [YXMyExamExplainView_17 heightForDescription:string] - 30 > 0) ? YES : NO];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"MasterHomeworkAffixsCell_17" configuration:^(MasterHomeworkAffixsCell_17 *cell) {
            cell.affix = self.detailItem.template.affixs[indexPath.row];
        }];
    }else {
        return [tableView fd_heightForCellWithIdentifier:@"MasterHomeworkCommentCell_17" configuration:^(MasterHomeworkCommentCell_17 *cell) {
            cell.remark = self.remarkMutableArray[indexPath.row];
            
        }];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    footerView.contentView.backgroundColor = [UIColor whiteColor];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.detailItem.template.affixs.count > 0) {
            return 23.0f;
        }else {
            return 0.001f;
        }
    }else {
        return 40.0f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        YXSectionHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }else {
        MasterHomeworkCommentHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MasterHomeworkCommentHeaderView_17"];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
}
#pragma mark - UITableViewDataSorce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.detailItem.template.affixs.count;
    }else {
        return self.remarkMutableArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MasterHomeworkAffixsCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterHomeworkAffixsCell_17" forIndexPath:indexPath];
        cell.affix = self.detailItem.template.affixs[indexPath.row];
        return cell;
    }else {
        MasterHomeworkCommentCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterHomeworkCommentCell_17" forIndexPath:indexPath];
        cell.remark = self.remarkMutableArray[indexPath.row];
        return cell;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  @"删除";
}
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return UITableViewCellEditingStyleDelete;
    }else {
        return UITableViewCellEditingStyleNone;
    }
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            
        }];
        
        return @[deleteRoWAction];
    }else {
        return nil;
    }
}
#pragma mark - request
- (void)requestForHomeworkDetail {
    MasterHomeworkDetailRequest_17 *request = [[MasterHomeworkDetailRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.homeworkId = self.homeworkId;
    request.key = @"1";
    WEAK_SELF
    [request startRequestWithRetClass:[MasterHomeworkDetailItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        self.detailItem = ((MasterHomeworkDetailItem *)retItem).body;
    }];
    self.detailRequest = request;
}
- (void)requestForHomeworkRemark{
    MasterHomeworkRemarkRequest_17 *request = [[MasterHomeworkRemarkRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.homeworkId = self.homeworkId;
    request.page = [NSString stringWithFormat:@"%ld",(long)self.startPage];
    request.pageSize = @"20";
    WEAK_SELF
    [request startRequestWithRetClass:[MasterHomeworkRemarkItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.footer endRefreshing];
        [self.header endRefreshing];
        [self setPullupViewHidden:YES];
        if (error) {
            self.startPage--;
            [self showToast:error.localizedDescription];
        }else {
            if (self.startPage == 0) {
                [self.remarkMutableArray removeAllObjects];
            }
            MasterHomeworkRemarkItem *item = retItem;
            [self.remarkMutableArray addObjectsFromArray:item.body.remarks];
            if (self.detailItem != nil) {
                [self.tableView reloadData];
            }
            [self setPullupViewHidden:[self.remarkMutableArray count] >= item.body.total.integerValue];
        }
    }];
}
- (void)setPullupViewHidden:(BOOL)hidden {
    self.footer.alpha = hidden ? 0:1;
}
@end
