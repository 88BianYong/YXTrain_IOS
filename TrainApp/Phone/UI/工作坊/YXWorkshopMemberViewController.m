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
#define IS_IPHONE_6P ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
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
    
    int _pageIndex;
    NSMutableArray *_dataMutableArray;
}
@property (nonatomic ,assign) NSInteger fillInteger;
@end

@implementation YXWorkshopMemberViewController
- (void)dealloc
{
    [_header free];
    [_footer free];
    [_memberFetcher stop];
}

- (void)viewDidLoad {    
    [super viewDidLoad];
    self.title = @"成员";
    _dataMutableArray = [[NSMutableArray alloc] initWithArray:_cachMutableArray];
    [self setupUI];
    [self layoutInterface];
    if (_dataMutableArray.count == 0) {
        _pageIndex = 0;
        [self requestForWorkshopMember:_pageIndex];
    }
    else{
        _pageIndex = 1;
    }
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
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[YXWorkshopMemberCell class] forCellWithReuseIdentifier:@"YXWorkshopMemberCell"];
    [self.view addSubview:_collectionView];
    
    WEAK_SELF
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _collectionView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        self->_pageIndex = 0;
        [self requestForWorkshopMember:self ->_pageIndex];
    };
    
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _collectionView;
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
       STRONG_SELF
        [self requestForWorkshopMember:self ->_pageIndex];
    };    
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
- (void)requestForWorkshopMember:(int)pageIndex{
    if (!_memberFetcher) {
        _memberFetcher = [[YXWorkshopMemberFetcher alloc] init];
    }
    _memberFetcher.pageindex = pageIndex;
    _memberFetcher.barid = self.baridString;
    _memberFetcher.pagesize = 40;
    [self startLoading];
    WEAK_SELF
    [_memberFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        STRONG_SELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_footer endRefreshing];
            [self->_header endRefreshing];
        });//多次加载

        [self stopLoading];
        if (pageIndex == 0) {
            [self.cachMutableArray removeAllObjects];
            [self.cachMutableArray addObjectsFromArray:retItemArray];
            
            [self ->_dataMutableArray removeAllObjects];
        }
        if (!error && retItemArray) {
            _pageIndex ++ ;
            [self ->_dataMutableArray addObjectsFromArray:retItemArray];
            [self ->_collectionView reloadData];
        }
        else if(error){
            [self showToast:error.localizedDescription];
        }
    }];
}
//- (void)reloadCollectionView{
//    if (self.dataMutableArray.count > 0){
//        if (IS_IPHONE_6P) {
//            
//            
//            //5 - self.dataMutableArray.count%5 =
//        }
//        
//        
//            [_collectionView reloadData];
//        
//        
//    }
//
//    
//    
//
//}
//- (void)setFillInteger:(NSInteger)fillInteger{
//    _fillInteger = fillInteger;
//    if (<#condition#>) {
//        <#statements#>
//    }
//}
@end
