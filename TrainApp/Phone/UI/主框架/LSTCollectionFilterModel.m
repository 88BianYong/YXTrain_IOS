//
//  LSTCollectionFilterModel.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/9/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LSTCollectionFilterModel.h"
@implementation LSTCollectionFilterModel_ItemName
- (NSString<Optional> *)defaultSelected {
    if (_defaultSelected == nil) {
        return @"-1";
    }
    return _defaultSelected;
}
- (NSString<Optional> *)userSelected {
    if (_userSelected == nil) {
        return self.defaultSelected;
    }
    return _userSelected;
}
- (NSString<Optional> *)userSelectedID {
    if (_userSelectedID == nil) {
        return self.defaultSelectedID;
    }
    return _userSelectedID;
}
@end
@implementation LSTCollectionFilterModel_Item

@end
@implementation LSTCollectionFilterModel
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}
@end
