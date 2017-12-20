//
//  YXMockManager.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/5/24.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXMockManager.h"
#import "YXMockParser.h"

@interface YXMockManager()
@property (nonatomic, strong) YXMockParser *parser;
@end

@implementation YXMockManager
- (BOOL)hasMockDataForKey:(NSString *)key{
    return [self.parser hasMockDataForKey:key];
}

- (NSString *)mockDataForKey:(NSString *)key{
    return [self.parser mockDataForKey:key];
}

- (NSInteger)requestDuration{
    return self.parser.timeUse;
}


@end
