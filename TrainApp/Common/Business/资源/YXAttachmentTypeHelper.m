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
    return @{@"video":@"视频",
             @"audio":@"MP3",
             @"text":@"TXT",
             @"image":@"image",
             @"pdf":@"pdf",
             @"ppt":@"ppt",
             @"word":@"word",
             @"excel":@"excel",
             @"unknown":@"datum_other"
             };
}

#pragma mark - 国培相关
+ (YXFileType)typeWithID:(NSString *)typeID {
    NSInteger value = typeID.integerValue;
    if (value == 0) {
        return YXFileTypeVideo;
    }else if (value == 1){
        return YXFileTypeDoc;
    }else if (value == 2){
        return YXFileTypeHtml;
    }else if (value == 3){
        return YXFileTypeAudio;
    }else{
        return YXFileTypeUnknown;
    }
}

@end
