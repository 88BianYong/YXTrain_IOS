//
//  MasterSchoolFilterView.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterSchoolTableView.h"
#import "YXCourseFilterCell.h"
@interface MasterSchoolTableView ()<UITableViewDelegate, UITableViewDataSource>
@end
@implementation MasterSchoolTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.delegate = self;
        self.dataSource = self;
        self.layer.cornerRadius = YXTrainCornerRadii;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = 44;
        [self registerClass:[YXCourseFilterCell class] forCellReuseIdentifier:@"YXCourseFilterCell"];
    }
    return self;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXCourseFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXCourseFilterCell" forIndexPath:indexPath];
    cell.filterName = self.groups[indexPath.row].name;
    cell.isCurrent = self.chooseInteger == indexPath.row;
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.chooseInteger = indexPath.row;
    BLOCK_EXEC(self.MasterSchoolTableViewBlock,self.groups[indexPath.row].barid);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = [self.groups[indexPath.row].name boundingRectWithSize:CGSizeMake(kScreenWidth - 35.0f - 12.0f, 80.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    return 44.0f + rect.size.height - kSingleLineTextHeight;
}
- (void)setGroups:(NSMutableArray<__kindof MasterManageListRequestItem_Body_Group *> *)groups {
    _groups = groups;
    [self reloadData];
}

@end
