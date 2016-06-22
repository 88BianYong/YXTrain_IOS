//
//  YXAttachmentTypeHelper.m
//  YanXiuApp
//
//  Created by Lei Cai on 6/10/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXAttachmentTypeHelper.h"

@implementation YXAttachmentTypeHelper

+ (YXFileType)fileTypeWithTypeName:(NSString *)typeName {
    return ((NSString *)[self fileTypeMap][typeName]).integerValue;
}

+ (NSDictionary *)fileTypeMap {
    return @{@"video":@(YXFileTypeVideo),
             @"audio":@(YXFileTypeAudio),
             @"text":@(YXFileTypeDoc),
             @"image":@(YXFileTypePhoto),
             @"pdf":@(YXFileTypeDoc),
             @"ppt":@(YXFileTypeDoc),
             @"word":@(YXFileTypeDoc),
             @"excel":@(YXFileTypeDoc),
             @"unknown":@(YXFileTypeUnknown)
             };
}

+ (NSString *)picNameWithTypeName:(NSString *)typeName {
    return [self picNameMap][typeName];
}

+ (NSDictionary *)picNameMap {
    return @{@"video":@"datum_video",
             @"audio":@"datum_audio",
             @"text":@"datum_txt",
             @"image":@"datum_pic",
             @"pdf":@"datum_pdf",
             @"ppt":@"datum_ppt",
             @"word":@"datum_word",
             @"excel":@"datum_excel",
             @"unknown":@"datum_other"
             };
}

@end
