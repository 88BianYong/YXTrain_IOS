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
            [self.selectedMutableDictionary setObject:@[(NSString *)changeObj,@""]
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
@end
