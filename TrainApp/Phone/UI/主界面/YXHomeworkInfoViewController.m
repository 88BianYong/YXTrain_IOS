//
//  YXHomeworkInfoViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkInfoViewController.h"
#import "YXHomeworkInfoHeaderView.h"
#import "YXHomeworkInfoRequest.h"
#import "YXHomeworkInfoFooterView.h"
@interface YXHomeworkInfoViewController ()
{
    UITableView *_tableView;
    
    YXHomeworkInfoRequest *_infoRequest;
    
    YXHomeworkInfoRequestItem *_infoItem;
}
@property(nonatomic ,strong)YXHomeworkInfoHeaderView *headerView;
@property(nonatomic ,strong)YXHomeworkInfoFooterView *footerView;


@end

@implementation YXHomeworkInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.title = @"作业详情";
    [self setupUI];
    [self layoutInterface];
    [self requestForHomeworkInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (YXHomeworkInfoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YXHomeworkInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 336.0f)];
    }
    return _headerView;
}

- (YXHomeworkInfoFooterView *)footerView{
    if (!_footerView) {
        CGFloat footerHeight = MAX(kScreenHeight - 64.0f - 336.0f, 200.0f);
       _footerView = [[YXHomeworkInfoFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, footerHeight)];
        _footerView.Test = ^{
            
        };
    }
    return _footerView;
}

#pragma mark - setupUI
- (void)setupUI{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
}

- (void)layoutInterface{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - request
- (void)requestForHomeworkInfo{
    YXHomeworkInfoRequest *request = [[YXHomeworkInfoRequest alloc] init];
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXHomeworkInfoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            
        }else{
            YXHomeworkInfoRequestItem *item = retItem;
            if (item) {
                self ->_infoItem = item;
                [self showHomeworkInfoView];
            }
        }
    }];
    
    _infoRequest = request;
}

- (void)showHomeworkInfoView{
    _tableView.tableHeaderView = self.headerView;
    self.headerView.body = _infoItem.body;
    if (![_infoItem.body.type isEqualToString:@"1"]) {
       _tableView.tableFooterView = self.footerView;
    }
}
@end
