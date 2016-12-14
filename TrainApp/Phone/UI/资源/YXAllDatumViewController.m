//
//  YXAllDatumViewController.m
//  TrainApp
//
//  Created by 李五民 on 16/6/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXAllDatumViewController.h"
#import "YXDatumOrderFilterMenuView.h"
#import "YXDatumOrderModel.h"
#import "YXDatumOrderView.h"
#import "YXWholeDatumFetcher.h"
#import "YXAllDatumTableViewCell.h"
#import "YXAttachmentTypeHelper.h"
#import "YXResourceCollectionRequest.h"
#import "YXPagedListEmptyView.h"
static  NSString *const trackPageName = @"全部资源页面";
@interface YXAllDatumViewController ()

@property (nonatomic, strong) YXDatumOrderFilterMenuView *menuView;

@property (nonatomic, strong) YXWholeDatumFetcher *wholeDatumFetcher;

@property (nonatomic, strong) YXResourceCollectionRequest *collectionRequest;

@property (nonatomic, copy) NSString *currentConditon;//错误刷新用到
@property (nonatomic, strong) YXFileItemBase *fileItem;

@end

@implementation YXAllDatumViewController

- (void)viewDidLoad {
    //self.bIsGroupedTableViewStyle = YES;
    [self setupDataFetcher];
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    self.tableView.showsVerticalScrollIndicator = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    self.tableView.showsVerticalScrollIndicator = NO;
}
- (void)configUI {
    self.emptyView.imageName = @"暂无资源";
    self.emptyView.title = @"没有符合条件的资源";

    self.view.backgroundColor = [UIColor whiteColor];
    self.menuView = [[YXDatumOrderFilterMenuView alloc]initWithFrame:CGRectZero];
     @weakify(self);
    self.menuView.refreshFilterBlock = ^(NSString *condition) {
        @strongify(self);
        self.currentConditon = condition;
        [self.tableView setContentOffset:CGPointZero];
        [self firstPageFetch];
    };
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.view.mas_top).offset(0.0f);
        
    }];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.estimatedRowHeight = 800;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXAllDatumTableViewCell class] forCellReuseIdentifier:@"YXAllDatumTableViewCell"];
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.menuView.mas_bottom);
        
    }];
    
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5)];
    tableViewHeaderView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.tableHeaderView = tableViewHeaderView;
}

- (void)firstPageFetch {
    self.wholeDatumFetcher.condition = self.currentConditon;
    [super firstPageFetch:YES];
}

- (void)setupDataFetcher{
    self.wholeDatumFetcher = [[YXWholeDatumFetcher alloc]init];
    self.wholeDatumFetcher.pagesize = 20;
    NSDictionary *dic = @{@"interf":@"SearchFilter",@"source":@"ios"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (error) {
        self.wholeDatumFetcher.condition = nil;
        self.currentConditon = nil;
    } else {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        self.wholeDatumFetcher.condition = jsonString;
        self.currentConditon = jsonString;
    }
    self.dataFetcher = self.wholeDatumFetcher;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXAllDatumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXAllDatumTableViewCell" forIndexPath:indexPath];
    YXDatumCellModel *model = self.dataArray[indexPath.row];
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
            [YXDataStatisticsManger trackEvent:@"资源" label:@"收藏资源" parameters:nil];
            [self.tableView reloadData];
        }];
    }
    [fileItem browseFile];
    self.fileItem = fileItem;
    [YXDataStatisticsManger trackEvent:@"资源" label:@"预览资源" parameters:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentSize.height >= kScreenHeight -  45 + 10.0f){
        CGPoint point = scrollView.contentOffset;
        if (point.y >= 5) {
            self.menuView.isNavBarHidden = YES;
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(45);
                make.top.equalTo(self.view.mas_top).offset(20.0f);
            }];
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(self.menuView.mas_bottom);
            }];
        }else{
            self.menuView.isNavBarHidden = NO;
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(45);
                make.top.equalTo(self.view.mas_top).offset(0.0f);
            }];
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(self.menuView.mas_bottom);
            }];
        }
    }else{
        self.menuView.isNavBarHidden = NO;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(45);
            make.top.equalTo(self.view.mas_top);
        }];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.menuView.mas_bottom);
        }];
    }
}

@end
