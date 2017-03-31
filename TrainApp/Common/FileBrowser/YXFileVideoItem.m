//
//  YXFileVideoItem.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFileVideoItem.h"
#import "YXPlayerViewController.h"
@implementation YXFileVideoClassworkItem
@end
@implementation YXFileVideoItem

- (void)openFile {
    YXPlayerViewController *vc = [[YXPlayerViewController alloc] init];
    id favorData = [self valueForKey:@"favorData"];
    if (favorData) {
        YXFileFavorWrapper *wrapper = [[YXFileFavorWrapper alloc]initWithData:favorData baseVC:vc];
        wrapper.delegate = self;
        vc.favorWrapper = wrapper;
    }
    vc.videoUrl = self.url;
    
    YXPlayerDefinition *d0 = [[YXPlayerDefinition alloc] init];
    d0.identifier = @"流畅";
    d0.url = self.lurl;
    
    YXPlayerDefinition *d1 = [[YXPlayerDefinition alloc] init];
    d1.identifier = @"标清";
    d1.url = self.murl;
    
    YXPlayerDefinition *d2 = [[YXPlayerDefinition alloc] init];
    d2.identifier = @"高清";
    d2.url = self.surl;
    
    vc.definitionArray = @[d0, d1, d2];
    
    vc.title = self.name;
    vc.delegate = self;
    vc.exitDelegate = self;
    vc.isPreRecord = self.isDeleteVideo;
    vc.sourceType = self.sourceType;
    vc.classworkMutableArray = [self quizeesExercisesFormatSgqz];
    vc.forcequizcorrect = self.forcequizcorrect.boolValue;
    vc.cid = self.cid;
    [[self.baseViewController visibleViewController] presentViewController:vc animated:YES completion:nil];
}
-(NSMutableArray<YXFileVideoClassworkItem *> *)quizeesExercisesFormatSgqz {
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSArray *quizees = [self.sgqz componentsSeparatedByString:@","];
    [quizees enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *temp = [obj componentsSeparatedByString:@"_"];
        if (temp.count == 2) {
            YXFileVideoClassworkItem *item = [[YXFileVideoClassworkItem alloc] init];
            item.quizzesID = temp[0];
            item.timeString = temp[1];
            item.isTrue = NO;
            [mutableArray addObject:item];
        }
    }];
    return mutableArray;
}
@end
