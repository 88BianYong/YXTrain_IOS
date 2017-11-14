//
//  LSTTrainHelper.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM (NSInteger, LSTTrainPresentProject) {
    LSTTrainPresentProject_Default = 1,
    LSTTrainPresentProject_Beijing = 2,
    LSTTrainPresentProject_DeYang = 3,
};
@interface LSTTrainHelper : NSObject
@property (nonatomic, copy) NSString *requireId;//北京项目专用
@property (nonatomic, copy) NSString *homeworkid;//北京项目专用

@property (nonatomic, assign, readonly) LSTTrainPresentProject presentProject;
@property (nonatomic, copy, readonly) NSString *workshopListTitle;
@property (nonatomic, copy, readonly) NSString *workshopDetailTitle;
@property (nonatomic, copy, readonly) NSString *workshopDetailName;
@property (nonatomic, copy, readonly) NSString *activityStageName;
@property (nonatomic, copy, readonly) NSString *firstHomeworkImageName;
@property (nonatomic, copy, readonly) NSString *w;

@property (nonatomic, strong, readonly) NSArray *sideMenuArray;



#pragma mark - show project
- (UIViewController<YXTrackPageDataProtocol> *)showExamProject;
- (void)courseInterfaceSkip:(UIViewController *)viewController;
- (void)workshopInterfaceSkip:(UIViewController *)viewController;
- (void)activityInterfaceSkip:(UIViewController *)viewController;
@end
