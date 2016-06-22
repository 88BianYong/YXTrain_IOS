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

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YXDatumOrderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.tableView = [[UITableView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 40;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.tableView registerClass:[YXDatumOrderViewCell class] forCellReuseIdentifier:@"YXDatumOrderViewCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.orderModel.orderArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXDatumOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXDatumOrderViewCell" forIndexPath:indexPath];
    cell.datumOrder = self.orderModel.orderArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (int i=0; i<[self.orderModel.orderArray count]; i++) {
        YXDatumOrder *datumModel = self.orderModel.orderArray[i];
        datumModel.selected = FALSE;
        if (i == indexPath.row) {
            datumModel.selected = TRUE;
        }
    }
    [tableView reloadData];
    
    if (self.didSeletedDatumOrderItem) {
        self.didSeletedDatumOrderItem();
    }
}


@end
