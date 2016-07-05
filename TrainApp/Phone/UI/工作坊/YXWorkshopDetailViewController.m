//
//  YXWorkshopDetailViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopDetailViewController.h"
#import "YXWorkshopMemberViewController.h"

#import "YXWorkshopDetailHeaderView.h"
#import "YXWorkshopDetailGroupCell.h"
#import "YXWorkshopDetailInfoCell.h"

#import "YXWorkshopDetailRequest.h"
#import "YXWorkshopMemberFetcher.h"

@interface YXWorkshopDetailViewController ()
<
  UITableViewDelegate,
  UITableViewDataSource
>
{
    UITableView *_tableView;
    YXWorkshopDetailHeaderView *_headerView;
    
    NSMutableArray *_titleMutableArray;
    YXWorkshopDetailRequestItem *_detailItem;
    
    YXWorkshopDetailRequest *_detailRequest;
    YXWorkshopMemberFetcher *_memberFetcher;
}
@end

@implementation YXWorkshopDetailViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作坊详情";
    _titleMutableArray = [[NSMutableArray alloc] initWithCapacity:2];
    _detailItem = [[YXWorkshopDetailRequestItem alloc] init];
    [self setupUI];
    [self layoutInterface];
    [self requestForWorkshopDetail];
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
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    _headerView = [[YXWorkshopDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 165.0f)];
    _tableView.tableHeaderView = _headerView;
    [_tableView registerClass:[YXWorkshopDetailGroupCell class] forCellReuseIdentifier:@"YXWorkshopDetailGroupCell"];
    [_tableView registerClass:[YXWorkshopDetailInfoCell class] forCellReuseIdentifier:@"YXWorkshopDetailInfoCell"];
    [self.view addSubview:_tableView];
    
}

- (void)layoutInterface{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSMutableDictionary *dic = _titleMutableArray[indexPath.section][indexPath.row];
        YXWorkshopMemberViewController *memberVC = [[YXWorkshopMemberViewController alloc] init];
        memberVC.dataMutableArray = dic[@"member"];
        memberVC.baridString = self.baridString;
        [self.navigationController pushViewController:memberVC animated:YES];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleMutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSArray *)_titleMutableArray[section]).count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _titleMutableArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        YXWorkshopDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXWorkshopDetailInfoCell" forIndexPath:indexPath];
        [cell reloadWithTitle:dic[@"title"] content:dic[@"content"]];
        return cell;
    }else{
        YXWorkshopDetailGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXWorkshopDetailGroupCell" forIndexPath:indexPath];
        BOOL memberBool = indexPath.row == 0 ? YES : NO;
        if (dic[@"member"]) {
            cell.memberMutableArray = dic[@"member"];
        }
        [cell reloadWithTitle:dic[@"title"] content:dic[@"content"] member:memberBool];
        return cell;
    }
}
#pragma mark - request
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
        if (item && !error) {
            self ->_detailItem = item;
            [self ->_headerView reloadWithName:_detailItem.gname
                                        master:[_detailItem.master yx_isValidString]?_detailItem.master:@"暂无"];
            [self workshopDetailDataFormat:item];
            [self requestForWorkshopMember];
        }
        else{
            [self showToast:error.localizedDescription];
        }
    }];
    _detailRequest = request;
}

- (void)requestForWorkshopMember{
    _memberFetcher = [[YXWorkshopMemberFetcher alloc] init];
    _memberFetcher.barid = self.baridString;
    _memberFetcher.pagesize = 40;
    _memberFetcher.pageindex = 0;
    WEAK_SELF
    [_memberFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        STRONG_SELF
        if (!error && retItemArray) {
            NSMutableDictionary *mutableDictionary = _titleMutableArray[1][0];
            [mutableDictionary setValue:[NSMutableArray arrayWithArray:retItemArray] forKey:@"member"];
            [self ->_tableView reloadData];
        }
    }];
}

#pragma mark - data format
- (void)workshopDetailDataFormat:(YXWorkshopDetailRequestItem *)item{
    NSString *(^formatContent)(NSString *)= ^NSString *(NSString *content){
        return [content yx_isValidString] ? content : @"暂无";;
    };

    NSArray *infoArray = @[@{@"title":@"学科",@"content":formatContent(item.subject)},
                                        @{@"title":@"学段",@"content":formatContent(item.stage)},
                                        @{@"title":@"学年",@"content":formatContent(item.grade)},
                                        @{@"title":@"简介",@"content":formatContent(item.barDesc)}];
    [_titleMutableArray addObject:infoArray];
    NSMutableDictionary *memberMutableDictionary =[@{@"title":@"成员",@"content":item.memberNum} mutableCopy];
    NSMutableDictionary *resourcesMutableDictionary =[@{@"title":@"资源",@"content":item.resNum} mutableCopy];
    NSMutableArray *mutableArray =[@[memberMutableDictionary,resourcesMutableDictionary] mutableCopy];
    [_titleMutableArray addObject:mutableArray];
    [_tableView reloadData];
}
@end
