//
//  LSTCollectionFilterDefaultProtocol.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSTCollectionFilterDefaultModel.h"
@protocol LSTCollectionFilterDefaultProtocol <NSObject>
- (NSMutableArray<LSTCollectionFilterDefaultModel *> *)fomartCollectionFilterModel:(id)item;
@end
