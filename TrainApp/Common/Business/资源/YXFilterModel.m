//
//  YXFilterModel.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/8/31.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXFilterModel.h"

@implementation YXFilterType

@end

@implementation YXFilterSubtype

@end

@implementation YXFilterModel

+ (YXFilterModel *)modelFromFilterRequestItem:(YXDatumFilterRequestItem *)item{
    YXFilterModel *filterModel = [[YXFilterModel alloc]init];
    NSMutableArray *typeArray = [NSMutableArray array];
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
        // 增加‘全部’
        YXFilterSubtype *whole = [[YXFilterSubtype alloc]init];
        whole.name = @"全部";
        whole.selected = YES;
        [subTypeArray insertObject:whole atIndex:0];
        
        type.subtypeArray = subTypeArray;
        [typeArray addObject:type];
    }
    filterModel.filterArray = typeArray;
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
