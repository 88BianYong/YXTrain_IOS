//
//  VideoCourseChapterViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseChapterViewController.h"
#import "YXCourseDetailRequest.h"
#import "YXModuleDetailRequest.h"
#import "YXCourseDetailCell.h"
#import "YXCourseDetailHeaderView.h"
#import "YXFileRecordManager.h"
@interface VideoCourseChapterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXModuleDetailRequest *moduleDetailRequest;
@property (nonatomic, strong) YXCourseDetailRequest *courseDetailRequest;
@property (nonatomic, strong) YXCourseDetailItem *courseItem;
@property (nonatomic, strong) YXFileItemBase *fileItem;
@property (nonatomic, copy) VideoCourseChapterFragmentCompleteBlock fragmentBlock;
@property (nonatomic, copy) VideoCourseIntroductionCompleteBlock introductionBlock;

@end

@implementation VideoCourseChapterViewController


- (void)dealloc{
    [[YXRecordManager sharedManager]clear];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.course.course_title;
    [self setupUI];
    [self requestForCourseDetail];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.rowHeight = 70;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0.0f);
    }];
    [self.tableView registerClass:[YXCourseDetailCell class] forCellReuseIdentifier:@"YXCourseDetailCell"];
    [self.tableView registerClass:[YXCourseDetailHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXCourseDetailHeaderView"];
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForCourseDetail];
    };
    self.emptyView = [[YXEmptyView alloc]init];
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self requestForCourseDetail];
    };
}

- (void)requestForCourseDetail{
    if (self.course.is_selected.integerValue == 0 && self.fromWhere == VideoCourseFromWhere_Detail) {
        [self.courseDetailRequest stopRequest];
        self.courseDetailRequest = [[YXCourseDetailRequest alloc]init];
        self.courseDetailRequest.cid = self.course.courses_id;
        self.courseDetailRequest.stageid = self.course.module_id;
        self.courseDetailRequest.pid = [YXTrainManager sharedInstance].currentProject.pid;
        WEAK_SELF
        [self.courseDetailRequest startRequestWithRetClass:[YXCourseDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            YXCourseDetailRequestItem *item = (YXCourseDetailRequestItem *)retItem;
            UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
            data.requestDataExist = item.body.chapters.count != 0;
            data.localDataExist = NO;
            data.error = error;
            if ([self handleRequestData:data]) {
                BLOCK_EXEC(self.fragmentBlock,error,nil,NO);
                return;
            }
            [self dealWithCourseItem:item.body];
        }];
    }else{
        [self.moduleDetailRequest stopRequest];
        self.moduleDetailRequest = [[YXModuleDetailRequest alloc]init];
        self.moduleDetailRequest.cid = self.course.courses_id;
        self.moduleDetailRequest.w = [YXTrainManager sharedInstance].currentProject.w;
        self.moduleDetailRequest.pid = [YXTrainManager sharedInstance].currentProject.pid;
        WEAK_SELF
        [self.moduleDetailRequest startRequestWithRetClass:[YXModuleDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            YXModuleDetailRequestItem *item = (YXModuleDetailRequestItem *)retItem;
            UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
            data.requestDataExist = item.body.chapters.count != 0;
            data.localDataExist = NO;
            data.error = error;
            if ([self handleRequestData:data]) {
                BLOCK_EXEC(self.fragmentBlock,error,nil,NO);
                return;
            }
            [self dealWithCourseItem:item.body];
        }];
    }
}

- (void)dealWithCourseItem:(YXCourseDetailItem *)courseItem{
    courseItem.course_id = self.course.courses_id;
    self.courseItem = courseItem;
    [[YXRecordManager sharedManager] setupWithCourseDetailItem:courseItem];
    [self willPlayVideo];
    BLOCK_EXEC(self.introductionBlock,self.courseItem);
}
- (void)willPlayVideo{
    YXCourseDetailItem_chapter_fragment *fragment = [self.courseItem willPlayVideoSeek:self.seekInteger];
    if (fragment) {
        self.fileItem = [self fileItemBaseFormatForChapterFragment:fragment];
        [[YXFileRecordManager sharedInstance] saveRecordWithFilename:fragment.fragment_name url:fragment.url];
       BLOCK_EXEC(self.fragmentBlock,nil,self.fileItem,YES);
        [YXRecordManager sharedManager].chapterIndex = self.courseItem.playIndexPath.section;
        [YXRecordManager sharedManager].fragmentIndex = self.courseItem.playIndexPath.row;
    }else {
        BLOCK_EXEC(self.fragmentBlock,nil,nil,NO);
    }
    [self.tableView reloadData];
    if (![self.tableView cellForRowAtIndexPath:self.courseItem.playIndexPath]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:self.courseItem.playIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
    }
}
- (void)readyNextWillplayVideoAgain:(BOOL)isAgain{
    if (isAgain) {
        self.courseItem.playIndexPath = nil;
    }
    YXCourseDetailItem_chapter_fragment *fragment = [self.courseItem willPlayVideoSeek:0];
    if (fragment) {
        self.fileItem = [self fileItemBaseFormatForChapterFragment:fragment];
        [[YXFileRecordManager sharedInstance] saveRecordWithFilename:fragment.fragment_name url:fragment.url];
        BLOCK_EXEC(self.fragmentBlock,nil,self.fileItem,YES);
        [YXRecordManager sharedManager].chapterIndex = self.courseItem.playIndexPath.section;
        [YXRecordManager sharedManager].fragmentIndex = self.courseItem.playIndexPath.row;
    }else {
        BLOCK_EXEC(self.fragmentBlock,nil,nil,YES);
    }
    [self.tableView reloadData];
    if (![self.tableView cellForRowAtIndexPath:self.courseItem.playIndexPath]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:self.courseItem.playIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
    }
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
        cell.cellStatus = YXCourseDetailCellStatus_Watched;
    }else{
        cell.cellStatus = YXCourseDetailCellStatus_Default;
    }
    if ([self.courseItem.playIndexPath isEqual:indexPath]) {
        cell.cellStatus = YXCourseDetailCellStatus_PLaying;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.courseItem.playIndexPath isEqual:indexPath]) {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    YXCourseDetailItem_chapter *chapter = self.courseItem.chapters[indexPath.section];
    YXCourseDetailItem_chapter_fragment *fragment = chapter.fragments[indexPath.row];
    YXFileType type = [YXAttachmentTypeHelper typeWithID:fragment.type];
    if (type == YXFileTypeUnknown) {
        [self showToast:@"移动端不支持当前课程学习"];
        return;
    }
    
    [[YXFileRecordManager sharedInstance] saveRecordWithFilename:fragment.fragment_name url:fragment.url];
    self.fileItem = [self fileItemBaseFormatForChapterFragment:fragment];
    if (self.fileItem.type == YXFileTypeVideo) {
        self.courseItem.playIndexPath = indexPath;
        BLOCK_EXEC(self.fragmentBlock,nil,self.fileItem,YES);
    }else{
        [self.fileItem browseFile];
    }
    [YXRecordManager sharedManager].chapterIndex = indexPath.section;
    [YXRecordManager sharedManager].fragmentIndex = indexPath.row;
    [self.tableView reloadData];
}
#pragma mark - data format
- (YXFileItemBase *)fileItemBaseFormatForChapterFragment:(YXCourseDetailItem_chapter_fragment *)fragment {
    YXFileType type = [YXAttachmentTypeHelper typeWithID:fragment.type];
    NSMutableString *fixUrl = [NSMutableString stringWithString:fragment.url];
    [fixUrl replaceOccurrencesOfString:@"\\" withString:@"/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [fixUrl length])];
    YXFileItemBase *fileItem = [FileBrowserFactory browserWithFileType:type];
    fileItem.type = type;
    fileItem.name = fragment.fragment_name;
    fileItem.url = fixUrl;
    fileItem.lurl = fragment.lurl;
    fileItem.murl = fragment.murl;
    fileItem.surl = fragment.surl;
    fileItem.cid = self.courseItem.c;
    fileItem.forcequizcorrect = self.courseItem.forcequizcorrect;
    fileItem.sgqz = fragment.sgqz;
    fileItem.source = self.courseItem.source;
    fileItem.baseViewController = self;
    fileItem.sourceType = YXSourceTypeCourse;
    fileItem.duration = fragment.duration;
    fileItem.record = fragment.record;
    return fileItem;
}
- (void)setVideoCourseChapterFragmentCompleteBlock:(VideoCourseChapterFragmentCompleteBlock)block {
    self.fragmentBlock = block;
}
- (void)setVideoCourseIntroductionCompleteBlock:(VideoCourseIntroductionCompleteBlock)block {
    self.introductionBlock = block;
}

@end
