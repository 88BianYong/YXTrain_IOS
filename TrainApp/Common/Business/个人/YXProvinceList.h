//
//  YXProvinceList.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/14.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXCounty : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *zipcode;

@end

@interface YXCity : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *counties;

@end

@interface YXProvince : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *citys;

@end

@interface YXProvinceList : NSObject

@property (nonatomic, strong) NSMutableArray *provinces;

- (BOOL)startParse;

@end
