//
//  YXWriteHomeworkInfoViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "YXWriteHomeworkInfoCell.h"
#import "YXWriteHomeworkInfoBottomView.h"
#import "YXHomeworkInfoRequest.h"
#import "YXChapterListRequest.h"
#import "YXWriteHomeworkRequest.h"
#import "YXCategoryListRequest.h"
#import "YXWriteHomeworkInfoMenuView.h"
#import "YXUpdVideoHomeworkRequest.h"
#import "YXSaveHomeWorkRequest.h"
#import "WriteHomeworkmanager.h"
@interface YXWriteHomeworkInfoViewController : YXBaseViewController
@property (nonatomic, strong)YXHomeworkInfoRequestItem_Body  *videoModel;
@property (nonatomic, strong)YXChapterListRequestItem *chapterList;
@property (nonatomic, strong)YXWriteHomeworkRequestItem *homeworkItem;
@property (nonatomic, strong)YXCategoryListRequestItem *listItem;
@property (nonatomic, strong)NSMutableDictionary *listMutableDictionary;
@property (nonatomic, strong)NSMutableDictionary *selectedMutableDictionary;
@property (nonatomic, strong)NSIndexPath *chapterIndexPath;
@property (nonatomic ,assign) BOOL isChangeHomeworkInfo;

@property (nonatomic, strong)YXWriteHomeworkInfoBottomView *bottomView;
@property (nonatomic, weak)YXWriteHomeworkInfoCell *schoolSectionCell;
@property (nonatomic, weak)YXWriteHomeworkInfoCell *subjectCell;
@property (nonatomic, weak)YXWriteHomeworkInfoCell *versionCell;
@property (nonatomic, weak)YXWriteHomeworkInfoCell *gradeCell;
@property (nonatomic, weak)YXWriteHomeworkInfoMenuView *menuView;
@property (nonatomic, strong)UITableView *tableView;



@property (nonatomic, strong)YXChapterListRequest *chapterRequest;
@property (nonatomic, strong) WriteHomeworkManager *managerRequest;

@end
