//
//  YXPopUpViewSetDataAndActionProtocol.h
//  TrainApp
//
//  Created by Lei Cai on 8/18/16.
//  Copyright © 2016 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YXPopUpContainerView;
@protocol YXPopUpViewSetDataAndActionProtocol <NSObject>
- (void)setupConstrainsInContainerView:(YXPopUpContainerView *)v;
- (void)updateWithData:(id)data actions:(NSArray *)actions;
@end
