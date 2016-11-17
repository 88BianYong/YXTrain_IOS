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
             @"html":@(YXFileTypeHtml),
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
#warning 待UI图出来之后替换为新设计的图!
             @"html":@"未知",//待UI图出来之后替换为新设计的图
             @"unknown":@"未知"
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
+ (NSString *)picNameWithID:(NSString *)typeID {
    NSInteger value = typeID.integerValue;
    if (value == 0) {
        return @"视频";
    }else if (value == 1){
        return @"pdf";
    }else if (value == 2){
        return @"网页";
    }else if (value == 3){
        return @"MP3";
    }else{
        return @"未知";
    }
}

@end
