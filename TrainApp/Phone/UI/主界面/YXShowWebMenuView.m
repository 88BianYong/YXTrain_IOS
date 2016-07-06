//
//  YXShowWebMenuView.m
//  TrainApp
//
//  Created by 李五民 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXShowWebMenuView.h"
#import "YXShowWebMenuTableViewCell.h"

@interface YXShowWebMenuView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation YXShowWebMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderGesture:)];
    [self.maskView addGestureRecognizer:tapGesture];
    [self addSubview:self.maskView];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 44;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.layer.cornerRadius = 2;
    self.tableView.layer.masksToBounds = YES;
    [self addSubview:self.tableView];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(135);
        make.width.mas_equalTo(149);
    }];
    [self.tableView registerClass:[YXShowWebMenuTableViewCell class] forCellReuseIdentifier:@"YXShowWebMenuTableViewCell"];
}

- (void)tapHeaderGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self removeFromSuperview];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXShowWebMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXShowWebMenuTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell configCellWithTitle:@"刷新" imageString:nil isLastOne:NO];
    }
    if (indexPath.row == 1) {
        [cell configCellWithTitle:@"在浏览器中打开" imageString:nil isLastOne:NO];
    }
    if (indexPath.row == 2) {
        [cell configCellWithTitle:@"复制链接" imageString:nil isLastOne:YES];
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self removeFromSuperview];
    if (self.didSeletedItem) {
        self.didSeletedItem(indexPath.row);
    }
}

#pragma mark 绘制三角形
- (void)drawRect:(CGRect)rect

{
    // 设置背景色
    [[UIColor whiteColor] set];
    //拿到当前视图准备好的画板
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
    CGContextMoveToPoint(context,
                         [UIScreen mainScreen].bounds.size.width - 10, 65);//设置起点
    
    CGContextAddLineToPoint(context,
                            [UIScreen mainScreen].bounds.size.width - 17,  58);
    
    CGContextAddLineToPoint(context,
                            [UIScreen mainScreen].bounds.size.width - 24, 65);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor whiteColor] setFill];  //设置填充色
    
    [[UIColor whiteColor] setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path
    
}


@end
