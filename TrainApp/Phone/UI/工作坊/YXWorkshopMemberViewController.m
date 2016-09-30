//
//  YXWorkshopMemberViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopMemberViewController.h"
#import "YXWorkshopMemberCell.h"
#import "YXWorkshopMemberFetcher.h"
#import "MJRefresh.h"
static  NSString *const trackPageName = @"成员列表页面";
@interface YXWorkshopMemberViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>
{
    UICollectionView *_collectionView;
    YXWorkshopMemberFetcher *_memberFetcher;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    YXErrorView *_errorView;
    YXEmptyView *_emptyView;
    
    int _pageIndex;
    NSMutableArray *_dataMutableArray;
}
@end

@implementation YXWorkshopMemberViewController
- (void)dealloc
{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
    [_header free];
    [_footer free];
    [_memberFetcher stop];
}

- (void)viewDidLoad {    
    [super viewDidLoad];
    self.title = @"成员";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataMutableArray = [[NSMutableArray alloc] initWithArray:_cachMutableArray];
    [self setupUI];
    [self layoutInterface];
    if (_dataMutableArray.count == 0) {
        _pageIndex = 0;
        [self requestForWorkshopMember:_pageIndex withShowLoading:YES];
    }
    else{
        _pageIndex = 1;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Setting
- (void)setupUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 0.0f;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    [_collectionView registerClass:[YXWorkshopMemberCell class] forCellWithReuseIdentifier:@"YXWorkshopMemberCell"];
    [self.view addSubview:_collectionView];
    
    WEAK_SELF
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _collectionView;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.view.bounds.size.width, 360.0f)];
    topView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [_header addSubview:topView];
    [_header sendSubviewToBack:topView];
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        self->_pageIndex = 0;
        [self requestForWorkshopMember:self ->_pageIndex withShowLoading:NO];
    };
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _collectionView;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 360.0f)];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [_footer addSubview:bottomView];
    [_footer sendSubviewToBack:bottomView];
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
       STRONG_SELF
        [self requestForWorkshopMember:self ->_pageIndex withShowLoading:NO];
    };
    [self setPullupViewHidden:_hiddenPullupBool];
    
    _errorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
    _errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForWorkshopMember:self ->_pageIndex withShowLoading:NO];
    };
    _emptyView = [[YXEmptyView alloc]initWithFrame:self.view.bounds];
    _emptyView.title = @"暂无成员";
    _emptyView.imageName = @"无内容";
}

- (void)layoutInterface{
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        if (IS_IPHONE_6){
            make.left.equalTo(self.view.mas_left).offset(-0.5f);
            make.right.equalTo(self.view.mas_right).offset(0.5f);
        }
        else{
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
        }
    }];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataMutableArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YXWorkshopMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXWorkshopMemberCell" forIndexPath:indexPath];
    YXWorkshopMemberRequestItem_memberList *list = _dataMutableArray[indexPath.row];
    cell.list = list;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat widthFloat = self.view.bounds.size.width/4.0f;
    if (IS_IPHONE_6) {//像素点不能整除有黑条
        widthFloat = (self.view.bounds.size.width + 1.0f)/4.0f;
    }else if (IS_IPHONE_6P){
       widthFloat = self.view.bounds.size.width/5.0f;
    }else{
        widthFloat = self.view.bounds.size.width/4.0f;
    }
    return CGSizeMake(widthFloat, 100.0f);
}

#pragma mark - request
- (void)requestForWorkshopMember:(int)pageIndex withShowLoading:(BOOL)isShow{
    if (!_memberFetcher) {
        _memberFetcher = [[YXWorkshopMemberFetcher alloc] init];
    }
    _memberFetcher.pageindex = pageIndex;
    _memberFetcher.barid = self.baridString;
    _memberFetcher.pagesize = 40;
    if (isShow) {
        [self startLoading];
    }
    WEAK_SELF
    [_memberFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        STRONG_SELF
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_footer endRefreshing];
            [self->_header endRefreshing];
        });
        [self stopLoading];
        if (pageIndex == 0) {//首次添加 如果错误添加错误界面如果空添加空界面
            if (error) {
                self ->_errorView.frame = self.view.bounds;
                [self.view addSubview:self ->_errorView];
            }
            else{
                [self setExceptionViewAndData:retItemArray withPageIndex:pageIndex];
                [self setPullupViewHidden:self ->_dataMutableArray.count >= total];
            }
        }else{//加载更多错误弹出提示
            if (error) {
               [self showToast:error.localizedDescription];
            }
            else{
                [self setExceptionViewAndData:retItemArray withPageIndex:pageIndex];
                [self setPullupViewHidden:self ->_dataMutableArray.count >= total];
            }
        }
    }];
}

- (void)setPullupViewHidden:(BOOL)hidden
{
    _footer.alpha = hidden ? 0:1;
}

- (void)setExceptionViewAndData:(NSArray *)retItemArray withPageIndex:(int)pageIndex{
    if (pageIndex == 0) {
        if (retItemArray.count > 0) {
            _pageIndex ++;
            [self.cachMutableArray removeAllObjects];
            [self.cachMutableArray addObjectsFromArray:retItemArray];
            [_dataMutableArray removeAllObjects];
            [_dataMutableArray addObjectsFromArray:retItemArray];
            
            [_collectionView reloadData];
            [_emptyView removeFromSuperview];
            [_errorView removeFromSuperview];
        }
        else{
            self ->_emptyView.frame = self.view.bounds;
            [self.view addSubview:self ->_emptyView];
        }
    }
    else{
        if (retItemArray.count > 0) {
            _pageIndex ++ ;
            [self ->_dataMutableArray addObjectsFromArray:retItemArray];
            [self ->_collectionView reloadData];
        }
    }
}
@end
