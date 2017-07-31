//
//  ActivityListFilterView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ActivityListFilterView_17.h"
#import "ActivityFilterCell_17.h"
#import "ActivityFilterHeaderView_17.h"
#import "ActivityFilterFooterView_17.h"
#import "CollectionViewEqualSpaceFlowLayout.h"
@interface ActivityListFilterView_17 ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UILabel *segmentNameLabel;
@property (nonatomic, strong) UILabel *segmentContentLabel;
@property (nonatomic, strong) UILabel *studyNameLabel;
@property (nonatomic, strong) UILabel *studyContentLabel;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *selectedMutableArray;
@end
@implementation ActivityListFilterView_17
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
        self.selectedMutableArray = [[NSMutableArray alloc] initWithCapacity:2];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - set
- (void)setFilterModel:(ActivityFilterModel *)filterModel {
    _filterModel = filterModel;
    [self.selectedMutableArray removeAllObjects];
    [self.selectedMutableArray addObjectsFromArray:self.filterModel.selectedMutableArray];
    [self setupActivityFilterContent];
}
- (NSMutableArray *)setupActivityFilterContent {
    ActivityFilterGroup *segment = self.filterModel.groupArray[1];
    NSInteger segmentInteger = [self.filterModel.selectedMutableArray[0] integerValue];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:2];
    if (segmentInteger >= 0) {
        self.segmentContentLabel.text = ((ActivityFilter *)segment.filterArray[segmentInteger]).name;
        [mutableArray addObject:((ActivityFilter *)segment.filterArray[segmentInteger]).filterID];
    }else {
        self.segmentContentLabel.text = @"请选择";
        [mutableArray addObject:@"0"];
    }
    NSInteger studyInteger = [self.filterModel.selectedMutableArray[1] integerValue];
    ActivityFilterGroup *study = self.filterModel.groupArray[2];
    if (studyInteger >= 0) {
        self.studyContentLabel.text = ((ActivityFilter *)study.filterArray[studyInteger]).name;
          [mutableArray addObject:((ActivityFilter *)study.filterArray[studyInteger]).filterID];
    }else {
        self.studyContentLabel.text = @"请选择";
        [mutableArray addObject:@"0"];
    }
    return mutableArray;
}
#pragma mark - setupUI
- (void)setupUI {
    self.segmentNameLabel = [[UILabel alloc] init];
    self.segmentNameLabel.text = @"学段: ";
    self.segmentNameLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.segmentNameLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.segmentNameLabel];
    self.segmentContentLabel = [[UILabel alloc] init];
    self.segmentContentLabel.text = @"初中";
    self.segmentContentLabel.textColor = [UIColor colorWithHexString:@"505f84"];
    self.segmentContentLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.segmentContentLabel];
    
    self.studyNameLabel = [[UILabel alloc] init];
    self.studyNameLabel.text = @"学科: ";
    self.studyNameLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    self.studyNameLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.studyNameLabel];
    self.studyContentLabel = [[UILabel alloc] init];
    self.studyContentLabel.text = @"数学";
    self.studyContentLabel.textColor = [UIColor colorWithHexString:@"505f84"];
    self.studyContentLabel.font = [UIFont systemFontOfSize:11.0f];
    [self addSubview:self.studyContentLabel];
    
    self.filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.filterButton setTitleColor:[UIColor colorWithHexString:@"505f84"] forState:UIControlStateNormal];
    WEAK_SELF
    [[self.filterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self showFilterSelectionView];
    }];
    [self.filterButton setTitle:@"筛选" forState:UIControlStateNormal];
    [self.filterButton.titleLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
    [self addSubview:self.filterButton];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.backgroundColor = [UIColor redColor];
    [self addSubview:self.imageView];
    
    
    self.maskView = [[UIView alloc]init];
    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [[tapGestureRecognizer rac_gestureSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self.selectedMutableArray removeAllObjects];
        [self.selectedMutableArray addObjectsFromArray:self.filterModel.selectedMutableArray];
        [self hideFilterSelectionView];
    }];
    [self.maskView addGestureRecognizer:tapGestureRecognizer];
    
    CollectionViewEqualSpaceFlowLayout *flowLayout = [[CollectionViewEqualSpaceFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 7;
    flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 28.0f);
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[ActivityFilterCell_17 class] forCellWithReuseIdentifier:@"ActivityFilterCell_17"];
    [self.collectionView registerClass:[ActivityFilterHeaderView_17 class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ActivityFilterHeaderView_17"];
    [self.collectionView registerClass:[ActivityFilterFooterView_17 class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ActivityFilterFooterView_17"];
    [self.maskView addSubview:self.collectionView];
}
- (void)setupLayout {
    [self.segmentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15.0f);
    }];
    [self.segmentContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.segmentNameLabel.mas_right);
    }];
    
    [self.studyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.segmentContentLabel.mas_right).offset(27.0f);
    }];
    [self.studyContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.studyNameLabel.mas_right);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10.0f);
        make.size.mas_offset(CGSizeMake(10.0f, 10.0f));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imageView.mas_left).offset(-10.0f);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_offset(CGSizeMake(23.0f, 30.0f));
    }];
}
#pragma mark - Show & Hide
- (void)showFilterSelectionView{
    UIView *superview = self.superview;
    self.maskView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [superview addSubview:self.maskView];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, 0.0f);
    [self reloadData];
}

- (void)hideFilterSelectionView{
    [UIView animateWithDuration:0.25f animations:^{
        self.collectionView.frame = CGRectMake(0.0f, 0.0f, self.collectionView.contentSize.width, 0.0f);
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
    }];
}
- (void)reloadData {
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            self.collectionView.frame = CGRectMake(0.0f, 0.0f, self.collectionView.contentSize.width, self.collectionView.contentSize.height);
        }];
    });
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        ActivityFilterGroup *segment = self.filterModel.groupArray[1];
        return segment.filterArray.count;
    }else {
        ActivityFilterGroup *study = self.filterModel.groupArray[2];
        return study.filterArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ActivityFilterCell_17 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityFilterCell_17" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        ActivityFilterGroup *segment = self.filterModel.groupArray[1];
        cell.title = ((ActivityFilter *)segment.filterArray[indexPath.row]).name;
        cell.isCurrent = indexPath.row == [self.selectedMutableArray[0] integerValue];
    }else {
        ActivityFilterGroup *study = self.filterModel.groupArray[2];
        cell.title = ((ActivityFilter *)study.filterArray[indexPath.row]).name;
        cell.isCurrent = indexPath.row == [self.selectedMutableArray[1] integerValue];
    }
    WEAK_SELF
    cell.activityFilterButtonActionBlock = ^{
        STRONG_SELF
        self.selectedMutableArray[indexPath.section] = @(indexPath.row);
        [self reloadData];
    };
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        ActivityFilterHeaderView_17 *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ActivityFilterHeaderView_17" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.title = @"学段";
        }else {
            headerView.title = @"学科";
        }
        return headerView;
    }else if (kind == UICollectionElementKindSectionFooter && indexPath.section == 1){
        ActivityFilterFooterView_17 *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ActivityFilterFooterView_17" forIndexPath:indexPath];
        WEAK_SELF
        footerView.activitFilterCompleteBlock = ^(BOOL isCancleBool) {
            STRONG_SELF
            if (isCancleBool) {
                [self.selectedMutableArray removeAllObjects];
                [self.selectedMutableArray addObjectsFromArray:self.filterModel.selectedMutableArray];
            }else {
                if ([self.selectedMutableArray[0] integerValue] != [self.filterModel.selectedMutableArray[0] integerValue] || [self.selectedMutableArray[1] integerValue] != [self.filterModel.selectedMutableArray[1] integerValue]) {
                    [self.filterModel.selectedMutableArray removeAllObjects];
                    [self.filterModel.selectedMutableArray addObjectsFromArray:self.selectedMutableArray];
                    BLOCK_EXEC(self.activityListFilterSelectedBlock,[self setupActivityFilterContent]);
                }
            }
            [self hideFilterSelectionView];
        };
        return footerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ActivityFilterGroup *segment = self.filterModel.groupArray[1];
        return [ActivityFilterCell_17 sizeForTitle:((ActivityFilter *)segment.filterArray[indexPath.row]).name];
    }else {
        ActivityFilterGroup *study = self.filterModel.groupArray[2];
        return [ActivityFilterCell_17 sizeForTitle:((ActivityFilter *)study.filterArray[indexPath.row]).name];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(kScreenWidth , 20.0f + 29.0f + 20.0f);
    }else {
        return CGSizeZero;
    }
}
@end
