//
//  CourseListRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseListRequest_17.h"
@implementation CourseListRequest_17Item_SearchTerm_MockSegment_Chapter
@end

@implementation CourseListRequest_17Item_SearchTerm_MockSegment_Grade
@end
@implementation CourseListRequest_17Item_SearchTerm_MockSegment

@end

@implementation CourseListRequest_17Item_Objs_Quiz
@end
@implementation CourseListRequest_17Item_Objs_Content
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"imgurl":@"imgUrl"}];
}
@end
@implementation CourseListRequest_17Item_Objs
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"trainingid":@"trainingID",
                                                       @"studycode":@"studyCode",
                                                       @"segmentcode":@"segmentCode",
                                                       @"id":@"objID",
                                                       @"timelength":@"timeLength",
                                                       @"stageid":@"stageID",
                                                       @"isfinish":@"isFinish",
                                                       @"timelengthsec":@"timeLengthSec"}];
}
@end

@implementation CourseListRequest_17Item_Scheme_Scheme
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"toolid":@"toolID",
                                                       @"finishnum":@"finishNum",
                                                       @"finishscore":@"finishScore"}];
}
@end
@implementation CourseListRequest_17Item_Scheme_Process
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"userfinishnum":@"userFinishNum",
                                                       @"userfinishscore":@"userFinishScore"}];
}
@end
@implementation CourseListRequest_17Item_Scheme
@end


@implementation CourseListRequest_17Item_SearchTerm_ModuleVo
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"moduleVoID",
                                                       @"stageid":@"stageID"}];
}
@end
@implementation CourseListRequest_17Item_SearchTerm_DefaultValue
@end

@implementation CourseListRequest_17Item_SearchTerm
- (NSMutableArray<CourseListRequest_17Item_SearchTerm_MockSegment,Optional> *)segmentModel {
    if (_segmentModel == nil) {
        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithDictionary:self.segments];
        mutableDictionary[@"0"] = @"通识";
        NSMutableArray<CourseListRequest_17Item_SearchTerm_MockSegment> *mutableArray = [[NSMutableArray<CourseListRequest_17Item_SearchTerm_MockSegment> alloc] init];
        NSArray *segmentsArray = [mutableDictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        WEAK_SELF
        [segmentsArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            STRONG_SELF
            CourseListRequest_17Item_SearchTerm_MockSegment *mockSegment = [[CourseListRequest_17Item_SearchTerm_MockSegment alloc] init];
            mockSegment.segmentID = obj;
            mockSegment.segmentName = mutableDictionary[obj];
            NSDictionary *chapterDic = self.studys[obj][@"c"];
            NSMutableArray<CourseListRequest_17Item_SearchTerm_MockSegment_Chapter> *chapterMutableArray = [[NSMutableArray<CourseListRequest_17Item_SearchTerm_MockSegment_Chapter> alloc] init];
            CourseListRequest_17Item_SearchTerm_MockSegment_Chapter *chapter = [[CourseListRequest_17Item_SearchTerm_MockSegment_Chapter alloc] init];
            chapter.chapterID = @"0";
            chapter.chapterName = @"通识";
            [chapterMutableArray addObject:chapter];
            NSArray *chapterArray = [chapterDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
            [chapterArray enumerateObjectsUsingBlock:^(NSString *cObj, NSUInteger idx, BOOL * _Nonnull stop) {
                CourseListRequest_17Item_SearchTerm_MockSegment_Chapter *chapter = [[CourseListRequest_17Item_SearchTerm_MockSegment_Chapter alloc] init];
                chapter.chapterID = cObj;
                chapter.chapterName = chapterDic[cObj];
                [chapterMutableArray addObject:chapter];
            }];
            mockSegment.chapter = chapterMutableArray;
            NSDictionary *gradeDic = self.studys[obj][@"g"];
            
            
            NSMutableArray<CourseListRequest_17Item_SearchTerm_MockSegment_Grade> *gradeMutableArray = [[NSMutableArray<CourseListRequest_17Item_SearchTerm_MockSegment_Grade> alloc] init];
            NSArray *gradeArray = [gradeDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
            [gradeArray enumerateObjectsUsingBlock:^(NSString *gObj, NSUInteger idx, BOOL * _Nonnull stop) {
                CourseListRequest_17Item_SearchTerm_MockSegment_Grade *grade = [[CourseListRequest_17Item_SearchTerm_MockSegment_Grade alloc] init];
                grade.gradeID = gObj;
                grade.gradeName = gradeDic[gObj];
                [gradeMutableArray addObject:grade];
            }];
            mockSegment.grade = gradeMutableArray;
            [mutableArray addObject:mockSegment];
        }];
        _segmentModel = mutableArray;
    }
    return _segmentModel;
}
- (NSIndexPath<Optional> *)selectedIndexPath {
    if (_selectedIndexPath == nil){
        __block NSInteger section = 0;
        __block NSInteger row = 0;
        [self.segmentModel enumerateObjectsUsingBlock:^(CourseListRequest_17Item_SearchTerm_MockSegment  *segment, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.defaultValue.segment.integerValue == segment.segmentID.integerValue) {
                section = idx;
                [segment.chapter enumerateObjectsUsingBlock:^(CourseListRequest_17Item_SearchTerm_MockSegment_Chapter *chapter, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (self.defaultValue.study.integerValue == chapter.chapterID.integerValue) {
                        row = idx;
                        self->_selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
                    }
                }];
            }
        }];
        if (_selectedIndexPath == nil) {
            self->_selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
         }
    }
    return _selectedIndexPath;
}
@end
@implementation CourseListRequest_17Item
@end

@implementation CourseListRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"projectid":@"projectID",
                                                       @"stageid":@"stageID",
                                                       @"thame":@"theme"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/course/list"];
    }
    return self;
}
@end
