//
//  YXResourceCollectionRequest.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/7.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@interface YXResourceCollectionRequest : YXGetRequest

@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *iscollection; // 0:收藏, 1:取消收藏 

@end
