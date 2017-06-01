//
//  YXFileItemBase.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXBaseViewController.h"
#import "YXBrowserExitDelegate.h"
#import "YXFileFavorWrapper.h"
#import "YXPlayProgressDelegate.h"
#import "YXBrowseTimeDelegate.h"

typedef NS_ENUM(NSUInteger, YXFileType) {
    YXFileTypeVideo,
    YXFileTypeAudio,
    YXFileTypePhoto,
    YXFileTypeDoc,
    YXFileTypeHtml,
    YXFileTypeUnknown
};
typedef NS_ENUM(NSUInteger, YXSourceType) {
    YXSourceTypeCourse = 1,//课程播放
    YXSourceTypeTaskNoUploadedVideos = 2//作业:未上传时播放
};
@interface YXFileItemBase : NSObject<YXBrowserExitDelegate,YXFileFavorDelegate,YXPlayProgressDelegate,YXBrowseTimeDelegate>

@property (nonatomic, assign) YXFileType type;
@property (nonatomic, assign) BOOL isLocal; // whether is a local file, default is NO.
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *lurl;
@property (nonatomic, strong) NSString *murl;
@property (nonatomic, strong) NSString *surl;

@property (nonatomic, strong) NSString *forcequizcorrect;
@property (nonatomic, strong) NSString *sgqz;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, assign) BOOL isDeleteVideo;// 需要删除按键YES  default is NO
@property (nonatomic, assign) YXSourceType sourceType;//仅上报数据使用  区分来源 + 区分是否显示防挂科

// 上报预存
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *record;




@property (nonatomic, weak) YXBaseViewController *baseViewController;
- (void)addFavorWithData:(id)data completion:(void(^)())completeBlock; // 如果需要收藏，则调用此方法
- (void)browseFile;
@end
