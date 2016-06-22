//
//  YXDatumOrderFilterMenuView.m
//  TrainApp
//
//  Created by 李五民 on 16/6/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXDatumOrderFilterMenuView.h"
#import "YXDatumOrderView.h"
#import "YXDatumOrderModel.h"

@interface YXDatumOrderFilterMenuView()

@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) UIView *bottomSeperatorView;
@property (nonatomic, strong) UIImageView *orderImageView;
@property (nonatomic, strong) UIImageView *filterImageView;

//@property (nonatomic, strong) YXDatumFilterView *filterView;
//@property (nonatomic, strong) YXDatumFilterModel *filterModel;
@property (nonatomic, strong) YXDatumOrderView *orderView;
@property (nonatomic, strong) YXDatumOrderModel *orderModel;

@end

@implementation YXDatumOrderFilterMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupDatumOrder];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    self.orderButton = [[UIButton alloc]init];
    [self.orderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.orderButton setTitleColor:[UIColor colorWithHexString:@"2c97dd"] forState:UIControlStateSelected];
    [self.orderButton setTitle:@"排序" forState:UIControlStateNormal];
    self.orderButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.orderButton addTarget:self action:@selector(orderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.orderButton];
    self.orderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"下拉三角灰"]];
    [self.orderButton addSubview:self.orderImageView];
    
    self.filterButton = [[UIButton alloc]init];
    [self.filterButton setTitle:@"筛选" forState:UIControlStateNormal];
    [self.filterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.filterButton setTitleColor:[UIColor colorWithHexString:@"2c97dd"] forState:UIControlStateSelected];
    self.filterButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.filterButton addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.filterButton];
    self.filterImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"下拉三角灰"]];
    [self.filterButton addSubview:self.filterImageView];
    
    self.seperatorView = [[UIView alloc]init];
    self.seperatorView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self addSubview:self.seperatorView];
    
    self.bottomSeperatorView = [[UIView alloc]init];
    self.bottomSeperatorView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self addSubview:self.bottomSeperatorView];
    
    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.orderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(7.5, 5));
    }];
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderButton.mas_right);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(self.orderButton.mas_width);
    }];
    [self.filterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(7.5, 5));
    }];
    [self.seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.center.mas_equalTo(self);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
    [self.bottomSeperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

- (void)setupDatumOrder{
    self.orderModel = [[YXDatumOrderModel alloc]init];
    YXDatumOrder *o1 = [self orderWithName:@"使用最多" code:@"most_used" selected:FALSE];
    YXDatumOrder *o2 = [self orderWithName:@"最新上传" code:@"most_recent" selected:FALSE];
    YXDatumOrder *o3 = [self orderWithName:@"最多评论" code:@"most_comment" selected:FALSE];
    YXDatumOrder *o4 = [self orderWithName:@"最多分享" code:@"most_shared" selected:FALSE];
    self.orderModel.orderArray = @[o1,o2,o3,o4];
}
- (YXDatumOrder *)orderWithName:(NSString *)name code:(NSString *)code selected:(BOOL)selected{
    YXDatumOrder *order = [[YXDatumOrder alloc]init];
    order.name = name;
    order.code = code;
    order.selected = selected;
    return order;
}


- (void)orderAction:(UIButton *)sender{
    self.filterButton.selected = FALSE;
    self.filterImageView.image = [UIImage imageNamed:@"下拉三角灰"];
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.orderImageView.image = [UIImage imageNamed:@"下拉三角蓝"];
    }else{
        self.orderImageView.image = [UIImage imageNamed:@"下拉三角灰"];
    }
    if (!self.orderModel) {
        return;
    }
    if (!self.orderView) {
        self.orderView = [[YXDatumOrderView alloc]initWithFrame:CGRectMake(0, -[UIScreen mainScreen].bounds.size.height +  (64 + 45), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - (64 + 45))];
        self.orderView.orderModel = self.orderModel;
        @weakify(self);
        self.orderView.didSeletedDatumOrderItem = ^{
            @strongify(self);
            self.orderButton.selected = FALSE;
            self.orderImageView.image = [UIImage imageNamed:@"下拉三角灰"];
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.orderView.frame = CGRectMake(0, -self.orderView.frame.size.height, self.orderView.frame.size.width, self.orderView.frame.size.height);
                             }];
            if (self.didSelectedOrderCell) {
                self.didSelectedOrderCell([self currentCondition]);
            }
        };
        [self.superview addSubview:self.orderView];
        [self.superview insertSubview:self.orderView belowSubview:self];
    }
    //        if (self.filterView) {
    //            [self.view insertSubview:self.filterView belowSubview:self.orderView];
    //        }
    if (!sender.selected) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.orderView.frame = CGRectMake(0, -self.orderView.frame.size.height, self.orderView.frame.size.width, self.orderView.frame.size.height);
                         }];
    }else{
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.orderView.frame = CGRectMake(0, self.frame.size.height, self.orderView.frame.size.width, self.orderView.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             //                                 self.filterView.frame = CGRectMake(0, -self.filterView.frame.size.height, self.filterView.frame.size.width, self.filterView.frame.size.height);
                             //                                 [self.menuView setFilterFolded];
                         }];
    }
    
}
#pragma mark - Order & Filter Condition
- (NSString *)currentCondition{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"SearchFilter" forKey:@"interf"];
    [dic setValue:@"ios" forKey:@"source"];
    for (YXDatumOrder *order in self.orderModel.orderArray) {
        if (order.selected) {
            [dic setValue:order.code forKey:@"sort_field"];
            break;
        }
    }
//    for (YXFilterType *type in self.filterModel.filterArray) {
//        for (YXFilterSubtype *subtype in type.subtypeArray) {
//            if (subtype.selected && ![subtype.name isEqualToString:@"全部"]) {
//                [dic setValue:subtype.filterId forKey:type.code];
//                break;
//            }
//        }
//    }
    //NSString *condition = [YXDatumUtils jsonStringFromObject:dic];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (error) {
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

- (void)filterAction:(UIButton *)sender{
    self.orderButton.selected = FALSE;
    self.orderImageView.image = [UIImage imageNamed:@"下拉三角灰"];
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.filterImageView.image = [UIImage imageNamed:@"下拉三角蓝"];
    }else{
        self.filterImageView.image = [UIImage imageNamed:@"下拉三角灰"];
    }
}

- (void)setFilterFolded{
    //
    self.filterButton.selected = FALSE;
    self.filterImageView.image = [UIImage imageNamed:@"下拉三角灰"];
}
- (void)setOrderFolded{
    self.orderView.frame = CGRectMake(0, -self.orderView.frame.size.height, self.orderView.frame.size.width, self.orderView.frame.size.height);
    self.orderButton.selected = FALSE;
    self.orderImageView.image = [UIImage imageNamed:@"下拉三角灰"];
}


@end
