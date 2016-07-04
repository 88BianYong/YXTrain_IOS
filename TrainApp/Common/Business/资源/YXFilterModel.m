//
//  YXFilterModel.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/8/31.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXFilterModel.h"

@implementation YXFilterType

- (id)init {
    if (self = [super init]) {
        self.subtypeArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation YXFilterSubtype

@end

@implementation YXFilterModel

- (id)init {
    if (self = [super init]) {
        self.filterArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (YXFilterModel *)modelFromFilterRequestItem:(YXDatumFilterRequestItem *)item{
    YXFilterModel *filterModel = [[YXFilterModel alloc]init];
    NSMutableArray *typeArray = [NSMutableArray array];
    if (item) {
        for (YXDatumFilterRequestItem_data *data in item.data) {
            YXFilterType *type = [[YXFilterType alloc]init];
            type.name = data.cataName;
            type.code = data.cataCodeName;
            NSMutableArray *subTypeArray = [NSMutableArray array];
            for (YXDatumFilterRequestItem_data_cataele *ele in data.cataele) {
                YXFilterSubtype *subType = [[YXFilterSubtype alloc]init];
                subType.name = ele.name;
                subType.filterId = ele.elementId;
                [subTypeArray addObject:subType];
            }
            YXFilterSubtype *whole = [[YXFilterSubtype alloc]init];
            whole.name = @"全部";
            whole.selected = YES;
            [subTypeArray insertObject:whole atIndex:0];
            
            type.subtypeArray = subTypeArray;
            [typeArray addObject:type];
        }
    }
    NSArray *nameArray = @[@"年级",@"学科",@"教材版本"];
    filterModel.filterArray = typeArray;
    if (filterModel.filterArray.count < 3) {
        for (NSString *name in nameArray) {
            BOOL isExist= NO;
            for (YXFilterType *filterType in filterModel.filterArray) {
                if ([filterType.name isEqualToString:name]) {
                    isExist = YES;
                }
            }
            if (!isExist) {
                YXFilterType *type = [[YXFilterType alloc]init];
                type.name = name;
                YXFilterSubtype *whole = [[YXFilterSubtype alloc]init];
                whole.name = @"全部";
                whole.selected = YES;
                NSMutableArray *subTypeArray = [NSMutableArray array];
                [subTypeArray insertObject:whole atIndex:0];
                type.subtypeArray = subTypeArray;
                [typeArray insertObject:type atIndex:[nameArray indexOfObject:name]];
            }
        }
    }
    return filterModel;
}

- (void)loadLatestFilter{
    for (YXFilterType *type in self.filterArray) {
        for (YXFilterSubtype *subtype in type.subtypeArray) {
            subtype.cached = subtype.selected;
        }
    }
}
- (void)saveFilter{
    for (YXFilterType *type in self.filterArray) {
        for (YXFilterSubtype *subtype in type.subtypeArray) {
            subtype.selected = subtype.cached;
        }
    }
}
@end
