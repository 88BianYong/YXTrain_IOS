//
//  MasterOverallRatingSearchView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterOverallRatingSearchView_17 : UIView
@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, copy)void(^textBeginEdit)(void);
@property (nonatomic, copy)void(^textShouldClear)(void);
@property (nonatomic, copy)void(^textShouldReturn)(NSString *key);
@property (nonatomic, copy)void(^texEndEdit)(void);
@property (nonatomic, copy)void(^cancelButtonClickedBlock)(void);

- (void)setFirstResponse;

- (void)setTextFieldWithString:(NSString *)string;
@end
