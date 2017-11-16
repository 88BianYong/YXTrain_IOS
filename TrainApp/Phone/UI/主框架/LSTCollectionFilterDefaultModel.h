//
//  LSTCollectionFilterDefaultModel.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol LSTCollectionFilterDefaultModelItem @end
@interface LSTCollectionFilterDefaultModelItem : JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *itemID;
@end

@interface LSTCollectionFilterDefaultModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *itemName;
@property (nonatomic, copy) NSString<Optional> *defaultSelected;//已确定的选择
@property (nonatomic, copy) NSString<Optional> *userSelected;//用户未点击确定前的选择
@property (nonatomic, copy,readonly) NSString<Optional> *defaultSelectedID;//已确定的用户选择ID
@property (nonatomic, strong) NSMutableArray<LSTCollectionFilterDefaultModelItem *> *item;
@end
