//
//  YXMockManager.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/5/24.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface YXMockManager : NSObject
@property (nonatomic, assign) NSInteger requestDuration;

- (BOOL)hasMockDataForKey:(NSString *)key;
- (NSString *)mockDataForKey:(NSString *)key;

@end
