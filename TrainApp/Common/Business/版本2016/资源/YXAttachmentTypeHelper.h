//
//  YXAttachmentTypeHelper.h
//  YanXiuApp
//
//  Created by Lei Cai on 6/10/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXFileItemBase.h"

@interface YXAttachmentTypeHelper : NSObject

+ (YXFileType)fileTypeWithTypeName:(NSString *)typeName;
+ (NSString *)picNameWithTypeName:(NSString *)typeName;

// 国培
+ (YXFileType)typeWithID:(NSString *)typeID;
+ (NSString *)picNameWithID:(NSString *)typeID;

@end
