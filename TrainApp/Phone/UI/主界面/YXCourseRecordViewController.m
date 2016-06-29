//
//  YXCourseRecordViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseRecordViewController.h"
#import "YXCourseRecordCell.h"
#import "YXCourseRecordHeaderView.h"
#import "YXCourseRecordRequest.h"
#import "YXCourseRecordFooterView.h"
#import "MJRefresh.h"
#import "YXCourseDetailViewController.h"

@interface YXCourseRecordViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YXCourseRecordRequest *request;
@property (nonatomic, strong) YXCourseRecordRequestItem *recordItem;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@end

@implementation YXCourseRecordViewController

- (void)dealloc{
    [self.header free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"看课记录";
    [self setupUI];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[YXCourseRecordCell class] forCellWithReuseIdentifier:@"YXCourseRecordCell"];
    [self.collectionView registerClass:[YXCourseRecordHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YXCourseRecordHeaderView"];
    [self.collectionView registerClass:[YXCourseRecordFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"YXCourseRecordFooterView"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(6);
    }];
    
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.collectionView;
    WEAK_SELF
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self getData];
    };
}

- (void)getData{
    [self.request stopRequest];
    self.request = [[YXCourseRecordRequest alloc]init];
    [self startLoading];
    WEAK_SELF
    [self.request startRequestWithRetClass:[YXCourseRecordRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        [self.header endRefreshing];
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
        [self dealWithRecordItem:retItem];
    }];
}

- (void)dealWithRecordItem:(YXCourseRecordRequestItem *)item{
    self.recordItem = item;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.recordItem.body.modules.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    YXCourseRecordRequestItem_body_module *module = self.recordItem.body.modules[section];
    return module.courses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YXCourseRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXCourseRecordCell" forIndexPath:indexPath];
    YXCourseRecordRequestItem_body_module *module = self.recordItem.body.modules[indexPath.section];
    cell.course = module.courses[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        YXCourseRecordHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YXCourseRecordHeaderView" forIndexPath:indexPath];
        YXCourseRecordRequestItem_body_module *module = self.recordItem.body.modules[indexPath.section];
        headerView.title = module.module_name;
        return headerView;
    }else{
        YXCourseRecordFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"YXCourseRecordFooterView" forIndexPath:indexPath];
        return footer;
    }
}


#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(CGRectGetWidth(self.view.bounds), 45.f);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(CGRectGetWidth(self.view.bounds), 5.f);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.view.bounds.size.width-30-11)/2, 195.f);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YXCourseRecordRequestItem_body_module *module = self.recordItem.body.modules[indexPath.section];
    YXCourseDetailViewController *vc = [[YXCourseDetailViewController alloc]init];
    vc.course = module.courses[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
