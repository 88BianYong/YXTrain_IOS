//
//  VideoClassworkHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXVideoQuestionsRequest.h"
@interface VideoClassworkHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) YXVideoQuestionsRequestItem_Result_Questions_Question *question;
@end
