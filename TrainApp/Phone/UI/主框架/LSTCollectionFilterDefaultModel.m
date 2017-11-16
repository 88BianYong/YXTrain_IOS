//
//  LSTCollectionFilterDefaultModel.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LSTCollectionFilterDefaultModel.h"
@implementation LSTCollectionFilterDefaultModelItem
@end
@implementation LSTCollectionFilterDefaultModel
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
- (NSString<Optional> *)defaultSelectedID {
    if (self.item.count > self.defaultSelected.integerValue) {
        return self.item[self.defaultSelected.integerValue].itemID;
    }
    return @"0";
}
@end
