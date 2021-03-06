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
#import "YXCourseDetailViewController.h"
#import "YXModuleListRequest.h"
#import "YXCourseDetailPlayerViewController_17.h"
#import "CourseListFormatModel_17.h"
static  NSString *const trackPageName = @"看课记录页面";
@interface YXCourseRecordViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YXCourseRecordRequest *request;
@property (nonatomic, strong) YXCourseRecordRequestItem *recordItem;
@property (nonatomic, strong) YXModuleListRequest *moduleListRequest;
@property (nonatomic, copy) NSString *courseType;


@end

@implementation YXCourseRecordViewController

- (void)dealloc{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"看课记录";
    [self setupUI];
    [self getDataShowLoading:YES];
    [self setupObservers];
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

- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
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
        make.top.mas_equalTo(0);
    }];
    WEAK_SELF
    self.collectionView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        STRONG_SELF
        [self getDataShowLoading:NO];
    }];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -290, self.view.bounds.size.width, 360.0f)];
    topView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.collectionView.mj_header addSubview:topView];
    [self.collectionView.mj_header sendSubviewToBack:topView];
    
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self getDataShowLoading:YES];
    };
    self.emptyView = [[YXEmptyView alloc]init];
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.w.integerValue >= 3) {
        self.emptyView.title = @"您还没有开始看课";
        self.emptyView.imageName = @"没开始看课";
    }else{
        self.emptyView.title = @"您还没有选课";
        self.emptyView.subTitle = @"请您先在电脑登录研修网选课";
        self.emptyView.imageName = @"没选课";
    }
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self getDataShowLoading:YES];
    };
}

- (void)getDataShowLoading:(BOOL)isShow{
    [self.request stopRequest];
    self.request = [[YXCourseRecordRequest alloc]init];
    self.request.w = [LSTSharedInstance sharedInstance].trainManager.currentProject.w;
    self.request.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    if (isShow) {
        [self startLoading];
    }
    WEAK_SELF
    [self.request startRequestWithRetClass:[YXCourseRecordRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopLoading];
            [self.collectionView.mj_header endRefreshing];
            
            YXCourseRecordRequestItem *item = (YXCourseRecordRequestItem *)retItem;
            UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
            data.requestDataExist = item.body.modules.count != 0;
            data.localDataExist = NO;
            data.error = error;
            
            if ([self handleRequestData:data]) {
                return;
            }
            [self dealWithRecordItem:retItem];
        });
        
    }];
}

- (void)dealWithRecordItem:(YXCourseRecordRequestItem *)item{
    self.recordItem = item;
    [self.collectionView reloadData];
}

- (void)setupObservers{
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kRecordReportSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSString *course_id = noti.userInfo.allKeys.firstObject;
        NSString *record = noti.userInfo[course_id];
        [self.recordItem.body.modules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger moduleIndex = idx;
            YXCourseRecordRequestItem_body_module *module = (YXCourseRecordRequestItem_body_module *)obj;
            __block BOOL complete = NO;
            [module.courses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YXCourseRecordRequestItem_body_module_course *course = (YXCourseRecordRequestItem_body_module_course *)obj;
                if ([course.courses_id isEqualToString:course_id]) {
                    course.record = record;
                    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:moduleIndex]]];
                    complete = YES;
                    *stop = YES;
                }
            }];
            if (complete) {
                *stop = YES;
            }
        }];
    }];
}

#pragma mark - 查看更多
- (void)checkMoreWithModuleIndex:(NSInteger)index{
    YXCourseRecordRequestItem_body_module *module = self.recordItem.body.modules[index];
    [self.moduleListRequest stopRequest];
    self.moduleListRequest = [[YXModuleListRequest alloc]init];
    self.moduleListRequest.mid = module.module_id;
    self.moduleListRequest.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    self.moduleListRequest.w = [LSTSharedInstance sharedInstance].trainManager.currentProject.w;
    [self startLoading];
    WEAK_SELF
    [self.moduleListRequest startRequestWithRetClass:[YXModuleListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
            return;
        }
        YXModuleListRequestItem *item = (YXModuleListRequestItem *)retItem;
        [module.courses addObjectsFromArray:item.body.courses];
        module.more = @"false";
        [self.collectionView reloadData];
    }];
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
    if (indexPath.row % 2 == 0) {
        cell.isFirst = YES;
    }else{
        cell.isFirst = NO;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    YXCourseRecordRequestItem_body_module *module = self.recordItem.body.modules[indexPath.section];
    if (kind == UICollectionElementKindSectionHeader) {
        YXCourseRecordHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YXCourseRecordHeaderView" forIndexPath:indexPath];
        headerView.title = module.module_name;
        if ([module.module_name isEqualToString:@"本地课程阶段"]) {
            self.courseType = @"2";
        }else {
            self.courseType = nil;
        }
        return headerView;
    }else{
        YXCourseRecordFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"YXCourseRecordFooterView" forIndexPath:indexPath];
        WEAK_SELF
        footer.actionBlock = ^{
            STRONG_SELF
            [self checkMoreWithModuleIndex:indexPath.section];
        };
        return footer;
    }
}


#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(CGRectGetWidth(self.view.bounds), 50.f);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    YXCourseRecordRequestItem_body_module *module = self.recordItem.body.modules[section];
    if ([module.more isEqualToString:@"false"]) {
        return CGSizeZero;
    }
    return CGSizeMake(CGRectGetWidth(self.view.bounds), 44.f);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.view.bounds.size.width)/2, 195.f);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YXCourseRecordRequestItem_body_module *module = self.recordItem.body.modules[indexPath.section];
    YXCourseRecordRequestItem_body_module_course * course = module.courses[indexPath.row];
    course.courseType = self.courseType;
    YXCourseDetailPlayerViewController_17 *vc = [[YXCourseDetailPlayerViewController_17 alloc] init];
    vc.course =  [CourseListFormatModel_17 formatRecordModel:course];
    vc.fromWhere = VideoCourseFromWhere_Record;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
