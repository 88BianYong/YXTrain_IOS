//
//  YXFileAudioItem.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileAudioItem.h"
#import "YXAudioPlayerViewController.h"

@implementation YXFileAudioItem

- (void)openFile {
    [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainDocumentRetryTimer object:@(YES)];
    YXAudioPlayerViewController *vc = [[YXAudioPlayerViewController alloc] init];
    id favorData = [self valueForKey:@"favorData"];
    if (favorData) {
        YXFileFavorWrapper *wrapper = [[YXFileFavorWrapper alloc]initWithData:favorData baseVC:vc];
        wrapper.delegate = self;
        vc.favorWrapper = wrapper;
    }
    vc.videoUrl = self.url;
    vc.title = self.name;
    vc.delegate = self;
    vc.exitDelegate = self;
    vc.reportString = self.reportTitle;
    [[self.baseViewController visibleViewController] presentViewController:vc animated:YES completion:nil];
}

@end
