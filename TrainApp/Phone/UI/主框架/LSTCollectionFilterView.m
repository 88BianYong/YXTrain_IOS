//
//  LSTCollectionFilterView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/9/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LSTCollectionFilterView.h"
#import "CollectionViewEqualSpaceFlowLayout.h"
#import "LSTCollectionFilterFooterView.h"
#import "LSTCollectionFilterHeaderView.h"
#import "LSTCollectionFilterCell.h"
@interface LSTCollectionFilterView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end
@implementation LSTCollectionFilterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self setupMock];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setFilterModel:(LSTCollectionFilterModel *)filterModel {
    _filterModel = filterModel;
}
- (CGSize)collectionSize {
    return self.collectionView.contentSize;
}
#pragma mark - setupUI
- (void)setupMock {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"collectionFilter_mock" ofType:@"json"];
    NSString *string = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    LSTCollectionFilterModel *model = [[LSTCollectionFilterModel alloc] initWithString:string error:nil];
    model.itemName.defaultSelected = @"0";
    model.itemName.defaultSelectedID = @"2";
    LSTCollectionFilterModel_ItemName *item = model.itemName.itemName;
    item.defaultSelected = @"1";
    item.defaultSelectedID = @"5";
    LSTCollectionFilterModel_ItemName *test = item.itemName;
    test.defaultSelected = @"2";
    test.defaultSelectedID = @"35";
    self.filterModel = model;
}
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
    return[LSTCollectionFilterCell sizeForTitle:[self rowFilterItems:self.filterModel.item withFilterName:self.filterModel.itemName withStart:0 withEnd:indexPath].name];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth , 28.0f);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == ([self numberFilterItems:self.filterModel.item withFilterName:self.filterModel.itemName withStart:0] - 1)) {
        return CGSizeMake(kScreenWidth , 20.0f + 29.0f + 20.0f);
    }else {
        return CGSizeZero;
    }
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self numberFilterItems:self.filterModel.item withFilterName:self.filterModel.itemName withStart:0];
}
- (NSInteger)numberFilterItems:(NSMutableArray *)items
                withFilterName:(LSTCollectionFilterModel_ItemName *)itemName
                     withStart:(NSInteger)number{
    if (items.count > 0) {
        if (itemName.userSelected.integerValue >= 0) {
            LSTCollectionFilterModel_Item *item = items[itemName.userSelected.integerValue];
            number = [self numberFilterItems:item.item withFilterName:itemName.itemName withStart:number + 1];
        }else {
            number = [self numberFilterItems:nil withFilterName:itemName.itemName withStart:number + 1];
        }
    }
    return number;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self sectionFilterItems:self.filterModel.item withFilterName:self.filterModel.itemName withStart:0 withEnd:section];
}

- (NSInteger)sectionFilterItems:(NSMutableArray *)items
                      withFilterName:(LSTCollectionFilterModel_ItemName *)itemName
                      withStart:(NSInteger)number
                        withEnd:(NSInteger)section {
    if (number == section) {
        return items.count;
    }else {
        LSTCollectionFilterModel_Item *item = items[itemName.userSelected.integerValue];
        return [self sectionFilterItems:item.item withFilterName:itemName.itemName withStart:number + 1 withEnd:section];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LSTCollectionFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LSTCollectionFilterCell" forIndexPath:indexPath];
    cell.title = [self rowFilterItems:self.filterModel.item withFilterName:self.filterModel.itemName withStart:0 withEnd:indexPath].name;
    cell.isCurrent = indexPath.row == [self currentSelectedFilter:self.filterModel.itemName withStart:0 withEnd:indexPath];
    WEAK_SELF
    cell.courseFilterButtonActionBlock = ^{
        STRONG_SELF
        [self userChangeSelectedFilterItems:self.filterModel.item withFilterName:self.filterModel.itemName withStart:0 withEnd:indexPath];
        [self reloadData];
    };
    return cell;
}
- (void)userChangeSelectedFilterItems:(NSMutableArray *)items
                                  withFilterName:(LSTCollectionFilterModel_ItemName *)itemName
                                       withStart:(NSInteger)number
                                         withEnd:(NSIndexPath *)indexPath{
    if (items.count == 0) {
        itemName.userSelected = nil;
        itemName.userSelectedID = nil;
        return;
    }
    if (indexPath.section > number) {
        LSTCollectionFilterModel_Item *item = items[itemName.userSelected.integerValue];
        [self userChangeSelectedFilterItems:item.item withFilterName:itemName.itemName withStart:number + 1 withEnd:indexPath];
    }else if (indexPath.section == number) {
        LSTCollectionFilterModel_Item *item = items[indexPath.row];
        itemName.userSelected = [NSString stringWithFormat:@"%ld",indexPath.row];
        itemName.userSelectedID = item.itemID;
        [self userChangeSelectedFilterItems:item.item withFilterName:itemName.itemName withStart:number + 1 withEnd:indexPath];
    }else {
        [items enumerateObjectsUsingBlock:^(LSTCollectionFilterModel_Item *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.itemID.integerValue == itemName.userSelectedID.integerValue) {
                itemName.userSelected = [NSString stringWithFormat:@"%ld",idx];
               [self userChangeSelectedFilterItems:obj.item withFilterName:itemName.itemName withStart:number + 1 withEnd:indexPath];
                *stop = YES;
                return ;
            }
            if (idx == items.count - 1) {
                itemName.userSelected = @"0";
                LSTCollectionFilterModel_Item *item = items[0];
                itemName.userSelectedID = item.itemID;
            }
        }];
    }
    
}
- (LSTCollectionFilterModel_Item *)rowFilterItems:(NSMutableArray *)items
                                   withFilterName:(LSTCollectionFilterModel_ItemName *)itemName
                                        withStart:(NSInteger)number
                                          withEnd:(NSIndexPath *)indexPath {
    if (number == indexPath.section) {
        return items[indexPath.row];
    }else {
        LSTCollectionFilterModel_Item *item = items[itemName.userSelected.integerValue];
        return [self rowFilterItems:item.item withFilterName:itemName.itemName withStart:number + 1 withEnd:indexPath];
    }
}
- (NSInteger)currentSelectedFilter:(LSTCollectionFilterModel_ItemName *)itemName
                     withStart:(NSInteger)number
                       withEnd:(NSIndexPath *)indexPath {
    if (number == indexPath.section) {
        return itemName.userSelected.integerValue;
    }else {
        return [self currentSelectedFilter:itemName.itemName withStart:number + 1 withEnd:indexPath];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        LSTCollectionFilterHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LSTCollectionFilterHeaderView" forIndexPath:indexPath];
         headerView.title = [self sectionFilterName:self.filterModel.itemName withEnd:indexPath.section];
        return headerView;
    }else if (kind == UICollectionElementKindSectionFooter){
        LSTCollectionFilterFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"LSTCollectionFilterFooterView" forIndexPath:indexPath];
        WEAK_SELF
        footerView.courseFilterCompleteBlock = ^(BOOL isCancleBool) {
            STRONG_SELF
            if (isCancleBool) {
                [self cancleUserSelected:self.filterModel.itemName];
                BLOCK_EXEC(self.filterSelectedBlock,nil);
            }else {
                if ([self confirmUserSelected:self.filterModel.itemName withUserChange:NO]) {
                    BLOCK_EXEC(self.filterSelectedBlock,self.filterModel.itemName);
                }else {
                    BLOCK_EXEC(self.filterSelectedBlock,nil);
                }
            }
            [self.collectionView reloadData];
        };
        return footerView;
    }
    return nil;
}
- (void)cancleUserSelected:(LSTCollectionFilterModel_ItemName *)itemName {
    if (itemName != nil) {
        itemName.userSelected = nil;
        itemName.userSelectedID = nil;
        [self cancleUserSelected:itemName.itemName];
    }
}
- (BOOL)confirmUserSelected:(LSTCollectionFilterModel_ItemName *)itemName withUserChange:(BOOL)isChange{
    if (itemName != nil) {
        if (itemName.defaultSelected.integerValue != itemName.userSelected.integerValue || itemName.defaultSelectedID.integerValue != itemName.userSelectedID.integerValue) {
            itemName.defaultSelected = itemName.userSelected;
            itemName.defaultSelectedID = itemName.userSelectedID;
            isChange = YES;
        }
        itemName.userSelected = nil;
        itemName.userSelectedID = nil;
        return [self confirmUserSelected:itemName.itemName withUserChange:isChange];
    }else {
        return isChange;
    }
}

- (NSString *)sectionFilterName:(LSTCollectionFilterModel_ItemName *)itemName withEnd:(NSInteger)section {
    if (section == 0) {
        return itemName.name;
    }else {
        return [self sectionFilterName:itemName.itemName withEnd:section - 1];
    }
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
