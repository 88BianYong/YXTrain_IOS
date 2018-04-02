//
//  YXWorkshopDatumViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopDatumViewController.h"
#import "YXWorkshopDatumFetch.h"
#import "YXPagedListEmptyView.h"
#import "YXAllDatumTableViewCell.h"
#import "YXAttachmentTypeHelper.h"
static  NSString *const trackPageName = @"工作坊资源列表页面";
@interface YXWorkshopDatumViewController ()
{
    YXWorkshopDatumFetch *_datumFetch;
}
@property (nonatomic, strong) YXFileItemBase *fileItem;
@end

@implementation YXWorkshopDatumViewController

- (void)viewDidLoad {
    YXWorkshopDatumFetch *fetcher = [[YXWorkshopDatumFetch alloc] init];
    fetcher.barid = self.baridString;
    fetcher.pagesize = 10; // 保证至少够一UI页的数据
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.title = @"资源";
    [self setupUI];
    [self layoutInterface];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Setting
- (void)setupUI{
    self.emptyView.title = @"暂无资源";
    self.emptyView.imageName = @"暂无资源";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.estimatedRowHeight = 800;
    self.tableView.estimatedSectionFooterHeight = 0.0f;
    self.tableView.estimatedSectionHeaderHeight = 5.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXAllDatumTableViewCell class] forCellReuseIdentifier:@"YXAllDatumTableViewCell"];
}

- (void)layoutInterface{
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXAllDatumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXAllDatumTableViewCell" forIndexPath:indexPath];
    YXDatumCellModel *model = self.dataArray[indexPath.row];
    if (indexPath.row == self.dataArray.count - 1) {
        [cell hiddenBottomView:YES];
    } else {
        [cell hiddenBottomView:NO];
    }
    cell.cellModel = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"YXAllDatumTableViewCell" configuration:^(YXAllDatumTableViewCell *cell) {
        cell.cellModel = self.dataArray[indexPath.row];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXDatumCellModel *data = self.dataArray[indexPath.row];
    YXFileType type = [YXAttachmentTypeHelper fileTypeWithTypeName:data.type];
    if(type == YXFileTypeUnknown) {
        [self showToast:@"暂不支持该格式文件预览"];
        return;
    }
    YXFileItemBase *fileItem = [FileBrowserFactory browserWithFileType:type];
    fileItem.name = data.title;
    fileItem.url = data.url;
    fileItem.baseViewController = self;
    if (!data.isFavor) {
        [fileItem addFavorWithData:data completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:YXFavorSuccessNotification object:data userInfo:nil];
            [YXDataStatisticsManger trackEvent:@"工作坊资源" label:@"收藏工作坊资源" parameters:nil];
            [self.tableView reloadData];
        }];
    }
    [fileItem browseFile];
    self.fileItem = fileItem;
    [YXDataStatisticsManger trackEvent:@"工作坊资源" label:@"预览工作坊资源" parameters:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
@end
