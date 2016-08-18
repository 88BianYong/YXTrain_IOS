//
//  YXAppUpdatePopUpView.h
//  TrainApp
//
//  Created by Lei Cai on 8/18/16.
//  Copyright © 2016 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXPopUpViewSetDataAndActionProtocol.h"
#import "YXAlertCustomView.h"

@interface YXAppUpdateData : NSObject
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@end

@interface YXAppUpdatePopUpView : UIView <YXPopUpViewSetDataAndActionProtocol>
- (void)updateWithData:(YXAppUpdateData *)data actions:(NSArray *)actions;
@end
