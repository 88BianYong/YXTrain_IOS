//
//  ProjectChooseLayerView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainLayerListRequest.h"
@interface ProjectChooseLayerView : UIView
@property (nonatomic, strong) NSMutableArray<__kindof TrainLayerListRequestItem_Body*> *dataMutableArray;
@property (nonatomic, copy) void (^projectChooseLayerCompleteBlock)(NSString *layerId);
@end
