//
//  YXScoreBounsGroupCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/9/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YXExpSubItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *score;
@end

@interface YXExpItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSArray *subItemArray;
@end

@interface YXScoreExpGroupCell : UITableViewCell
@property (nonatomic, strong)YXExpItem *data;
@end
