//
//  MasterInputScrollView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SAMTextView.h>
typedef NS_ENUM(NSUInteger,MasterInputStatus) {
    MasterInputStatus_All = 0,
    MasterInputStatus_Score = 1,
    MasterInputStatus_Comment = 2,
    MasterInputStatus_Recommend = 3,
    MasterInputStatus_Cancle = 4,
};
@interface MasterInputView_17 : UIView
@property (nonatomic, strong) SAMTextView *scoreTextView;
@property (nonatomic, strong) SAMTextView *commentTextView;
@property (nonatomic, assign) MasterInputStatus inputStatus;
@property (nonatomic, copy) void(^masterInputViewBlock)(MasterInputStatus status);
- (void)clearContent:(MasterInputStatus) inputStatus;
@end
