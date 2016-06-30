//
//  YXExamTaskProgressHeaderView.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXExamineRequest.h"

@interface YXExamTaskProgressHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) YXExamineRequestItem_body_bounsVoData *data;
@property (nonatomic, copy) void(^markAction)(UIButton *b);
@property (nonatomic, copy) void(^clickAction)();
@end
