//
//  LSTCollectionFilterProtocol.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/4.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSTCollectionFilterModel.h"
@protocol LSTCollectionFilterProtocol <NSObject>
- (LSTCollectionFilterModel *)fomartCollectionFilterModel:(id)item;
@end
