//
//  ReadingDetailViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ReadingDetailViewController_17.h"
#import "ReadingDetailTableHeaderView_17.h"
#import "ReadingDetailAnnexCell_17.h"
#import "ReadingDetailHeaderView_17.h"
@interface ReadingDetailViewController_17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ReadingDetailTableHeaderView_17 *headerView;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) dispatch_source_t sourceTimer;
@property (nonatomic, strong) UIButton *readButton;

@end

@implementation ReadingDetailViewController_17
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
    if (self.sourceTimer) {
        dispatch_source_cancel(self.sourceTimer);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - set
- (void)setReading:(ReadingListRequest_17Item_Objs *)reading {
    _reading = reading;
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 150.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ReadingDetailHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"ReadingDetailHeaderView_17"];
    [self.tableView registerClass:[ReadingDetailAnnexCell_17 class] forCellReuseIdentifier:@"ReadingDetailAnnexCell_17"];
    self.headerView = [[ReadingDetailTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 335)];
    self.headerView.contentString = self.reading.content;
    WEAK_SELF
    self.headerView.readingDetailHeaderHeightChangeBlock = ^(CGFloat height) {
        STRONG_SELF
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, height);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.tableHeaderView = self.headerView;
            [self.headerView relayoutHtmlText];
        });
    };
    self.tableView.tableHeaderView = self.headerView;
    
    self.readButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.readButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.readButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"dfe2e6"]] forState:UIControlStateDisabled];
    [self.readButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateNormal];
    self.readButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.readButton.enabled = NO;
    [[self.readButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:self.readButton];
    [self readDocumentTime:self.readButton time:self.reading.timeLength.integerValue];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(44.0f);
    }];
    
    [self.readButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_offset(49.0f);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ReadingDetailHeaderView_17 *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ReadingDetailHeaderView_17"];
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NoticeAndBriefDetailRequestItem_Body_Affix *affix = self.itemBody.affix[indexPath.row];
//    YXFileType type = [YXAttachmentTypeHelper fileTypeWithTypeName:affix.res_type];
//    if(type == YXFileTypeUnknown) {
//        [self showToast:@"暂不支持该格式文件预览"];
//        return;
//    }
//    YXFileItemBase *fileItem = [FileBrowserFactory browserWithFileType:type];
//    fileItem.name = affix.resname;
//    fileItem.url = affix.previewurl;
//    fileItem.baseViewController = self;
//    [fileItem browseFile];
//    self.fileItem = fileItem;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.reading.affix == nil ? 0 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reading.affix == nil ? 0 : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadingDetailAnnexCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"ReadingDetailAnnexCell_17" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.affix = self.reading.affix;
    return cell;
}
- (void)readDocumentTime:(UIButton *)sender time:(NSInteger)intTime {
    __block NSInteger timeout = intTime;
    WEAK_SELF
    timeout -- ;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.sourceTimer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(self.sourceTimer, ^{
        STRONG_SELF
        if (timeout <= 0) {
            dispatch_source_cancel(self.sourceTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:@"我已阅读文档内容" forState:UIControlStateNormal];
                sender.enabled = YES;
            });
        }
        else {
            NSString *timeString = [NSString stringWithFormat:@"(%ld)我已阅读文档内容",(long)timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:timeString forState:UIControlStateNormal];
                sender.enabled = NO;
            });
            timeout -- ;
        }
    });
    dispatch_resume(self.sourceTimer);
}
@end
