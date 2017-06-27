//
//  YXCourseFilterView.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/21.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseFilterView.h"
#import "YXCourseFilterCell.h"
#import "YXCourseFilterBgView.h"

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
    self.typeContainerView.frame = CGRectMake(5.0f, 0.0f, self.bounds.size.width - 10.0f, self.bounds.size.height);
//    CGFloat lineHeight = 1/[UIScreen mainScreen].scale;
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.typeContainerView.bounds.size.height-lineHeight, self.typeContainerView.frame.size.width, lineHeight)];
//    line.backgroundColor = [UIColor blackColor];
//    [self.typeContainerView addSubview:line];
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
    [self.selectionTableView registerClass:[YXCourseFilterCell class] forCellReuseIdentifier:@"YXCourseFilterCell"];
    
    self.tableBottomView = [[UIView alloc]init];
    self.tableBottomView.clipsToBounds = YES;
    self.tableBottomView.backgroundColor = [UIColor clearColor];
    
}

- (void)addFilters:(NSArray *)filters forKey:(NSString *)key{
    YXCourseFilterItem *item = [[YXCourseFilterItem alloc]init];
    item.typeName = key;
    item.filterArray = filters;
    item.currentIndex = -1;
    [self.filterItemArray addObject:item];
}
- (void)refreshStudysFilters:(NSArray *)filters forKey:(NSString *)key {
    YXCourseFilterItem *item = [[YXCourseFilterItem alloc]init];
    item.typeName = key;
    item.filterArray = filters;
    item.currentIndex = -1;
    [self.filterItemArray replaceObjectAtIndex:1 withObject:item];
    UIButton *b = [self.typeContainerView viewWithTag:kTagBase+1];
    [b setTitle:key forState:UIControlStateNormal];
    [self changeButton:b foldStatus:YES];
    [self changeButton:b selectedStatus:NO];
    [self exchangeTitleImagePositionForButton:b];
    [self filterItemArrayChanged];
}
- (void)refreshStagesFilters:(NSArray *)filters forKey:(NSString *)key {
    YXCourseFilterItem *item = [[YXCourseFilterItem alloc]init];
    item.typeName = key;
    item.filterArray = filters;
    item.currentIndex = -1;
    [self.filterItemArray replaceObjectAtIndex:2 withObject:item];
    UIButton *b = [self.typeContainerView viewWithTag:kTagBase+2];
    [b setTitle:key forState:UIControlStateNormal];
    [self changeButton:b foldStatus:NO];
    [self changeButton:b selectedStatus:NO];
    [self exchangeTitleImagePositionForButton:b];
    [self filterItemArrayChanged];
}

- (void)setCurrentIndex:(NSInteger)index forKey:(NSString *)key{
    YXCourseFilterItem *item = nil;
    for (YXCourseFilterItem *f in self.filterItemArray) {
        if ([f.typeName isEqualToString:key]) {
            item = f;
            break;
        }
    }
    item.currentIndex = index;
}

- (void)layoutSubviews{
    if (self.layoutComplete) {
        return;
    }
    CGFloat btnWidth = self.typeContainerView.bounds.size.width/self.filterItemArray.count;
    CGFloat lineWidth = 1/[UIScreen mainScreen].scale;
    [self.filterItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXCourseFilterItem *item = (YXCourseFilterItem *)obj;
        UIButton *b = [self typeButtonWithName:[self currentFilterNameForItem:item]];
        b.frame = CGRectMake(btnWidth*idx, 0, btnWidth, self.typeContainerView.bounds.size.height);
        b.tag = kTagBase + idx;
        [self exchangeTitleImagePositionForButton:b];
        BOOL status = item.currentIndex>=0 ? YES:NO;
        [self changeButton:b selectedStatus:status];
        [self.typeContainerView addSubview:b];
        if (idx < self.filterItemArray.count-1) {
            CGFloat h = 15;
            CGFloat y = (self.typeContainerView.bounds.size.height-h)/2;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(b.frame.origin.x+b.frame.size.width-lineWidth, y, lineWidth, h)];
            line.backgroundColor = [UIColor colorWithHexString:@"d6d7db"];
            [self.typeContainerView addSubview:line];
        }
    }];
    
    self.layoutComplete = YES;
}

- (NSString *)currentFilterNameForItem:(YXCourseFilterItem *)item{
    if (item.currentIndex < 0) {
        return item.typeName;
    }
    return item.filterArray[item.currentIndex];
}

- (UIButton *)typeButtonWithName:(NSString *)name{
    UIButton *b = [[UIButton alloc]init];
    [b setTitle:name forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:13];
    [b addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self changeButton:b foldStatus:YES];
    return b;
}

- (void)exchangeTitleImagePositionForButton:(UIButton *)button{
    NSString *title = [button titleForState:UIControlStateNormal];
    CGFloat titleWidth = ceilf([title sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width+2);
    titleWidth = MIN(titleWidth, button.frame.size.width - 24.0f);//防止文字过多
    UIImage *image = [button imageForState:UIControlStateNormal];
    CGFloat imageWidth = image.size.width+2;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
}

- (void)changeButton:(UIButton *)b foldStatus:(BOOL)isFold{
    if (isFold) {
        [b setImage:[UIImage imageNamed:@"学段类型展开箭头"] forState:UIControlStateNormal];
    }else{
        [b setImage:[UIImage imageNamed:@"学段类型收起箭头"] forState:UIControlStateNormal];
    }
}

- (void)changeButton:(UIButton *)b selectedStatus:(BOOL)isSelected{
    if (isSelected) {
        [b setTitleColor:[UIColor colorWithHexString:@"0067be"] forState:UIControlStateNormal];
        [b setImage:[UIImage imageNamed:@"筛选项目，选择后箭头"] forState:UIControlStateNormal];
    }else{
        [b setTitleColor:[UIColor colorWithHexString:@"505f84"] forState:UIControlStateNormal];
    }
}

- (void)btnAction:(UIButton *)sender{
    NSInteger curIndex = sender.tag - kTagBase;
    [self showFilterSelectionViewWithIndex:curIndex];
    [self changeButton:sender foldStatus:NO];
}

- (void)tapAction{
    [self hideFilterSelectionView];
}

#pragma mark - Show & Hide
- (void)showFilterSelectionViewWithIndex:(NSInteger)index{
    self.currentFilterItem = self.filterItemArray[index];
    
    UIView *superview = self.window;
    self.maskView.frame = superview.bounds;
    [superview addSubview:self.maskView];
    
    CGRect rect = [self convertRect:self.bounds toView:superview];
    CGFloat tableHeight;
    if (self.currentFilterItem.filterArray.count == 0) {//服务端数据返回为空时 显示
        tableHeight = 44;
    }else {
        tableHeight = MIN(self.currentFilterItem.filterArray.count*self.selectionTableView.rowHeight , 242);
    }    
    YXCourseFilterBgView *bgView = [[YXCourseFilterBgView alloc]initWithFrame:CGRectMake(6, rect.origin.y+rect.size.height-5, rect.size.width-6-6, tableHeight+8) triangleX:self.bounds.size.width/(self.filterItemArray.count * 2)*(1+2*index)-6];
    self.selectionTableView.frame = CGRectMake(0, 8, bgView.bounds.size.width, tableHeight);
    [bgView addSubview:self.selectionTableView];
    [superview addSubview:bgView];
    [self.selectionTableView reloadData];
}

- (void)hideFilterSelectionView{
    [self.selectionTableView.superview removeFromSuperview];
    [self.maskView removeFromSuperview];
    NSInteger index = [self.filterItemArray indexOfObject:self.currentFilterItem];
    UIButton *b = [self.typeContainerView viewWithTag:index+kTagBase];
    [self changeButton:b foldStatus:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentFilterItem.filterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXCourseFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXCourseFilterCell"];
    cell.filterName = self.currentFilterItem.filterArray[indexPath.row];
    cell.isCurrent = (indexPath.row == self.currentFilterItem.currentIndex);
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentFilterItem.currentIndex = indexPath.row;
    [self filterItemArrayChanged];
    NSInteger index = [self.filterItemArray indexOfObject:self.currentFilterItem];
    UIButton *b = [self.typeContainerView viewWithTag:kTagBase+index];
    [b setTitle:self.currentFilterItem.filterArray[indexPath.row] forState:UIControlStateNormal];
    [self changeButton:b foldStatus:YES];
    
    [self hideFilterSelectionView];
    [self changeButton:b selectedStatus:YES];
    [self exchangeTitleImagePositionForButton:b];
}
- (void)filterItemArrayChanged {
    NSMutableArray *array = [NSMutableArray array];
    [self.filterItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXCourseFilterItem *item = (YXCourseFilterItem *)obj;
        NSInteger index = MAX(item.currentIndex, 0);
        [array addObject:@(index)];
    }];
    SAFE_CALL_OneParam(self.delegate, filterChanged, array);
}
@end
