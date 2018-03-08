//
//  MasterThemeListRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2018/3/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol MasterThemeListItem_Body_Theme @end
@interface MasterThemeListItem_Body_Theme : JSONModel
@property (nonatomic, copy) NSString<Optional> *themeId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *descr;
@property (nonatomic, copy) NSString<Optional> *isSelected;
@end
@interface MasterThemeListItem_Body : JSONModel
@property (nonatomic, strong) NSArray<MasterThemeListItem_Body_Theme, Optional> *themes;
@end

@interface MasterThemeListItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterThemeListItem_Body<Optional> *body;
@end
@interface MasterThemeListRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;

@end
