//
//  WebsocketRedLeftView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/1/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "WebsocketRedLeftView.h"
#import "YXUploadHeadImgRequest.h"
#import "YXUserProfile.h"
#import "YXUserProfileRequest.h"
#import "TrainRedPointManger.h"
@implementation WebsocketRedLeftView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupInterface];
    }
    return self;
}
#pragma mark - setup
- (void)setupInterface {
    self.button.frame = CGRectMake(0, 0, 32.0f, 32.0f);
    [self.button sd_setBackgroundImageWithURL:[NSURL URLWithString:[LSTSharedInstance sharedInstance].userManger.userModel.profile.head] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXUploadUserPicSuccessNotification object:nil]subscribeNext:^(id x) {
        [self.button sd_setBackgroundImageWithURL:[NSURL URLWithString:[LSTSharedInstance sharedInstance].userManger.userModel.profile.head] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXUserProfileGetSuccessNotification object:nil]subscribeNext:^(id x) {
        [self.button sd_setBackgroundImageWithURL:[NSURL URLWithString:[LSTSharedInstance sharedInstance].userManger.userModel.profile.head] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    }];
    self.button.backgroundColor = [UIColor redColor];
    self.button.layer.cornerRadius = 16;
    self.button.clipsToBounds = YES;
}
- (void)webSocketReceiveMessage:(NSNotification *)aNotification{
    if ([LSTSharedInstance sharedInstance].trainManager.trainHelper.presentProject == LSTTrainPresentProject_Beijing) {
        self.redPointNumber = [TrainRedPointManger sharedInstance].hotspotInteger > 0 ? 0 : -1;
    }else {
        self.redPointNumber = [TrainRedPointManger sharedInstance].showRedPointInteger;
    }
}
@end
