//
//  VideoCourseIntroductionViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseIntroductionViewController.h"
#import "VideoCourseIntroductionCell.h"
#import "VideoCourseIntroductionHeaderView.h"
@interface VideoCourseIntroductionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> *introductionMutableArray;
@end

@implementation VideoCourseIntroductionViewController

- (void)viewDidLoad {
    //[self setupModel];
    [super viewDidLoad];
    self.introductionMutableArray = [[NSMutableArray alloc] initWithCapacity:3];
    [self setupUI];
    [self setupLayout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - setupUI 
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 44.0f;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[VideoCourseIntroductionCell class] forCellReuseIdentifier:@"VideoCourseIntroductionCell"];
    [self.tableView registerClass:[VideoCourseIntroductionHeaderView class] forHeaderFooterViewReuseIdentifier:@"VideoCourseIntroductionHeaderView"];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)setCourseItem:(YXCourseDetailItem *)courseItem {
    [self.introductionMutableArray removeAllObjects];
    _courseItem = courseItem;
    self.title = _courseItem.course_title;
    YXCourseDetailItem_chapter *chapter = self.courseItem.chapters[_courseItem.playIndexPath.section];
    YXCourseDetailItem_chapter_fragment *fragment = chapter.fragments[_courseItem.playIndexPath.row];
    [fragment.items enumerateObjectsUsingBlock:^(YXCourseDetailItem_chapter_fragment_items *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *introductionString = [NSString stringWithFormat:@"%@%@",obj.sgtnm?:@"",obj.sgdes?:@""];
        [self.introductionMutableArray addObject:introductionString];
    }];
    if (self.introductionMutableArray.count == 0) {
        [self.courseItem.mti enumerateObjectsUsingBlock:^(YXCourseDetailItem_mti *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *introductionString = [NSString stringWithFormat:@"%@%@",obj.ctn?:@"",obj.cti?:@""];
            [self.introductionMutableArray addObject:introductionString];
        }];
    }
    [self.tableView reloadData];
}
#pragma mark - UITableViewDelegate 
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VideoCourseIntroductionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"VideoCourseIntroductionHeaderView"];
    headerView.score = self.courseItem.score;
    headerView.titleString = self.title;
    return headerView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.courseItem) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.introductionMutableArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCourseIntroductionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCourseIntroductionCell" forIndexPath:indexPath];

    cell.introduction = self.introductionMutableArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001f;
}
@end
