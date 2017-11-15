//
//  LSTCollectionFilterModel.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/9/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LSTCollectionFilterModel_ItemName : JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *itemID;
@property (nonatomic, strong) LSTCollectionFilterModel_ItemName<Optional> *itemName;

//用户操作筛选使用数据
@property (nonatomic, copy) NSString<Optional> *defaultSelected;//已确定的选择
@property (nonatomic, copy) NSString<Optional> *userSelected;//用户未点击确定前的选择
@property (nonatomic, copy) NSString<Optional> *defaultSelectedID;//已确定的用户选择ID
@property (nonatomic, copy) NSString<Optional> *userSelectedID;//用户未点击确定前的选择ID
@end

@protocol LSTCollectionFilterModel_Item <NSObject>

@end
@interface LSTCollectionFilterModel_Item : JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *itemID;
@property (nonatomic, strong) NSMutableArray<LSTCollectionFilterModel_Item, Optional> *item;
@end

@interface LSTCollectionFilterModel : JSONModel
@property (nonatomic, strong) LSTCollectionFilterModel_ItemName *itemName;
@property (nonatomic, strong) NSMutableArray<LSTCollectionFilterModel_Item, Optional> *item;
@end
