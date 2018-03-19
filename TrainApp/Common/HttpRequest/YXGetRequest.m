//
//  YXGetRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@implementation YXGetRequest

- (instancetype)init {
    if (self = [super init]) {
        self.token = [LSTSharedInstance sharedInstance].userManger.userModel.token;
        self.os = @"ios";
        self.ver = [LSTSharedInstance sharedInstance].configManager.clientVersion;
    }
    return self;
}
- (void)dealWithResponseJson:(NSString *)json {
    // TBD : cailei , 效率原因应该实现于各个子类，参看YXGetWrongQRequest，由于server暂时没有给出加密接口的list，所以先用此通用方法
    //    NSString *decrypt = [YXCrypt decryptForString:json];
    //    if (!isEmpty(decrypt)) {
    //        json = decrypt;
    //    } else {
    //        json = json;
    //    }
    
    // 解码对象不存在，直接返回json数据
    if (!_retClass || ![_retClass isSubclassOfClass:[JSONModel class]]) {
        _completeBlock(json, nil, self->_isMock);
        return;
    }
    
    NSError *error = nil;
    HttpBaseRequestItem *item = [[_retClass alloc] initWithString:json error:&error];
    // json格式错误
    if (error) {
        error = [NSError errorWithDomain:error.domain code:-1 userInfo:@{NSLocalizedDescriptionKey:@"数据加载失败"}];
        _completeBlock(nil, error, self->_isMock);
        return;
    }
    if (item.code.integerValue == 3) { // token失效
        [[NSNotificationCenter defaultCenter] postNotificationName:YXTokenInValidNotification
                                                            object:nil];
        return;
    }
    
    
    // 业务逻辑错误
    if (item.code.integerValue != 0 || item.code == nil) {
        error = [NSError errorWithDomain:@"数据错误" code:-2 userInfo:@{NSLocalizedDescriptionKey:item.desc.length==0? @"数据错误":item.desc}];
        _completeBlock(item, error, self->_isMock);
        return;
    }
    
    // 正常数据
    _completeBlock(item, nil, self->_isMock);
    
}





@end
