//
//  YXFileBrowseManager.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXFileItemBase.h"
#import "YXBaseViewController.h"

@interface YXFileBrowseManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) YXFileItemBase *fileItem;
@property (nonatomic, weak) YXBaseViewController *baseViewController;
- (void)addFavorWithData:(id)data completion:(void(^)())completeBlock; // 如果需要收藏，则调用此方法

- (void)browseFile;

@end
