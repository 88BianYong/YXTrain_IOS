//
//  VideoCourseSecondCommentViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseSecondCommentViewController.h"
#import "CommentPagedListFetcher.h"
#import "ActitvityCommentHeaderView.h"
#import "ActitvityCommentCell.h"
#import "ActitvityCommentFooterView.h"
#import "VideoCourseSecondCommentFooterView.h"
#import "VideoCourseCommentsFetcher.h"
#import "UITableView+TemplateLayoutHeaderView.h"
@interface VideoCourseSecondCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) VideoCourseSecondCommentRefreshBlock refreshBlock;
@end

@implementation VideoCourseSecondCommentViewController
- (void)dealloc {
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部回复";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.dataFetcher = [[VideoCourseCommentsFetcher alloc] init];
    self.dataFetcher.courseID = self.courseId;
    self.dataFetcher.parentID = self.parentID;
    [super setupUI];
    self.dataErrorView.isVideo = NO;
    self.emptyView.isVideo = NO;
    self.errorView.isVideo = NO;
    self.isFullReply = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[VideoCourseSecondCommentFooterView class] forHeaderFooterViewReuseIdentifier:@"VideoCourseSecondCommentFooterView"];
}
- (void)naviLeftAction {
    if (self.dataMutableArray.count > 0) {
        BLOCK_EXEC(self.refreshBlock ,self.chooseInteger ,self.dataMutableArray.count - 1);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataMutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        VideoCourseSecondCommentFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"VideoCourseSecondCommentFooterView"];
        footerView.replyNumber = self.dataMutableArray[0].childNum.integerValue;
        return footerView;
    }else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 30.0f;
    }else {
        return 0.0001f;
    }
}
- (void)formatCommentContent{
    [self.dataMutableArray addObject:self.comment];
}
- (void)firstShowInputView {
    if(self.isShowInputView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//动画执行需要延时
            [self userPublishComment];
        });
    }
}
- (void)setVideoCourseSecondCommentRefreshBlock:(VideoCourseSecondCommentRefreshBlock)block {
    self.refreshBlock = block;
}

@end
