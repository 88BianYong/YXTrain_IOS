//
//  YXFilterModel.h
//  YanXiuApp
//
//  Created by niuzhaowang on 15/8/31.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXDatumFilterRequest.h"

@interface YXFilterType : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSMutableArray *subtypeArray;
@end

@interface YXFilterSubtype : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *filterId;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL cached;
@end

@interface YXFilterModel : NSObject
@property (nonatomic, strong) NSMutableArray *filterArray;

+ (YXFilterModel *)modelFromFilterRequestItem:(YXDatumFilterRequestItem *)item;

- (void)loadLatestFilter;
- (void)saveFilter;
+ (void)resetFilters:(YXFilterModel *)model;
@end
