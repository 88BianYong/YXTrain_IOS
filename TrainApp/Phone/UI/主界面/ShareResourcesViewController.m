//
//  ShareResourcesViewController.m
//  TrainApp
//
//  Created by ZLL on 2016/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ShareResourcesViewController.h"
#import "ActivityListRequest.h"
#import "ShareResourcesRequest.h"
#import "YXWholeDatumFetcher.h"
#import "ShareResourcesTableViewCell.h"
#import "ShareResourcesFetcher.h"
#import "YXDatumCellModel.h"
#import "CommentPageListViewController.h"
@interface ShareResourcesViewController ()
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation ShareResourcesViewController
- (void)viewDidLoad {
    [self setupDataFetcher];
    YXEmptyView *emptyView = [[YXEmptyView alloc]init];
    emptyView.imageName = @"暂无资源";
    emptyView.title = @"没有符合条件的资源";
    self.emptyView = emptyView;
    [super viewDidLoad];
    self.title = @"资源分享";
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.showsVerticalScrollIndicator = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.showsVerticalScrollIndicator = NO;
}
- (void)setupDataFetcher {
    ShareResourcesFetcher *fetcher = [[ShareResourcesFetcher alloc]init];
    fetcher.aid = self.tool.aid;
    fetcher.toolId = self.tool.toolid;
    fetcher.pageindex = 0;
    fetcher.pagesize = 20;
    self.dataFetcher = fetcher;
}
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBottomView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.estimatedRowHeight = 800;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ShareResourcesTableViewCell class] forCellReuseIdentifier:@"ShareResourcesTableViewCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(self.bottomView.mas_top);
        make.top.mas_equalTo(0);
        
    }];
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5)];
    tableViewHeaderView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.tableHeaderView = tableViewHeaderView;
    [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top);
        make.left.right.top.mas_equalTo(0);
    }];
    [self.errorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top);
        make.left.right.top.mas_equalTo(0);
    }];
    [self.dataErrorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top);
        make.left.right.top.mas_equalTo(0);
    }];
}
- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"f2f4f7"];
    self.bottomView = bottomView;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"d0d2d5"];
    
    UIButton *viewCommentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    viewCommentsButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [viewCommentsButton setTitle:@"查看评论" forState:UIControlStateNormal];
    [viewCommentsButton setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    [viewCommentsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [viewCommentsButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
    viewCommentsButton.layer.cornerRadius = 2.0f;
    viewCommentsButton.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;
    viewCommentsButton.layer.borderWidth = 1;
    viewCommentsButton.layer.masksToBounds = YES;
    [viewCommentsButton addTarget:self action:@selector(viewCommentsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:lineView];
    [self.bottomView addSubview:viewCommentsButton];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bottomView);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    [viewCommentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomView);
        make.size.mas_equalTo(CGSizeMake(170, 32));
    }];
}
- (void)viewCommentsButtonAction:(UIButton *)sender {
    DDLogDebug(@"查看评论");
    CommentPageListViewController *commentVc = [[CommentPageListViewController alloc]init];
    commentVc.tool = self.tool;
    commentVc.status = self.status;
    [self.navigationController pushViewController:commentVc animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShareResourcesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareResourcesTableViewCell" forIndexPath:indexPath];
    YXDatumCellModel *model = self.dataArray[indexPath.row];
    cell.cellModel = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"ShareResourcesTableViewCell" configuration:^(ShareResourcesTableViewCell *cell) {
        cell.cellModel = self.dataArray[indexPath.row];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXDatumCellModel *data = self.dataArray[indexPath.row];
    YXFileVideoItem *item = [[YXFileVideoItem alloc]init];
    item.name = data.title;
    item.url = data.previewUrl;
    item.type = [YXAttachmentTypeHelper fileTypeWithTypeName:data.type];
    if(item.type == YXFileTypeUnknown) {
        [self showToast:@"暂不支持该格式文件预览"];
        return;
    }
    if (!data.isFavor) {
        [[YXFileBrowseManager sharedManager]addFavorWithData:data completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:YXFavorSuccessNotification object:data userInfo:nil];
            [self.tableView reloadData];
        }];
    }
    [YXFileBrowseManager sharedManager].fileItem = item;
    [YXFileBrowseManager sharedManager].baseViewController = self;
    [[YXFileBrowseManager sharedManager] browseFile];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
