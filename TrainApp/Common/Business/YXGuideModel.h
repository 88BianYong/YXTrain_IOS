//
//  YXGuideModel.h
//  TrainApp
//
//  Created by 李五民 on 16/7/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YXGuideModel : JSONModel

@property (nonatomic, copy) NSString *guideImageString;
@property (nonatomic, copy) NSString *guideTitle;
@property (nonatomic, assign) BOOL isShowButton;

@end
