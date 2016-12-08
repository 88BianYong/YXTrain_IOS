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
    return @{@"video":@"mp4／m3u8",
             @"audio":@"mp3",
             @"text":@"txt",
             @"image":@"jpg-png-bmp",
             @"pdf":@"pdf",
             @"ppt":@"ppt",
             @"word":@"word",
             @"excel":@"excel",
             @"html":@"html",
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
        return @"mp4／m3u8";
    }else if (value == 1){
        return @"pdf";
    }else if (value == 2){
        return @"html";
    }else if (value == 3){
        return @"mp3";
    }else{
        return @"未知";
    }
}

@end
