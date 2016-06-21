//
//  YXCourseFilterView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/21.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseFilterView.h"
#import "YXCourseFilterCell.h"

static const NSUInteger kTagBase = 876;

@interface YXCourseFilterItem:NSObject
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSArray *filterArray;
@property (nonatomic, assign) NSInteger currentIndex;
@end
@implementation YXCourseFilterItem

@end
@interface YXCourseFilterView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *typeContainerView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *selectionTableView;
@property (nonatomic, strong) UIView *tableBottomView;
@property (nonatomic, strong) NSMutableArray *filterItemArray;
@property (nonatomic, strong) YXCourseFilterItem *currentFilterItem;
@property (nonatomic, assign) BOOL layoutComplete;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL showStatus;
@end

@implementation YXCourseFilterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.filterItemArray = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.typeContainerView = [[UIView alloc]initWithFrame:self.bounds];
    CGFloat lineHeight = 1/[UIScreen mainScreen].scale;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.typeContainerView.bounds.size.height-lineHeight, self.typeContainerView.frame.size.width, lineHeight)];
    line.backgroundColor = [UIColor blackColor];
    [self.typeContainerView addSubview:line];
    [self addSubview:self.typeContainerView];
    
    self.maskView = [[UIView alloc]init];
    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.maskView addGestureRecognizer:tap];
    
    self.selectionTableView = [[UITableView alloc]init];
    self.selectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectionTableView.rowHeight = 44;
    self.selectionTableView.dataSource = self;
    self.selectionTableView.delegate = self;
    [self.selectionTableView registerClass:[YXCourseFilterCell class] forCellReuseIdentifier:@"YXCourseFilterCell"];
    
    self.tableBottomView = [[UIView alloc]init];
    self.tableBottomView.clipsToBounds = YES;
    self.tableBottomView.backgroundColor = [UIColor clearColor];
}

- (void)addFilters:(NSArray *)filters forKey:(NSString *)key{
    YXCourseFilterItem *item = [[YXCourseFilterItem alloc]init];
    item.typeName = key;
    item.filterArray = filters;
    item.currentIndex = 0;
    [self.filterItemArray addObject:item];
}

- (void)layoutSubviews{
    if (self.layoutComplete) {
        return;
    }
    CGFloat btnWidth = self.typeContainerView.bounds.size.width/self.filterItemArray.count;
    CGFloat lineWidth = 1/[UIScreen mainScreen].scale;
    [self.filterItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXCourseFilterItem *item = (YXCourseFilterItem *)obj;
        UIButton *b = [self typeButtonWithName:item.typeName];
        b.frame = CGRectMake(btnWidth*idx, 0, btnWidth, self.typeContainerView.bounds.size.height);
        b.tag = kTagBase + idx;
        [self.typeContainerView addSubview:b];
        if (idx < self.filterItemArray.count-1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(b.frame.origin.x+b.frame.size.width-lineWidth, 0, lineWidth, self.typeContainerView.bounds.size.height)];
            line.backgroundColor = [UIColor blackColor];
            [self.typeContainerView addSubview:line];
        }
    }];
    
    self.layoutComplete = YES;
}

- (UIButton *)typeButtonWithName:(NSString *)name{
    UIButton *b = [[UIButton alloc]init];
    [b setTitle:name forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (void)btnAction:(UIButton *)sender{
    if (self.isAnimating) {
        return;
    }
    NSInteger preIndex = [self.filterItemArray indexOfObject:self.currentFilterItem];
    NSInteger curIndex = sender.tag - kTagBase;
    if (preIndex == curIndex && self.showStatus) {
        [self hideFilterSelectionView];
    }else{
        [self showFilterSelectionViewWithIndex:curIndex];
    }
}

- (void)tapAction{
    if (self.isAnimating) {
        return;
    }
    [self hideFilterSelectionView];
}

#pragma mark - Show & Hide
- (void)showFilterSelectionViewWithIndex:(NSInteger)index{
    self.currentFilterItem = self.filterItemArray[index];
    
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.x + self.frame.size.height;
    CGFloat w = self.frame.size.width;
    CGFloat h = self.superview.bounds.size.height - y;
    self.maskView.frame = CGRectMake(x, y, w, h);
    [self.superview addSubview:self.maskView];
    
    CGFloat tableHeight = MIN(self.currentFilterItem.filterArray.count*self.selectionTableView.rowHeight, 200);
    self.tableBottomView.frame = CGRectMake(x, y, w, tableHeight);
    [self.superview addSubview:self.tableBottomView];
    
    self.selectionTableView.frame = CGRectMake(0, -self.tableBottomView.bounds.size.height, self.tableBottomView.bounds.size.width, self.tableBottomView.bounds.size.height);
    [self.tableBottomView addSubview:self.selectionTableView];
    [self.selectionTableView reloadData];
    
    self.isAnimating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.selectionTableView.frame = self.tableBottomView.bounds;
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
        self.showStatus = YES;
    }];
}

- (void)hideFilterSelectionView{
    self.isAnimating = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.selectionTableView.frame = CGRectMake(0, -self.tableBottomView.bounds.size.height, self.tableBottomView.bounds.size.width, self.tableBottomView.bounds.size.height);
    } completion:^(BOOL finished) {
        [self.tableBottomView removeFromSuperview];
        [self.maskView removeFromSuperview];
        self.isAnimating = NO;
        self.showStatus = NO;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentFilterItem.filterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXCourseFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXCourseFilterCell"];
    cell.filterName = self.currentFilterItem.filterArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isAnimating) {
        return;
    }
    self.currentFilterItem.currentIndex = indexPath.row;
    NSMutableArray *array = [NSMutableArray array];
    [self.filterItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXCourseFilterItem *item = (YXCourseFilterItem *)obj;
        [array addObject:@(item.currentIndex)];
    }];
    SAFE_CALL_OneParam(self.delegate, filterChanged, array);
    
    NSInteger index = [self.filterItemArray indexOfObject:self.currentFilterItem];
    UIButton *b = [self.typeContainerView viewWithTag:kTagBase+index];
    [b setTitle:self.currentFilterItem.filterArray[indexPath.row] forState:UIControlStateNormal];
    
    [self hideFilterSelectionView];
}

@end
