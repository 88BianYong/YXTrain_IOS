//
//  YXWorkshopDetailViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopDetailViewController.h"
#import "YXWorkshopMemberViewController.h"
#import "YXWorkshopDatumViewController.h"

#import "YXWorkshopDetailHeaderView.h"
#import "YXWorkshopDetailGroupCell.h"
#import "YXWorkshopDetailInfoCell.h"
#import "YXWorkshopDetailDatumCell.h"


#import "YXWorkshopDetailRequest.h"
#import "YXWorkshopMemberFetcher.h"
static  NSString *const trackPageName = @"工作坊详情页面";
@interface YXWorkshopDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView *_tableView;
    YXWorkshopDetailHeaderView *_headerView;
    YXErrorView *_errorView;
    
    NSMutableArray *_dataMutableArray;
    YXWorkshopDetailRequestItem *_detailItem;
    BOOL _hiddenPullupBool;
    
    YXWorkshopDetailRequest *_detailRequest;
    YXWorkshopMemberFetcher *_memberFetcher;
}
@end

@implementation YXWorkshopDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [YXTrainManager sharedInstance].trainHelper.workshopDetailTitle;
    _dataMutableArray = [[NSMutableArray alloc] initWithCapacity:2];
    [self workshopDetailDataFormat:nil];
    _detailItem = [[YXWorkshopDetailRequestItem alloc] init];
    [self setupUI];
    [self layoutInterface];
    [self requestForWorkshopDetail];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    if (_detailRequest) {
        [_detailRequest stopRequest];
    }
    if (_memberFetcher) {
        [_memberFetcher stop];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _tableView.layoutMargins = UIEdgeInsetsZero;
    _tableView.separatorColor = [UIColor colorWithHexString:@"eceef2"];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [_tableView registerClass:[YXWorkshopDetailGroupCell class] forCellReuseIdentifier:@"YXWorkshopDetailGroupCell"];
    [_tableView registerClass:[YXWorkshopDetailInfoCell class] forCellReuseIdentifier:@"YXWorkshopDetailInfoCell"];
    [_tableView registerClass:[YXWorkshopDetailDatumCell class] forCellReuseIdentifier:@"YXWorkshopDetailDatumCell"];
    [self.view addSubview:_tableView];
    _headerView = [[YXWorkshopDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 165.0f)];
    _tableView.tableHeaderView = _headerView;
    
    WEAK_SELF
    _errorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
    _errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForWorkshopDetail];
    };
    
}

- (void)layoutInterface{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
//        make.top.equalTo(_headerView.mas_bottom);
    }];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(_tableView);
        make.height.mas_offset(165.0f);
    }];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 60.0f;
    }else{
        return 44.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSMutableDictionary *dic = _dataMutableArray[indexPath.section][indexPath.row];
        YXWorkshopMemberViewController *memberVC = [[YXWorkshopMemberViewController alloc] init];
        memberVC.cachMutableArray = dic[@"member"];
        memberVC.baridString = self.baridString;
        memberVC.hiddenPullupBool = _hiddenPullupBool;
        [self.navigationController pushViewController:memberVC animated:YES];
    }else if(indexPath.section == 1 && indexPath.row == 1){
        YXWorkshopDatumViewController *datumVC = [[YXWorkshopDatumViewController alloc] init];
        datumVC.baridString = self.baridString;
        [self.navigationController pushViewController:datumVC animated:YES];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataMutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSArray *)_dataMutableArray[section]).count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataMutableArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        YXWorkshopDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXWorkshopDetailInfoCell" forIndexPath:indexPath];
        [cell reloadWithTitle:dic[@"title"] content:dic[@"content"]];
        return cell;
    }else{
        if (indexPath.row == 0) {
            YXWorkshopDetailGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXWorkshopDetailGroupCell" forIndexPath:indexPath];
            if (dic[@"member"]) {
                cell.memberMutableArray = dic[@"member"];
            }
            [cell reloadWithTitle:dic[@"title"] content:dic[@"content"]];
            return cell;
            
        }else{
            YXWorkshopDetailDatumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXWorkshopDetailDatumCell" forIndexPath:indexPath];
            [cell reloadWithTitle:dic[@"title"] content:dic[@"content"]];
            return cell;
        }
    }
}
#pragma mark - request
/**
 *  请求工作坊详情
 */
- (void)requestForWorkshopDetail{
    if (_detailRequest) {
        [_detailRequest stopRequest];
    }
    YXWorkshopDetailRequest *request = [[YXWorkshopDetailRequest alloc] init];
    request.barid = self.baridString;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXWorkshopDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        YXWorkshopDetailRequestItem *item = (YXWorkshopDetailRequestItem *)retItem;
        if (error) {
            self ->_errorView.frame = self.view.bounds;
            [self.view addSubview:self ->_errorView];
        }
        else{
            self ->_detailItem = item;
            [self ->_headerView reloadWithName:_detailItem.gname
                                        master:[_detailItem.master yx_isValidString]?_detailItem.master:@"暂无"];
            [self workshopDetailDataFormat:item];
            [self requestForWorkshopMember];
            [self ->_errorView removeFromSuperview];
        }
    }];
    _detailRequest = request;
}
/**
 *  请求成员列表 默认请求40个为列表详情页公用数据
 */
- (void)requestForWorkshopMember{
    if (_memberFetcher) {
        [_memberFetcher stop];
    }
    _memberFetcher = [[YXWorkshopMemberFetcher alloc] init];
    _memberFetcher.barid = self.baridString;
    _memberFetcher.pagesize = 40;
    _memberFetcher.pageindex = 0;
    WEAK_SELF
    [_memberFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        STRONG_SELF
        if (!error && retItemArray) {
            NSMutableDictionary *mutableDictionary = _dataMutableArray[1][0];
            [mutableDictionary setValue:[NSMutableArray arrayWithArray:retItemArray] forKey:@"member"];
            [self ->_tableView reloadData];
            self -> _hiddenPullupBool = retItemArray.count >= total ? YES : NO;
        }
    }];
}
#pragma mark - data format
/**
 *  格式化显示数据
 *
 *  @param item 工作坊详情数据
 */
- (void)workshopDetailDataFormat:(YXWorkshopDetailRequestItem * __nullable)item{
    NSString *(^formatContent)(NSString *)= ^NSString *(NSString *content){
        return [content yx_isValidString] ? content : @"暂无";;
    };
    [_dataMutableArray  removeAllObjects];
    NSArray *infoArray = @[@{@"title":@"学科",@"content":formatContent(item.subject)},
                           @{@"title":@"学段",@"content":formatContent(item.stage)},
                           @{@"title":@"学年",@"content":formatContent(item.grade)},
                           @{@"title":@"简介",@"content":formatContent(item.barDesc)}];
    [_dataMutableArray addObject:infoArray];
    NSMutableDictionary *memberMutableDictionary =[@{@"title":@"成员",@"content":formatContent(item.memberNum)} mutableCopy];
    [memberMutableDictionary setValue:[NSMutableArray array] forKey:@"member"];
    NSMutableDictionary *resourcesMutableDictionary =[@{@"title":@"资源",@"content":formatContent(item.resNum)} mutableCopy];
    NSMutableArray *mutableArray =[@[memberMutableDictionary,resourcesMutableDictionary] mutableCopy];
    [_dataMutableArray addObject:mutableArray];
    [_tableView reloadData];
}
@end
