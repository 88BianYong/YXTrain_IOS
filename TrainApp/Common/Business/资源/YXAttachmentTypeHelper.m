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
             @"unknown":@(YXFileTypeUnknown),
             
             //2.5 文本阅读添加
             @"doc":@(YXFileTypeDoc),
             @"docx":@(YXFileTypeDoc),
             @"xls":@(YXFileTypeDoc),
             @"xlsx":@(YXFileTypeDoc),
             @"pptx":@(YXFileTypeDoc),
             @"pps":@(YXFileTypeDoc),
             @"ppsx":@(YXFileTypeDoc),
             @"flv":@(YXFileTypeVideo),
             @"rar":@(YXFileTypeUnknown),
             @"zip":@(YXFileTypeUnknown),
             @"jpg":@(YXFileTypePhoto),
             @"gif":@(YXFileTypePhoto),
             @"png":@(YXFileTypePhoto),
             @"bmp":@(YXFileTypePhoto),             
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
             @"unknown":@"未知",
              //2.5 文本阅读添加
             @"doc":@"word",
             @"docx":@"word",
             @"xls":@"excel",
             @"xlsx":@"excel",
             @"pptx":@"ppt",
             @"pps":@"ppt",
             @"ppsx":@"ppt",
             @"flv":@"mp4／m3u8",
             @"rar":@"未知",
             @"zip":@"未知",
             @"jpg":@"jpg-png-bmp",
             @"gif":@"jpg-png-bmp",
             @"png":@"jpg-png-bmp",
             @"bmp":@"jpg-png-bmp",
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
