//
//  YXWriteHomeworkInfoViewController+Format.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWriteHomeworkInfoViewController+Format.h"
#import "YXCategoryListRequest.h"
@implementation YXWriteHomeworkInfoViewController (Format)
- (void)subjectWithSchoolSection:(YXCategoryListRequestItem_Data *)model {
    self.subjectCell.contentString = @"";
    [self.selectedMutableDictionary removeObjectForKey:@(YXWriteHomeworkListStatus_Subject)];
    if (model.sub.count > 0) {
        self.subjectCell.isEnabled = YES;
        [self.listMutableDictionary setObject:model.sub forKey:@(YXWriteHomeworkListStatus_Subject)];
    }else{
        self.subjectCell.isEnabled = NO;
        [self.listMutableDictionary removeObjectForKey:@(YXWriteHomeworkListStatus_Subject)];
    }
}

- (void)versionWithSubject:(YXCategoryListRequestItem_Data *)model {
    self.versionCell.contentString = @"";
    [self.selectedMutableDictionary removeObjectForKey:@(YXWriteHomeworkListStatus_Version)];
    if (model.sub.count > 0) {
        self.versionCell.isEnabled = YES;
        [self.listMutableDictionary setObject:model.sub forKey:@(YXWriteHomeworkListStatus_Version)];
    }else{
        self.versionCell.isEnabled = NO;
        [self.listMutableDictionary removeObjectForKey:@(YXWriteHomeworkListStatus_Version)];
    }
}

- (void)gradeWithVersion:(YXCategoryListRequestItem_Data *)model {
    self.gradeCell.contentString = @"";
    [self.selectedMutableDictionary removeObjectForKey:@(YXWriteHomeworkListStatus_Grade)];
    if (model.sub.count > 0) {
        self.gradeCell.isEnabled = YES;
        [self.listMutableDictionary setObject:model.sub forKey:@(YXWriteHomeworkListStatus_Grade)];
    }else{
        self.gradeCell.isEnabled = NO;
        [self.listMutableDictionary removeObjectForKey:@(YXWriteHomeworkListStatus_Grade)];
    }
}
- (void)chapterWithGrade{
    self.chapterList = nil;
    self.menuView.item = nil;
    [self.listMutableDictionary removeObjectForKey:@(YXWriteHomeworkListStatus_Menu)];
}

- (BOOL)analyzingInformationNotComplete:(YXWriteHomeworkListStatus)status{
    switch (status) {
        case YXWriteHomeworkListStatus_Title:
        {
            return isEmpty([self.selectedMutableDictionary objectForKey:@(status)][1]);
        }
            break;
        case YXWriteHomeworkListStatus_SchoolSection:
        {
            return isEmpty([self.selectedMutableDictionary objectForKey:@(status)]);
        }
            break;
        case YXWriteHomeworkListStatus_Subject:
        {
            if (isEmpty([self.selectedMutableDictionary objectForKey:@(status)])
                && ((NSArray *)self.listMutableDictionary[@(status)]).count > 0) {
                return YES;
            }
        }
            break;
        case YXWriteHomeworkListStatus_Version:
        {
            if (isEmpty([self.selectedMutableDictionary objectForKey:@(status)])
                && ((NSArray *)self.listMutableDictionary[@(status)]).count > 0) {
                return YES;
            }
        }
            break;
        case YXWriteHomeworkListStatus_Grade:
        {
            if (isEmpty([self.selectedMutableDictionary objectForKey:@(status)])
                && ((NSArray *)self.listMutableDictionary[@(status)]).count > 0) {
                return YES;
            }
        }
            break;
        case YXWriteHomeworkListStatus_Menu:
        {
            if (isEmpty([self.selectedMutableDictionary objectForKey:@(status)])
                && self.chapterList) {
                return YES;
            }
        }
            break;
        case YXWriteHomeworkListStatus_Topic:
        {
            return isEmpty([self.selectedMutableDictionary objectForKey:@(status)][1]);
        }
            break;
            
        default:
            break;
    }
    return NO;
}


- (BOOL)saveInfoHomeWorkShowToast:(BOOL)isShow {
    if([self analyzingInformationNotComplete:YXWriteHomeworkListStatus_Title]) {
        if (isShow) {
            
            //[self showToast:@"请填写作业标题"];
        }
        return NO;
    }
    
    if([self analyzingInformationNotComplete:YXWriteHomeworkListStatus_SchoolSection]) {
        if (isShow) {
            //[self showToast:@"请选择学段信息"];
        }
        return NO;
    }
    
    if([self analyzingInformationNotComplete:YXWriteHomeworkListStatus_Subject]) {
        if (isShow) {
            //[self showToast:@"请选择学科信息"];
        }
        return NO;
    }
    
    
    if([self analyzingInformationNotComplete:YXWriteHomeworkListStatus_Version]) {
        if (isShow) {
            //[self showToast:@"请选择版本信息"];
        }
        return NO;
    }
    
    if([self analyzingInformationNotComplete:YXWriteHomeworkListStatus_Grade]) {
        if (isShow) {
            //[self showToast:@"请选择年级信息"];
        }
        return NO;
    }
    
    
    if([self analyzingInformationNotComplete:YXWriteHomeworkListStatus_Menu]) {
        if (isShow) {
            //[self showToast:@"请选择目录信息"];
        }
        return NO;
    }
    
    
    if([self analyzingInformationNotComplete:YXWriteHomeworkListStatus_Topic]) {
        if (isShow) {
            //[self showToast:@"请填写研修重难点"];
        }
        return NO;
    }
    return YES;
}

- (void)showWorkhomeInfo:(YXWriteHomeworkListStatus)status withChangeObj:(id)changeObj{
    switch (status) {
        case YXWriteHomeworkListStatus_Title:
        {
            NSString *titleString = (NSString *)changeObj;
            if (!isEmpty(titleString)) {
                [self.selectedMutableDictionary setObject:@[@"",titleString] forKey:@(status)];
            }else{
                [self.selectedMutableDictionary removeObjectForKey:@(status)];
            }
        }
            break;
        case YXWriteHomeworkListStatus_SchoolSection:
        {
            NSInteger index = [(NSNumber *)changeObj integerValue];
            YXCategoryListRequestItem_Data *model = self.listMutableDictionary[@(status)][index];
            self.schoolSectionCell.isEnabled = YES;
            self.schoolSectionCell.contentString = model.name;
            if(![model.categoryId isEqualToString:self.selectedMutableDictionary[@(status)][0]]){
                [self.selectedMutableDictionary setObject:@[model.categoryId,model.name] forKey:@(status)];
                [self subjectWithSchoolSection:model];
                [self versionWithSubject:nil];
                [self gradeWithVersion:nil];
                [self chapterWithGrade];
            }
        }
            break;
        case YXWriteHomeworkListStatus_Subject:
        {
            NSInteger index = [(NSNumber *)changeObj integerValue];
            YXCategoryListRequestItem_Data *model = self.listMutableDictionary[@(status)][index];
            self.subjectCell.isEnabled = YES;
            self.subjectCell.contentString = model.name;
            if(![model.categoryId isEqualToString:self.selectedMutableDictionary[@(status)][0]]){
                [self.selectedMutableDictionary setObject:@[model.categoryId,model.name] forKey:@(status)];
                [self versionWithSubject:model];
                [self gradeWithVersion:nil];
                [self chapterWithGrade];
            }
        }
            break;
        case YXWriteHomeworkListStatus_Version:
        {
            NSInteger index = [(NSNumber *)changeObj integerValue];
            YXCategoryListRequestItem_Data *model = self.listMutableDictionary[@(status)][index];
            self.versionCell.isEnabled = YES;
            self.versionCell.contentString = model.name;
            if(![model.categoryId isEqualToString:self.selectedMutableDictionary[@(status)][0]]){
                [self.selectedMutableDictionary setObject:@[model.categoryId,model.name]
                                                   forKey:@(status)];
                [self gradeWithVersion:model];
                [self chapterWithGrade];
            }
        }
            break;
        case YXWriteHomeworkListStatus_Grade:
        {
            NSInteger index = [(NSNumber *)changeObj integerValue];
            YXCategoryListRequestItem_Data *model = self.listMutableDictionary[@(status)][index];
            self.gradeCell.isEnabled = YES;
            self.gradeCell.contentString = model.name;
            if(![model.categoryId isEqualToString:self.selectedMutableDictionary[@(status)][0]]){
                [self.selectedMutableDictionary setObject:@[model.categoryId,model.name]
                                                   forKey:@(status)];
                [self requestForChapterList];
            }
        }
            break;
        case YXWriteHomeworkListStatus_Menu:
        {
            NSArray *menuArray = (NSArray *)changeObj;
            [self.selectedMutableDictionary setObject:@[menuArray[0],menuArray[1]]
                                               forKey:@(status)];
        }
            break;
        case YXWriteHomeworkListStatus_Topic:
        {
            NSString *topic = (NSString *)changeObj;
            if (!isEmpty(topic)) {
                [self.selectedMutableDictionary setObject:@[@"",topic] forKey:@(status)];
            }else{
                [self.selectedMutableDictionary removeObjectForKey:@(status)];
            }
        }
            break;
            
        default:
            break;
    }
    self.bottomView.saveButton.selected = [self saveInfoHomeWorkShowToast:NO];
}
- (NSString *)getCategoryIds{
    NSString *cId = [NSString stringWithFormat:@"%@,%@,%@,%@",
                     self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_SchoolSection)][0]?:@"",
                     self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Subject)][0]?:@"",
                     self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Version)][0]?:@"",
                     self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Grade)][0]]?:@"";
    return cId;
}

- (void)saveWorkhomeInfo:(YXWriteHomeworkRequestItem_Body *)body{
    //学段
    NSArray *schoolSection = self.listMutableDictionary[@(YXWriteHomeworkListStatus_SchoolSection)];
    for (YXCategoryListRequestItem_Data *model in schoolSection) {
        if ([model.categoryId isEqualToString:body.meizi_segment]) {
            [self.selectedMutableDictionary setObject:@[model.categoryId,model.name] forKey:@(YXWriteHomeworkListStatus_SchoolSection)];
            [self subjectWithSchoolSection:model];
        }
    }
    //学科
    NSArray *subject = self.listMutableDictionary[@(YXWriteHomeworkListStatus_Subject)];
    for (YXCategoryListRequestItem_Data *model in subject) {
        if ([model.categoryId isEqualToString:body.meizi_study]) {
            [self.selectedMutableDictionary setObject:@[model.categoryId,model.name] forKey:@(YXWriteHomeworkListStatus_Subject)];
            [self versionWithSubject:model];
        }
    }
    //版本
    NSArray *version = self.listMutableDictionary[@(YXWriteHomeworkListStatus_Version)];
    for (YXCategoryListRequestItem_Data *model in version) {
        if ([model.categoryId isEqualToString:body.meizi_edition]) {
            [self.selectedMutableDictionary setObject:@[model.categoryId,model.name] forKey:@(YXWriteHomeworkListStatus_Version)];
            [self gradeWithVersion:model];
        }
    }
    //年级
    NSArray *grade = self.listMutableDictionary[@(YXWriteHomeworkListStatus_Grade)];
    for (YXCategoryListRequestItem_Data *model in grade) {
        if ([model.categoryId isEqualToString:body.meizi_grade]) {
            [self.selectedMutableDictionary setObject:@[model.categoryId,model.name] forKey:@(YXWriteHomeworkListStatus_Grade)];
            [self chapterWithGrade];
        }
    }
    [self.selectedMutableDictionary setObject:@[@"",body.title] forKey:@(YXWriteHomeworkListStatus_Title)];
    [self.selectedMutableDictionary setObject:@[@"",body.meizi_keyword] forKey:@(YXWriteHomeworkListStatus_Topic)];
    self.videoModel.fileName = body.upload.fileName;
    self.bottomView.topicString = self.selectedMutableDictionary[@(YXWriteHomeworkListStatus_Topic)][1];
}
- (void)saveChapterList{
    if (!isEmpty(self.homeworkItem.body.meizi_chapter)) {
        NSArray *array = [self.homeworkItem.body.meizi_chapter componentsSeparatedByString:@","];
        __block  YXChapterListRequestItem_sub *sub = nil;
        __block  NSInteger section = 0;
        __block  NSInteger row = 0;
        [self.chapterList.data enumerateObjectsUsingBlock:^(YXChapterListRequestItem_sub * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.chapterId isEqualToString:array[0]]) {
                section = idx;
                sub = obj;
                *stop = YES;
            }
        }];
        [sub.sub enumerateObjectsUsingBlock:^(YXChapterListRequestItem_sub *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.chapterId isEqualToString:array[1]]) {
                row = idx;
                [self.selectedMutableDictionary setObject:@[self.homeworkItem.body.meizi_chapter?:@"",obj.name?:@""] forKey:@(YXWriteHomeworkListStatus_Menu)];
                *stop = YES;
            }
        }];
        self.chapterIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    }
    self.bottomView.saveButton.selected = [self saveInfoHomeWorkShowToast:NO];
}
@end
