//
//  YXCourseDetailViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseDetailViewController.h"
#import "YXCourseDetailRequest.h"
#import "YXModuleDetailRequest.h"
#import "YXCourseDetailCell.h"
#import "YXCourseDetailHeaderView.h"
#import "YXFileRecordManager.h"

@interface YXCourseDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXModuleDetailRequest *moduleDetailRequest;
@property (nonatomic, strong) YXCourseDetailRequest *courseDetailRequest;
@property (nonatomic, strong) YXCourseDetailItem *courseItem;
@end

@implementation YXCourseDetailViewController

- (void)dealloc{
    [[YXRecordManager sharedManager]clear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.course.course_title;
    [self setupUI];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"eceef2"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    self.tableView.rowHeight = 70;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(6);
    }];
    [self.tableView registerClass:[YXCourseDetailCell class] forCellReuseIdentifier:@"YXCourseDetailCell"];
    [self.tableView registerClass:[YXCourseDetailHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXCourseDetailHeaderView"];
}

- (void)getData{
    if (self.course.is_selected.integerValue == 0) {
        [self.courseDetailRequest stopRequest];
        self.courseDetailRequest = [[YXCourseDetailRequest alloc]init];
        self.courseDetailRequest.cid = self.course.courses_id;
        self.courseDetailRequest.stageid = self.course.module_id;
        self.courseDetailRequest.pid = [YXTrainManager sharedInstance].currentProject.pid;
        [self startLoading];
        WEAK_SELF
        [self.courseDetailRequest startRequestWithRetClass:[YXCourseDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self stopLoading];
            if (error) {
                [self showToast:error.localizedDescription];
                return;
            }
            YXCourseDetailRequestItem *item = (YXCourseDetailRequestItem *)retItem;
            [self dealWithCourseItem:item.body];
        }];
    }else{
        [self.moduleDetailRequest stopRequest];
        self.moduleDetailRequest = [[YXModuleDetailRequest alloc]init];
        self.moduleDetailRequest.cid = self.course.courses_id;
        self.moduleDetailRequest.w = [YXTrainManager sharedInstance].currentProject.w;
        self.moduleDetailRequest.pid = [YXTrainManager sharedInstance].currentProject.pid;
        [self startLoading];
        WEAK_SELF
        [self.moduleDetailRequest startRequestWithRetClass:[YXModuleDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self stopLoading];
            if (error) {
                [self showToast:error.localizedDescription];
                return;
            }
            YXModuleDetailRequestItem *item = (YXModuleDetailRequestItem *)retItem;
            [self dealWithCourseItem:item.body];
        }];
    }
}

- (void)dealWithCourseItem:(YXCourseDetailItem *)courseItem{
    courseItem.course_id = self.course.courses_id;
    self.courseItem = courseItem;
    [self.tableView reloadData];
    [[YXRecordManager sharedManager]setupWithCourseDetailItem:courseItem];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.courseItem.chapters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YXCourseDetailItem_chapter *chapter = self.courseItem.chapters[section];
    return chapter.fragments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXCourseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXCourseDetailCell"];
    YXCourseDetailItem_chapter *chapter = self.courseItem.chapters[indexPath.section];
    YXCourseDetailItem_chapter_fragment *fragment = chapter.fragments[indexPath.row];
    cell.data = fragment;
    if ([[YXFileRecordManager sharedInstance]hasRecordWithFilename:fragment.fragment_name url:fragment.url]) {
        cell.watched = YES;
    }else{
        cell.watched = NO;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YXCourseDetailHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXCourseDetailHeaderView"];
    YXCourseDetailItem_chapter *chapter = self.courseItem.chapters[section];
    header.title = chapter.chapter_name;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YXCourseDetailItem_chapter *chapter = self.courseItem.chapters[indexPath.section];
    YXCourseDetailItem_chapter_fragment *fragment = chapter.fragments[indexPath.row];
    
    YXFileType type = [YXAttachmentTypeHelper typeWithID:fragment.type];
    if (type == YXFileTypeUnknown) {
        [self showToast:@"移动端不支持当前课程学习"];
        return;
    }
    
    [[YXFileRecordManager sharedInstance]saveRecordWithFilename:fragment.fragment_name url:fragment.url];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [YXRecordManager sharedManager].chapterIndex = indexPath.section;
    [YXRecordManager sharedManager].fragmentIndex = indexPath.row;
    
    NSMutableString *fixUrl = [NSMutableString stringWithString:fragment.url];
    [fixUrl replaceOccurrencesOfString:@"\\" withString:@"/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [fixUrl length])];
    YXFileItemBase *item = nil;
    if (type == YXFileTypeVideo) {
        YXFileVideoItem *videoItem = [[YXFileVideoItem alloc]init];
        videoItem.url = fixUrl;
        videoItem.name = fragment.fragment_name;
        videoItem.lurl = fragment.lurl;
        videoItem.murl = fragment.murl;
        videoItem.surl = fragment.surl;
        item = videoItem;
    }else if (type == YXFileTypeAudio){
        YXFileAudioItem *audioItem = [[YXFileAudioItem alloc]init];
        audioItem.url = fixUrl;
        audioItem.name = fragment.fragment_name;
        item = audioItem;
    }else if (type == YXFileTypeDoc){
        YXFileDocItem *docItem = [[YXFileDocItem alloc]init];
        docItem.url = fixUrl;
        docItem.name = fragment.fragment_name;
        item = docItem;
    }else if (type == YXFileTypeHtml){
        YXFileHtmlItem *htmlItem = [[YXFileHtmlItem alloc]init];
        htmlItem.url = fixUrl;
        htmlItem.name = fragment.fragment_name;
        item = htmlItem;
    }
    
    if (item) {
        [YXFileBrowseManager sharedManager].fileItem = item;
        [YXFileBrowseManager sharedManager].baseViewController = self;
        [[YXFileBrowseManager sharedManager] browseFile];
    }
}

@end
