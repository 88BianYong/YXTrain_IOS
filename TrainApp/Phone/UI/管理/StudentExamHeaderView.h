//
//  StudentExamHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 17/2/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXExamineRequest.h"
@interface StudentExamHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) YXExamineRequestItem_body_bounsVoData *data;
@end
