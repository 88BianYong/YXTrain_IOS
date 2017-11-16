//
//  LSTCollectionFilterDefaultView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LSTCollectionFilterDefaultView.h"
#import "CollectionViewEqualSpaceFlowLayout.h"
#import "LSTCollectionFilterFooterView.h"
#import "LSTCollectionFilterHeaderView.h"
#import "LSTCollectionFilterCell.h"
@interface LSTCollectionFilterDefaultView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *chooseMutableArray;
@end
@implementation LSTCollectionFilterDefaultView
- (void)dealloc {
    DDLogDebug(@"release=======>>%@",NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.chooseMutableArray = [[NSMutableArray alloc] initWithCapacity:3];
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setFilterModel:(NSArray<LSTCollectionFilterDefaultModel *> *)filterModel{
    _filterModel = filterModel;
}
- (CGSize)collectionSize {
    return self.collectionView.contentSize;
}
#pragma mark - setupUI
- (void)setupUI {
    CollectionViewEqualSpaceFlowLayout *flowLayout = [[CollectionViewEqualSpaceFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 15.0f, 10.0f, 15.0f);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[LSTCollectionFilterCell class] forCellWithReuseIdentifier:@"LSTCollectionFilterCell"];
    [self.collectionView registerClass:[LSTCollectionFilterHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LSTCollectionFilterHeaderView"];
    [self.collectionView registerClass:[LSTCollectionFilterFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LSTCollectionFilterFooterView"];
    [self addSubview:self.collectionView];
}
- (void)setupLayout {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return[LSTCollectionFilterCell sizeForTitle:self.filterModel[indexPath.section].item[indexPath.row].name];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth , 28.0f);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == self.filterModel.count - 1) {
        return CGSizeMake(kScreenWidth , 54.0f);
    }else {
        return CGSizeZero;
    }
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.filterModel.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.filterModel[section].item.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LSTCollectionFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LSTCollectionFilterCell" forIndexPath:indexPath];
    cell.title = self.filterModel[indexPath.section].item[indexPath.row].name;
    cell.isCurrent = [self.filterModel[indexPath.section].userSelected integerValue] == indexPath.row;
    WEAK_SELF
    cell.courseFilterButtonActionBlock = ^{
        STRONG_SELF
        self.filterModel[indexPath.section].userSelected = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        [self reloadData];
    };
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        LSTCollectionFilterHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LSTCollectionFilterHeaderView" forIndexPath:indexPath];
        headerView.title = self.filterModel[indexPath.section].itemName;
        return headerView;
    }else if (kind == UICollectionElementKindSectionFooter){
        LSTCollectionFilterFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LSTCollectionFilterFooterView" forIndexPath:indexPath];
        WEAK_SELF
        footerView.courseFilterCompleteBlock = ^(BOOL isCancleBool) {
            STRONG_SELF
            if (isCancleBool) {
                BLOCK_EXEC(self.filterSelectedBlock,NO);
            }else {
                if ([self confirmUserSelected]) {
                    BLOCK_EXEC(self.filterSelectedBlock,YES);
                }else {
                    BLOCK_EXEC(self.filterSelectedBlock,NO);
                }
            }
        };
        return footerView;
    }
    return nil;
}
- (BOOL)confirmUserSelected {
    __block BOOL isChange = NO;
    [self.filterModel enumerateObjectsUsingBlock:^(LSTCollectionFilterDefaultModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.userSelected.integerValue != obj.defaultSelected.integerValue) {
            isChange = YES;
        }
        obj.defaultSelected = obj.userSelected;
        obj.userSelected = nil;
    }];
    return isChange;
}
#pragma mark - reload
- (void)reloadData {
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            self.frame = CGRectMake(0.0, 0.0f, kScreenWidth, self.collectionView.contentSize.height);
        }];
    });
}



@end
