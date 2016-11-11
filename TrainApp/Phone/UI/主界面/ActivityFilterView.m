//
//  ActivityFilterView.m
//  TrainApp
//
//  Created by ZLL on 2016/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityFilterView.h"
#import "ActivityFilterCell.h"
#import "YXCourseFilterBgView.h"
static const NSUInteger kTagBase = 10000;

@interface ActivityFilterItem:NSObject
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSArray *filterArray;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation ActivityFilterItem

@end

@interface ActivityFilterView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) ActivityFilterItem *currentFilterItem;
@property (nonatomic, strong) NSMutableArray *filterItemArray;
@property (nonatomic, strong) UIView *typeContainerView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *selectionTableView;
@property (nonatomic, strong) UIView *tableBottomView;
@property (nonatomic, assign) BOOL layoutComplete;
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation ActivityFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.filterItemArray = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.typeContainerView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:self.typeContainerView];
    self.maskView = [[UIView alloc]init];
    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.maskView addGestureRecognizer:tap];
    
    self.selectionTableView = [[UITableView alloc]init];
    self.selectionTableView.backgroundColor = [UIColor clearColor];
    self.selectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectionTableView.rowHeight = 44;
    self.selectionTableView.dataSource = self;
    self.selectionTableView.delegate = self;
    [self.selectionTableView registerClass:[ActivityFilterCell class] forCellReuseIdentifier:@"ActivityFilterCell"];
    
    self.tableBottomView = [[UIView alloc]init];
    self.tableBottomView.clipsToBounds = YES;
    self.tableBottomView.backgroundColor = [UIColor clearColor];
    
}
- (void)addFilters:(NSArray *)filters forKey:(NSString *)key {
    ActivityFilterItem *item = [[ActivityFilterItem alloc]init];
    item.typeName = key;
    item.filterArray = filters;
    item.currentIndex = -1;
    [self.filterItemArray addObject:item];
}
- (void)setCurrentIndex:(NSInteger)index forKey:(NSString *)key {
    ActivityFilterItem *item = nil;
    for (ActivityFilterItem *f in self.filterItemArray) {
        if ([f.typeName isEqualToString:key]) {
            item = f;
            break;
        }
    }
    item.currentIndex = index;
}
- (void)layoutSubviews {
    if (self.layoutComplete) {
        return;
    }
    CGFloat btnWidth = self.typeContainerView.bounds.size.width/self.filterItemArray.count;
    CGFloat lineWidth = 1/[UIScreen mainScreen].scale;
    [self.filterItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ActivityFilterItem *item = (ActivityFilterItem *)obj;
        UIButton *button = [self typeButtonWithName:[self currentFilterNameForItem:item]];
        button.frame = CGRectMake(btnWidth*idx, 0, btnWidth, self.typeContainerView.bounds.size.height);
        button.tag = kTagBase + idx;
        [self exchangeTitleImagePositionForButton:button];
        BOOL status = item.currentIndex>=0 ? YES:NO;
        [self changeButton:button selectedStatus:status];
        [self.typeContainerView addSubview:button];
        if (idx < self.filterItemArray.count-1) {
            CGFloat height = 15;
            CGFloat y = (self.typeContainerView.bounds.size.height-height)/2;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x+button.frame.size.width-lineWidth, y, lineWidth, height)];
            line.backgroundColor = [UIColor colorWithHexString:@"d6d7db"];
            [self.typeContainerView addSubview:line];
        }
    }];
    self.layoutComplete = YES;
}
- (UIButton *)typeButtonWithName:(NSString *)name {
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:name forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self changeButton:button foldStatus:YES];
    return button;
}
- (NSString *)currentFilterNameForItem:(ActivityFilterItem *)item {
    if (item.currentIndex < 0) {
        return item.typeName;
    }
    return item.filterArray[item.currentIndex];
}
- (void)exchangeTitleImagePositionForButton:(UIButton *)button {
    NSString *title = [button titleForState:UIControlStateNormal];
    CGFloat titleWidth = ceilf([title sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width+2);
    UIImage *image = [button imageForState:UIControlStateNormal];
    CGFloat imageWidth = image.size.width+2;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
}
- (void)changeButton:(UIButton *)b foldStatus:(BOOL)isFold {
    if (isFold) {
        [b setImage:[UIImage imageNamed:@"学段类型展开箭头"] forState:UIControlStateNormal];
    }else{
        [b setImage:[UIImage imageNamed:@"学段类型收起箭头"] forState:UIControlStateNormal];
    }
}
- (void)changeButton:(UIButton *)b selectedStatus:(BOOL)isSelected {
    if (isSelected) {
        [b setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
    }else{
        [b setTitleColor:[UIColor colorWithHexString:@"505f84"] forState:UIControlStateNormal];
    }
}
- (void)typeButtonAction:(UIButton *)sender {
    if (self.isAnimating) {
        return;
    }
    NSInteger curIndex = sender.tag - kTagBase;
    [self showFilterSelectionViewWithIndex:curIndex];
    [self changeButton:sender foldStatus:NO];
}
- (void)tapAction {
    if (self.isAnimating) {
        return;
    }
    [self hideFilterSelectionView];
}
#pragma mark - Show & Hide
- (void)showFilterSelectionViewWithIndex:(NSInteger)index {
    self.currentFilterItem = self.filterItemArray[index];
    
    UIView *superview = self.window;
    self.maskView.frame = superview.bounds;
    [superview addSubview:self.maskView];
    
    CGRect rect = [self convertRect:self.bounds toView:superview];
    
    CGFloat tableHeight = MIN(self.currentFilterItem.filterArray.count*self.selectionTableView.rowHeight, 242);
    
    YXCourseFilterBgView *bgView = [[YXCourseFilterBgView alloc]initWithFrame:CGRectMake(6, rect.origin.y+rect.size.height-5, rect.size.width-6-6, tableHeight+8) triangleX:self.bounds.size.width/8*(1+2*index)-6];
    self.selectionTableView.frame = CGRectMake(0, 8, bgView.bounds.size.width, tableHeight);
    [bgView addSubview:self.selectionTableView];
    [superview addSubview:bgView];
    [self.selectionTableView reloadData];
}
- (void)hideFilterSelectionView {
    [self.selectionTableView.superview removeFromSuperview];
    [self.maskView removeFromSuperview];
    NSInteger index = [self.filterItemArray indexOfObject:self.currentFilterItem];
    UIButton *b = [self.typeContainerView viewWithTag:index+kTagBase];
    [self changeButton:b foldStatus:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentFilterItem.filterArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityFilterCell"];
    cell.filterName = self.currentFilterItem.filterArray[indexPath.row];
    cell.isCurrent = (indexPath.row == self.currentFilterItem.currentIndex);
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isAnimating) {
        return;
    }
    self.currentFilterItem.currentIndex = indexPath.row;
    NSMutableArray *array = [NSMutableArray array];
    [self.filterItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ActivityFilterItem *item = (ActivityFilterItem *)obj;
        NSInteger index = MAX(item.currentIndex, 0);
        [array addObject:@(index)];
    }];
    SAFE_CALL_OneParam(self.delegate, filterChanged, array);
    
    NSInteger index = [self.filterItemArray indexOfObject:self.currentFilterItem];
    UIButton *button = [self.typeContainerView viewWithTag:kTagBase+index];
    [button setTitle:self.currentFilterItem.filterArray[indexPath.row] forState:UIControlStateNormal];
    [self changeButton:button foldStatus:YES];
    [self changeButton:button selectedStatus:YES];
    [self exchangeTitleImagePositionForButton:button];
    
    [self hideFilterSelectionView];
}
@end
