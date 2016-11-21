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
//             @"mp4":@(YXFileTypeVideo),
//             @"m3u8":@(YXFileTypeVideo),
//             @"txt":@(YXFileTypeDoc),
//             @"docx":@(YXFileTypeDoc),
//             @"mp3":@(YXFileTypeAudio),
//             @"jpg":@(YXFileTypePhoto),
//             @"bmp":@(YXFileTypePhoto),
//             @"png":@(YXFileTypePhoto),
//             @"xls":@(YXFileTypeDoc),
//             @"xlsx":@(YXFileTypeDoc),
//             @"rar":@(YXFileTypeUnknown),
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
//             @"mp4":@"mp4／m3u8",
//             @"m3u8":@"mp4／m3u8",
//             @"txt":@"txt",
//             @"docx":@"word",
//             @"mp3":@"mp3",
//             @"jpg":@"jpg-png-bmp",
//             @"bmp":@"jpg-png-bmp",
//             @"png":@"jpg-png-bmp",
//            @"xls":@"excel",
//             @"xlsx":@"excel",
//             @"rar":@"未知",
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
