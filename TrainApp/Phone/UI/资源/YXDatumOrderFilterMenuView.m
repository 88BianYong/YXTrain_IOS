//
//  YXDatumOrderFilterMenuView.m
//  TrainApp
//
//  Created by 李五民 on 16/6/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXDatumOrderFilterMenuView.h"
#import "YXDatumGlobalSingleton.h"
#import "YXDatumOrderView.h"
#import "YXDatumOrderModel.h"
#import "YXFilterCustomButton.h"
#import "YXTopFilterView.h"
#import "YXFilterModel.h"
#import "YXDatumOrderView.h"


@interface YXDatumOrderFilterMenuView()
@property (nonatomic, strong) YXFilterModel *filterModel;
@property (nonatomic, strong) NSArray *orderArray;
@property (nonatomic, strong) NSMutableArray *typeNameArray;

@property (nonatomic, strong) YXTopFilterView *topFilterView;

@end

@implementation YXDatumOrderFilterMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self prapareData];
        self.backgroundColor = [UIColor whiteColor];
        [self setupTopView];
    }
    return self;
}

- (void)prapareData {
    self.typeNameArray = [[NSMutableArray alloc] init];
    BOOL isExist = NO;
    for (YXFilterType *type in [YXDatumGlobalSingleton sharedInstance].filterModel.filterArray) {
        if (type.subtypeArray.count> 1) {
            isExist = YES;
        }
    }
    if ([YXDatumGlobalSingleton sharedInstance].filterModel && isExist) {
        self.filterModel = [YXDatumGlobalSingleton sharedInstance].filterModel;
        [YXFilterModel resetFilters:self.filterModel];//BUG 666 重置筛选条件
    }else{
        [self getFilter];
    }
    [self setupDatumOrder];
    [self.typeNameArray addObject:@"默认排序"];
    if (!self.filterModel) {
        self.filterModel = [[YXFilterModel alloc] init];
    }
    if (self.filterModel.filterArray.count == 0) {
        for (int i = 0; i < 3; i ++) {
            YXFilterType *type = [[YXFilterType alloc] init];
            if (i == 0) {
                type.name = @"年级";
            } else if(i == 1) {
                type.name = @"学科";
            } else if(i == 2) {
                type.name = @"教材版本";
            }
            YXFilterSubtype *whole = [[YXFilterSubtype alloc]init];
            whole.name = @"全部";
            whole.selected = YES;
            [type.subtypeArray addObject:whole];
            [self.filterModel.filterArray addObject:type];
        }
    }
    [self.filterModel.filterArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXFilterType *filterType = obj;
        [self.typeNameArray addObject:filterType.name];
    }];
    
}

- (void)setupTopView{
    if (!self.topFilterView) {
        self.topFilterView = [[YXTopFilterView alloc] init];
        [self addSubview:self.topFilterView];
        [self.topFilterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(45);
        }];
        @weakify(self);
        self.topFilterView.buttonClicked = ^(NSInteger index) {
            @strongify(self);
            YXDatumOrderView *orderView = [[YXDatumOrderView alloc]initWithFrame:self.window.bounds];
            NSArray *orderViewArray = nil;
            if (index == 0) {
                orderViewArray = self.orderArray;
            } else {
                orderViewArray = ((YXFilterType *)self.filterModel.filterArray[index -1]).subtypeArray;
            }
            [orderView setViewWithDataArray:orderViewArray index:index buttonCount:self.filterModel.filterArray.count + 1];
            orderView.didSeletedDatumOrderItem = ^(NSInteger selectedIndex){
                NSString *condition = [self currentCondition];
                if (self.refreshFilterBlock) {
                    self.refreshFilterBlock(condition);
                }
                [self.topFilterView btnTitileWithString:((YXFilterSubtype *)orderViewArray[selectedIndex]).name index:index];
            };
            orderView.tapCloseView = ^(NSInteger selectedIndex){
                [self.topFilterView tapViewWithIndex:selectedIndex];
            };
            [self.window addSubview:orderView];
        };
    }
    [self.topFilterView viewWithNameArray:self.typeNameArray];
}

- (void)getFilter
{
    @weakify(self);
    [[YXDatumGlobalSingleton sharedInstance] getDatumFilterData:^(NSError *error) {
        @strongify(self);
        self.filterModel = [YXDatumGlobalSingleton sharedInstance].filterModel;
    }];
}

- (void)setupDatumOrder{
    self.orderArray = [[NSArray alloc]init];
    YXFilterSubtype *o0 = [self orderWithName:@"默认排序" code:@"" selected:YES];
    YXFilterSubtype *o1 = [self orderWithName:@"使用最多" code:@"most_used" selected:FALSE];
    YXFilterSubtype *o2 = [self orderWithName:@"最新上传" code:@"most_recent" selected:FALSE];
    YXFilterSubtype *o3 = [self orderWithName:@"最多评论" code:@"most_comment" selected:FALSE];
    YXFilterSubtype *o4 = [self orderWithName:@"最多分享" code:@"most_shared" selected:FALSE];
    self.orderArray = @[o0,o1,o2,o3,o4];
}
- (YXFilterSubtype *)orderWithName:(NSString *)name code:(NSString *)code selected:(BOOL)selected{
    YXFilterSubtype *order = [[YXFilterSubtype alloc]init];
    order.name = name;
    order.filterId = code;
    order.selected = selected;
    return order;
}

#pragma mark - Order & Filter Condition
- (NSString *)currentCondition{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"SearchFilter" forKey:@"interf"];
    [dic setValue:@"ios" forKey:@"source"];
    for (YXFilterSubtype *order in self.orderArray) {
        if (order.selected) {
            if ([self.orderArray indexOfObject:order] == 0) {
                break;
            }
            [dic setValue:order.filterId forKey:@"sort_field"];
            break;
        }
    }
    for (YXFilterType *type in self.filterModel.filterArray) {
        for (YXFilterSubtype *subtype in type.subtypeArray) {
            if (subtype.selected && ![subtype.name isEqualToString:@"全部"]) {
                [dic setValue:subtype.filterId forKey:type.code];
                break;
            }
        }
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (error) {
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}


@end
