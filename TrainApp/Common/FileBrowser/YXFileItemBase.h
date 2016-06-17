//
//  YXFileItemBase.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YXFileType) {
    YXFileTypeVideo,
    YXFileTypeAudio,
    YXFileTypePhoto,
    YXFileTypeDoc,
    YXFileTypeHtml,
    YXFileTypeUnknown
};

@interface YXFileItemBase : NSObject

@property (nonatomic, assign) YXFileType type;
@property (nonatomic, assign) BOOL isLocal; // whether is a local file, default is NO.
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;

@end
