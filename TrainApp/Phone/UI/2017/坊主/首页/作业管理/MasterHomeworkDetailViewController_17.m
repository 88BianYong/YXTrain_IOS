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
#import "MasterHomeworkAffixsCell_17.h"
#import "MasterHomeworkCommentCell_17.h"
#import "MasterHomeworkRemarkRequest_17.h"
#import "MasterHomeworkCommentHeaderView_17.h"
#import "MasterInputView_17.h"
#import "MasterCancelRecommendHomeworkRequest_17.h"
#import "MasterRecommendHomeworkRequest_17.h"
#import "MasterScoreHomeworkRequest_17.h"
#import "MasterHomeworkDeleteRemarkRequest_17.h"
@interface MasterHomeworkDetailViewController_17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MasterHomeworkDetailTableHeaderView_17 *headerView;
@property (nonatomic, strong) MasterHomeworkDetailRequest_17 *detailRequest;
@property (nonatomic, strong) MasterHomeworkDetailItem_Body *detailItem;
@property (nonatomic, strong) MasterHomeworkRemarkRequest_17 *remarkRequest;
@property (nonatomic, strong) MasterRecommendHomeworkRequest_17 *recommendRequest;
@property (nonatomic, strong) MasterCancelRecommendHomeworkRequest_17 *cancleRequest;
@property (nonatomic, strong) MasterScoreHomeworkRequest_17 *scoreHomework;
@property (nonatomic, strong) MasterHomeworkDeleteRemarkRequest_17 *deleteRequest;
@property (nonatomic, strong) NSMutableArray *remarkMutableArray;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) YXFileItemBase *fileItem;

@property (nonatomic, strong) MasterInputView_17 *inputView;
@property (nonatomic, strong) UIView *translucentView;

@property (nonatomic, assign) NSInteger startPage;

@property (nonatomic, strong) UIButton *remarkButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation MasterHomeworkDetailViewController_17
- (void)dealloc {
    DDLogDebug(@"======>>%@",NSStringFromClass([self class]));
    [self.inputView removeFromSuperview];
    self.inputView = nil;
    [self.translucentView removeFromSuperview];
    self.translucentView = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titleString;
    self.remarkMutableArray = [[NSMutableArray alloc] init];
    self.startPage = 1;
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForHomeworkDetail];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"作业详情" withStatus:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"作业详情" withStatus:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}
#pragma mark - set
- (void)setDetailItem:(MasterHomeworkDetailItem_Body *)detailItem {
    _detailItem = detailItem;
    self.headerView.body = _detailItem;
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 227.0f + self.headerView.summaryHeight);
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.hidden = NO;
    self.tableView.hidden = NO;
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
    WEAK_SELF
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        STRONG_SELF
        self.startPage = 1;
        [self requestForHomeworkDetail];
        [self requestForHomeworkRemark];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        STRONG_SELF
        self.startPage ++;
        [self requestForHomeworkRemark];
    }];
    self.tableView.mj_footer.hidden = YES;
    
    [self setupHomeworkRightView];
    [self setupBottomView];
    self.errorView = [[YXErrorView alloc] init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        self.startPage = 1;
        [self requestForHomeworkDetail];
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        self.startPage = 1;
        [self requestForHomeworkDetail];
    };
    [self setupInputView];
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
            [YXDataStatisticsManger trackEvent:@"取消推优" label:@"作业详情界面" parameters:nil];
            [self showAlertCancleRemark];
        }else {
            [YXDataStatisticsManger trackEvent:@"推优" label:@"作业详情界面" parameters:nil];
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
        if (self.detailItem.myScore.integerValue > 0) {
            [YXDataStatisticsManger trackEvent:@"再次点评" label:@"作业详情界面" parameters:nil];
        }else {
            [YXDataStatisticsManger trackEvent:@"点评" label:@"作业详情界面" parameters:nil];
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.translucentView.alpha = 1.0f;
        }];
        self.inputView.placeholderScoreString = @"60";
        if (self.detailItem.score.integerValue > 0) {
            self.inputView.placeholderScoreString = self.detailItem.score;
        }
        self.inputView.minScoreString = self.detailItem.myScore;
        self.inputView.inputStatus = MasterInputStatus_Score;
    }];
    [self.view addSubview:self.commentButton];
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [self.view addSubview:self.lineView];
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
            [self requestForScoreHomework:self.inputView.commentTextView.text withScore:self.inputView.scoreTextView.text];
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
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-50.0f);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-50.0f);
        }
        make.top.equalTo(self.view.mas_top);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-49.0f);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-49.0f);
        }
        make.height.mas_equalTo(1.0f);
    }];
    
    [self.remarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width).multipliedBy(1.0f/2.0f);
        make.top.equalTo(self.lineView.mas_bottom);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.width.equalTo(self.view.mas_width).multipliedBy(1.0f/2.0f);
        make.top.equalTo(self.lineView.mas_bottom);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        
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
        if (self.detailItem.require.descrip.length > 0) {
            [self showMarkWithOriginRect:CGRectMake(200, kVerticalNavBarHeight - 34.0f, 80, 30.0f) explain:self.detailItem.require.descrip];
        }
    }];
    [self setupRightWithCustomView:button];
}
- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    MasterMyExamExplainView_17 *v = [[MasterMyExamExplainView_17 alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    [v setupOriginRect:rect];
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
        if (self.remarkMutableArray.count > 0) {
            return 40.0f;
        }else {
            return 0.001f;
        }
        
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        MasterHomeworkDetailItem_Body_Template_Affixs *affix = self.detailItem.template.affixs[indexPath.row];
        YXFileType type = [YXAttachmentTypeHelper fileTypeWithTypeName:affix.resType];
        if(type == YXFileTypeUnknown) {
            [self showToast:@"暂不支持该格式文件预览"];
            return;
        }
        if (type == YXFileTypeVideo && self.detailItem.require.templateId.integerValue <= 250) {
            [self showToast:@"暂不支持该视频播放"];
            return;
        }
        
        YXFileItemBase *fileItem = [FileBrowserFactory browserWithFileType:type];
        fileItem.name = affix.resName;
        fileItem.url = affix.previewUrl;
        fileItem.baseViewController = self;
        fileItem.reportTitle = @"作业附件浏览页面";
        [fileItem browseFile];
        self.fileItem = fileItem;
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
        MasterHomeworkRemarkItem_Body_Remark *remark = self.remarkMutableArray[indexPath.row];
        if (remark.allowDel.boolValue) {
          return UITableViewCellEditingStyleDelete;
        }else {
          return UITableViewCellEditingStyleNone;
        }
    }else {
        return UITableViewCellEditingStyleNone;
    }
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MasterHomeworkRemarkItem_Body_Remark *remark = self.remarkMutableArray[indexPath.row];
        if (remark.allowDel.boolValue) {
            WEAK_SELF
            UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                STRONG_SELF
                [self requestForDeleteRemark:indexPath.row];
            }];
            return @[deleteRoWAction];
        }else {
            return nil;
        }
    }else {
        return nil;
    }
}
#pragma mark - request
- (void)requestForHomeworkDetail {
    MasterHomeworkDetailRequest_17 *request = [[MasterHomeworkDetailRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.homeworkId = self.homeworkId;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterHomeworkDetailItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
       [self.tableView.mj_header endRefreshing];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        self.detailItem = ((MasterHomeworkDetailItem *)retItem).body;
        [self requestForHomeworkRemark];
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
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self setPullupViewHidden:YES];
        if (error) {
            self.startPage--;
            [self showToast:error.localizedDescription];
        }else {
            if (self.startPage == 1) {
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
    self.remarkRequest = request;
}
- (void)setPullupViewHidden:(BOOL)hidden {
    self.tableView.mj_footer.hidden = hidden;
}
- (void)requestForRecommendHomework:(NSString *)content {
    MasterRecommendHomeworkRequest_17 *request = [[MasterRecommendHomeworkRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.homeworkId = self.homeworkId;
    request.content = content;
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self showToast:error.localizedDescription];
        }else {
            self.detailItem.isMyRecommend = @"1";
            self.detailItem.isRecommend = @"1";
            self.headerView.body = self.detailItem;
            [self.remarkButton setTitle:@"取消推优" forState:UIControlStateNormal];
            [self.inputView clearContent:MasterInputStatus_Recommend];
            self.startPage = 1;
            [self requestForHomeworkRemark];
            BLOCK_EXEC(self.masterHomeworkRecommendBlock,YES);
        }
    }];
    self.recommendRequest = request;
}
- (void)requestForCancelRecommendHomework:(NSString *)content {
    MasterCancelRecommendHomeworkRequest_17 *request = [[MasterCancelRecommendHomeworkRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.homeworkId = self.homeworkId;
    request.content = content;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterCancelRecommendHomeworkItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self showToast:error.localizedDescription];
        }else {
            MasterCancelRecommendHomeworkItem *item = retItem;
            self.detailItem.isMyRecommend = @"0";
            [self.remarkButton setTitle:@"推优" forState:UIControlStateNormal];
            if (self.detailItem.isRecommend.integerValue != item.body.isRecommend.integerValue) {
                self.detailItem.isRecommend = item.body.isRecommend;
                self.headerView.body = self.detailItem;
                BLOCK_EXEC(self.masterHomeworkRecommendBlock,self.detailItem.isRecommend.boolValue);
            }
            [self.inputView clearContent:MasterInputStatus_Cancle];
            self.startPage = 1;
            [self requestForHomeworkRemark];
        }
    }];
    self.cancleRequest = request;
}
- (void)requestForScoreHomework:(NSString *)content withScore:(NSString *)score {
    MasterScoreHomeworkRequest_17 *request = [[MasterScoreHomeworkRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.homeworkId = self.homeworkId;
    request.content = content;
    request.score = score;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterScoreHomeworkItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self showToast:error.localizedDescription];
        }else {
            MasterScoreHomeworkItem *item = retItem;
            self.detailItem.score = item.body.hwscore;
            self.detailItem.myScore = item.body.myscore;
            self.headerView.body = self.detailItem;
            [self.inputView clearContent:MasterInputStatus_Comment];
            if (self.detailItem.myScore.integerValue > 0) {
                [self.commentButton setTitle:@"再次点评" forState:UIControlStateNormal];
            }
            self.startPage = 1;
            [self requestForHomeworkRemark];
            BLOCK_EXEC(self.masterHomeworkCommendBlock);
        }
    }];
    self.scoreHomework = request;
}

- (void)requestForDeleteRemark:(NSInteger)integer {
    MasterHomeworkRemarkItem_Body_Remark *remark = self.remarkMutableArray[integer];
    MasterHomeworkDeleteRemarkRequest_17 *request = [[MasterHomeworkDeleteRemarkRequest_17 alloc] init];
    request.remarkId = remark.rId;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
        }else {
            [self showToast:@"删除成功"];
            [self.remarkMutableArray removeObjectAtIndex:integer];
            [self.tableView reloadData];
        }
    }];
    self.deleteRequest = request;
}

@end
