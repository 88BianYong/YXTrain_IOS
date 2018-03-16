//
//  YXDatumOrderView.m
//  TrainApp
//
//  Created by 李五民 on 16/6/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXDatumOrderView.h"
#import "YXDatumOrderViewCell.h"

@interface YXDatumOrderView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *orderArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger btnCount;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIImageView *topTriangleImageView;

@end

@implementation YXDatumOrderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setViewWithDataArray:(NSArray *)array index:(NSInteger)index buttonCount:(NSInteger)btnCount{
    self.orderArray = array;
    self.index = index;
    self.btnCount = btnCount;
    CGFloat tableHeight = MIN(array.count*44, 242);
    [self setTriangleFrame];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.isNavBarHidden) {
            make.top.mas_equalTo(kVerticalNavBarHeight);
        }else{
            make.top.mas_equalTo(kVerticalNavBarHeight + 45.0f);
        }
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.height.mas_equalTo(tableHeight);
    }];
    [self.tableView reloadData];
    
}
- (void)setOrderArray:(NSArray *)orderArray {
    _orderArray = orderArray;
    [self.tableView reloadData];
}

- (void)setupUI{
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderGesture:)];
    [self.maskView addGestureRecognizer:tapGesture];
    [self addSubview:self.maskView];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 44;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.layer.cornerRadius = YXTrainCornerRadii;
    self.tableView.layer.masksToBounds = YES;
    [self addSubview:self.tableView];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(109);
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.height.mas_equalTo(308);
    }];
    [self.tableView registerClass:[YXDatumOrderViewCell class] forCellReuseIdentifier:@"YXDatumOrderViewCell"];
}

- (void)tapHeaderGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.tapCloseView) {
            self.tapCloseView(_index);
        }
        [self removeFromSuperview];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.orderArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXDatumOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXDatumOrderViewCell" forIndexPath:indexPath];
    cell.datumOrder = self.orderArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self removeFromSuperview];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (int i=0; i<[self.orderArray count]; i++) {
        YXFilterSubtype *datumModel = self.orderArray[i];
        datumModel.selected = FALSE;
        if (i == indexPath.row) {
            datumModel.selected = TRUE;
        }
    }
    [tableView reloadData];
    
    if (self.didSeletedDatumOrderItem) {
        self.didSeletedDatumOrderItem(indexPath.row);
    }
}

- (UIImageView *)topTriangleImageView {
    if (!_topTriangleImageView) {
        _topTriangleImageView = [UIImageView new];
        _topTriangleImageView.image = [UIImage imageNamed:@"切换项目名称的弹窗-尖角"];
        [self addSubview:_topTriangleImageView];
    }
    return _topTriangleImageView;
}

- (void)setTriangleFrame {
    if (self.isNavBarHidden) {
        self.topTriangleImageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width/self.btnCount) * (0.5 + self.index) - 8, kVerticalNavBarHeight + 45.0f - 8.0f - 44.0f, 18, 8);
    }else{
        self.topTriangleImageView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width/self.btnCount) * (0.5 + self.index) - 8, kVerticalNavBarHeight + 45.0f - 8.0f, 18, 8);
    }
}

@end
