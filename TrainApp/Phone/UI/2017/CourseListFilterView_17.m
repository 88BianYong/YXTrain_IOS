//
//  CourseListFilterView_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseListFilterView_17.h"
#import "CourseFilterCell_17.h"
#import "CourseFilterHeaderView_17.h"
#import "CourseFilterFooterView_17.h"
#import "CollectionViewEqualSpaceFlowLayout.h"
@interface CourseListFilterView_17 ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UILabel *segmentNameLabel;
@property (nonatomic, strong) UILabel *segmentContentLabel;
@property (nonatomic, strong) UILabel *studyNameLabel;
@property (nonatomic, strong) UILabel *studyContentLabel;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedMutableArray;
@end
@implementation CourseListFilterView_17
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
- (void)setSearchTerm:(CourseListRequest_17Item_SearchTerm *)searchTerm {
    _searchTerm = searchTerm;
    if (_searchTerm == nil) {
        return;
    }
    [self.selectedMutableArray removeAllObjects];
    [_searchTerm.selectedMutableArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.integerValue < 0) {
            [self.selectedMutableArray addObject:@"0"];
        }else {
           [self.selectedMutableArray addObject:obj];
        }
    }];
    [self setupCourseFilterContent];
}

- (NSMutableArray *)setupCourseFilterContent {
    NSInteger segmentInteger = [self.searchTerm.selectedMutableArray[0] integerValue];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:2];
    if (segmentInteger >= 0) {
        CourseListRequest_17Item_SearchTerm_MockSegment *segment = self.searchTerm.segmentModel[segmentInteger];
        self.segmentContentLabel.text = segment.segmentName;
        [mutableArray addObject:segment.segmentID];
    }else {
        self.segmentContentLabel.text = @"请选择";
        [mutableArray addObject:@"0"];
    }
    NSInteger studyInteger = [self.searchTerm.selectedMutableArray[1] integerValue];
    if (studyInteger >= 0) {
         CourseListRequest_17Item_SearchTerm_MockSegment *segment = self.searchTerm.segmentModel[segmentInteger];
        CourseListRequest_17Item_SearchTerm_MockSegment_Chapter *chapter = segment.chapter[studyInteger];
        self.studyContentLabel.text = chapter.chapterName;
        [mutableArray addObject:chapter.chapterID];
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
    self.filterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //self.filterButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, -10.0f, 0.0f, 10.0f);
    [self.filterButton setTitleColor:[UIColor colorWithHexString:@"505f84"] forState:UIControlStateNormal];
    WEAK_SELF
    [[self.filterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self showFilterSelectionView];
    }];
    [self.filterButton setTitle:@"筛选" forState:UIControlStateNormal];
    [self.filterButton.titleLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
    [self addSubview:self.filterButton];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"筛选项目，选择后箭头"]];
    [self addSubview:self.imageView];
    
    self.maskView = [[UIView alloc]init];
    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [[tapGestureRecognizer rac_gestureSignal] subscribeNext:^(id x) {
        STRONG_SELF
        UITapGestureRecognizer * sender = x;
        CGPoint point = [sender locationInView:self.maskView];
        if (sender.state == UIGestureRecognizerStateEnded &&
            !CGRectContainsPoint(self.collectionView.frame,point)) {
            [self hideFilterSelectionView];
        }
    }];
    [self.maskView addGestureRecognizer:tapGestureRecognizer];
    
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundView.clipsToBounds = YES;
    [self.maskView addSubview:self.backgroundView];
    
    CollectionViewEqualSpaceFlowLayout *flowLayout = [[CollectionViewEqualSpaceFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    flowLayout.minimumInteritemSpacing = 10;
//    flowLayout.minimumLineSpacing = 7;
    flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 28.0f);
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0.0f, 10, 0.0f);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.clipsToBounds = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[CourseFilterCell_17 class] forCellWithReuseIdentifier:@"CourseFilterCell_17"];
    [self.collectionView registerClass:[CourseFilterHeaderView_17 class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CourseFilterHeaderView_17"];
    [self.collectionView registerClass:[CourseFilterFooterView_17 class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CourseFilterFooterView_17"];
    [self.backgroundView addSubview:self.collectionView];
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
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_offset(CGSizeMake(48.0f, 30.0f));
    }];
}
#pragma mark - Show & Hide
- (void)showFilterSelectionView{
    UIView *superview = self.superview;
    self.maskView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [superview addSubview:self.maskView];
    self.collectionView.frame = CGRectMake(15.0f, 0.0f, kScreenWidth - 30.0f , 0.0f);
    self.backgroundView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth , 0.0f);
    [self reloadData];
}

- (void)hideFilterSelectionView{
    [UIView animateWithDuration:0.25f animations:^{
        self.collectionView.frame = CGRectMake(15.0f, 0.0f, kScreenWidth - 30.0f, 0.0f);
        self.backgroundView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth , 0.0f);
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
    }];
}
- (void)reloadData {
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            self.collectionView.frame = CGRectMake(15.0f, 0.0f, kScreenWidth - 30.0f, self.collectionView.contentSize.height);
            self.backgroundView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth , self.collectionView.contentSize.height);
        }];
    });
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.searchTerm.segmentModel.count;
    }else {
        CourseListRequest_17Item_SearchTerm_MockSegment *mockSegment = self.searchTerm.segmentModel[[self.selectedMutableArray[0] integerValue]];
        return mockSegment.chapter.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CourseFilterCell_17 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CourseFilterCell_17" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        CourseListRequest_17Item_SearchTerm_MockSegment *segment = self.searchTerm.segmentModel[indexPath.row];
        cell.title = segment.segmentName;
        cell.isCurrent = indexPath.row == [self.selectedMutableArray[0] integerValue];
    }else {
        CourseListRequest_17Item_SearchTerm_MockSegment *segment = self.searchTerm.segmentModel[[self.selectedMutableArray[0] integerValue]];
        CourseListRequest_17Item_SearchTerm_MockSegment_Chapter *chapter = segment.chapter[indexPath.row];
        cell.title = chapter.chapterName;
        cell.isCurrent = indexPath.row == [self.selectedMutableArray[1] integerValue];
    }
    WEAK_SELF
    cell.courseFilterButtonActionBlock = ^{
        STRONG_SELF
        if (indexPath.section == 0) {
            NSInteger segmentInteger = [self.selectedMutableArray[0] integerValue];
            NSInteger oldChapterId = 0;
            if (segmentInteger >= 0) {
               CourseListRequest_17Item_SearchTerm_MockSegment *oldSegment = self.searchTerm.segmentModel[segmentInteger];
                NSInteger studyInteger = [self.selectedMutableArray[1] integerValue];
                if (studyInteger >= 0) {
                   CourseListRequest_17Item_SearchTerm_MockSegment_Chapter *chapter = oldSegment.chapter[studyInteger];
                    oldChapterId = chapter.chapterID.integerValue;
                }
            }
            self.selectedMutableArray[1] = @(0);
            CourseListRequest_17Item_SearchTerm_MockSegment *segment = self.searchTerm.segmentModel[indexPath.row];
            [segment.chapter enumerateObjectsUsingBlock:^(CourseListRequest_17Item_SearchTerm_MockSegment_Chapter *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.chapterID.integerValue == oldChapterId) {
                     self.selectedMutableArray[1] = @(idx);
                }
            }];
        };
        self.selectedMutableArray[indexPath.section] = @(indexPath.row);
        [self reloadData];
    };
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        CourseFilterHeaderView_17 *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CourseFilterHeaderView_17" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.title = @"学段";
        }else {
           headerView.title = @"学科";
        }
        return headerView;
    }else if (kind == UICollectionElementKindSectionFooter && indexPath.section == 1){
        CourseFilterFooterView_17 *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CourseFilterFooterView_17" forIndexPath:indexPath];
        WEAK_SELF
        footerView.courseFilterCompleteBlock = ^(BOOL isCancleBool) {
            STRONG_SELF
            if (isCancleBool) {
                [self.selectedMutableArray removeAllObjects];
                [self.searchTerm.selectedMutableArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.integerValue < 0) {
                        [self.selectedMutableArray addObject:@"0"];
                    }else {
                        [self.selectedMutableArray addObject:obj];
                    }
                }];
            }else {
                if ([self.selectedMutableArray[0] integerValue] != [self.searchTerm.selectedMutableArray[0] integerValue] || [self.selectedMutableArray[1] integerValue] != [self.searchTerm.selectedMutableArray[1] integerValue]) {
                    [self.searchTerm.selectedMutableArray removeAllObjects];
                    [self.searchTerm.selectedMutableArray addObjectsFromArray:self.selectedMutableArray];
                    BLOCK_EXEC(self.courseListFilterSelectedBlock,[self setupCourseFilterContent]);
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
        CourseListRequest_17Item_SearchTerm_MockSegment *segment = self.searchTerm.segmentModel[indexPath.row];
        return [CourseFilterCell_17 sizeForTitle:segment.segmentName];
    }else {
        CourseListRequest_17Item_SearchTerm_MockSegment *segment = self.searchTerm.segmentModel[[self.selectedMutableArray[0] integerValue]];
        CourseListRequest_17Item_SearchTerm_MockSegment_Chapter *chapter = segment.chapter[indexPath.row];
        return [CourseFilterCell_17 sizeForTitle:chapter.chapterName];
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
