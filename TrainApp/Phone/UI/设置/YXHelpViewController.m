//
//  YXHelpViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHelpViewController.h"
#import "YXHelpHeaderView.h"
#import "YXHelpCell.h"
#import "YXEmptCell.h"
#import "YXFeedBackViewController.h"
static  NSString *const trackPageName = @"帮助与反馈页面";
static  NSString *const trackEventName = @"常见问题";
@interface YXHelpItem :NSObject
@property (nonatomic ,copy) NSString *titleString;
@property (nonatomic ,copy) NSString *contentString;
@property (nonatomic ,assign) BOOL isOpen;
@end

@implementation YXHelpItem

@end


@interface YXHelpViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataMutableArray;
@end

@implementation YXHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助与反馈";
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.dataMutableArray = [NSMutableArray arrayWithArray:[self formatData]];
    [self setupUI];
    [self layoutInterface];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - setupUI
- (void)setupUI{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15.0f, 0.0f, 0.0f);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.estimatedRowHeight = 150.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.0f)];
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 104.0f)];
    footerView.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor colorWithHexString:@"a53027"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"a53027"]] forState:UIControlStateHighlighted];
    [button setTitle:@"意见反馈" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    button.layer.cornerRadius = YXTrainCornerRadii;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor colorWithHexString:@"a53027"].CGColor;
    button.layer.masksToBounds = YES;
    button.frame = CGRectMake(0, 0, 255.0f, 44.0f);
    button.center = footerView.center;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    self.tableView.tableFooterView = footerView;
    
    
    [self.tableView registerClass:[YXHelpHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXHelpHeaderView"];
    [self.tableView registerClass:[YXHelpCell class] forCellReuseIdentifier:@"YXHelpCell"];
    [self.tableView registerClass:[YXEmptCell class] forCellReuseIdentifier:@"YXEmptCell"];
}

- (void)layoutInterface{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YXHelpItem *item = self.dataMutableArray[section];
    YXHelpHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXHelpHeaderView"];
    headerView.isOpen = item.isOpen;
    headerView.titleString = item.titleString;
    WEAK_SELF
    headerView.openAndClosedHandler = ^(BOOL boolState){
        STRONG_SELF
        item.isOpen = !boolState;
        if (item.isOpen) {
            switch (section) {
                case 0:
                    [YXDataStatisticsManger trackEvent:trackEventName label:@"《找到项目》" parameters:nil];
                    break;
                case 1:
                    [YXDataStatisticsManger trackEvent:trackEventName label:@"《哪里看课》" parameters:nil];
                    break;
                case 2:
                    [YXDataStatisticsManger trackEvent:trackEventName label:@"《看课记录在哪》" parameters:nil];
                    break;
                case 3:
                    [YXDataStatisticsManger trackEvent:trackEventName label:@"《无法写作业参加活动》" parameters:nil];
                    break;
                case 4:
                    [YXDataStatisticsManger trackEvent:trackEventName label:@"《哪里看成绩》" parameters:nil];
                    break;
                case 5:
                    [YXDataStatisticsManger trackEvent:trackEventName label:@"《能否传资源》" parameters:nil];
                    break;
                case 6:
                    [YXDataStatisticsManger trackEvent:trackEventName label:@"《能否发问答》" parameters:nil];
                    break;
                default:
                    break;
            }

        }
        [tableView beginUpdates];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    };
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataMutableArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHelpItem *item = self.dataMutableArray[indexPath.section];
    if (item.isOpen) {
        YXHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHelpCell" forIndexPath:indexPath];
        cell.contentString = item.contentString;
        return cell;
    }else{
        YXEmptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXEmptCell" forIndexPath:indexPath];
        return cell;
    }
    return nil;
    
}

#pragma mark - fromat data
- (NSArray *)formatData{
    
    YXHelpItem *item1 = [[YXHelpItem alloc] init];
    item1.titleString = @"如何找到我的在培项目?";
    item1.contentString = @"如您只参加了一个在培项目，进入手机研修后会默认当前的一个项目。如参加了多个在培项目请点击最上方向下的箭头后，选择对应的项目名称进入.";
    item1.isOpen = NO;
    
    YXHelpItem *item2 = [[YXHelpItem alloc] init];
    item2.titleString = @"哪里可以看到课程呢?";
    item2.contentString = @"进入手机研修后，默认到考核页面，点击课程后进入课程列表，就可以观看课程了。在课程列表处还可以根据学段、学科、阶段选择课程进行学习.";
    item2.isOpen = NO;
    
    
    YXHelpItem *item3 = [[YXHelpItem alloc] init];
    item3.titleString = @"我的看课记录在哪里查到?";
    item3.contentString = @"点击课程列表右上角的看课记录就可以查询到您的看课情况啦.";
    item3.isOpen = NO;
    
    
    YXHelpItem *item4 = [[YXHelpItem alloc] init];
    item4.titleString = @"为什么无法写作业和参加活动?";
    item4.contentString = @"手机研修目前只开放了课程观看的功能，作业和活动暂时未开放，请您到电脑端完成.";
    item4.isOpen = NO;
    
    YXHelpItem *item5 = [[YXHelpItem alloc] init];
    item5.titleString = @"我的学习成绩从哪里查到?";
    item5.contentString = @"进入手机研修后，在默认的总成绩处点击进入就看查询到您的总的学习成绩和阶段的学习成绩啦.";
    item5.isOpen = NO;
    
    YXHelpItem *item6 = [[YXHelpItem alloc] init];
    item6.titleString = @"我想在手机研修上传资源可以吗?";
    item6.contentString = @"目前手机研修只开放了资源查看的功能，上传暂时未开放，请您到电脑端完成.";
    item6.isOpen = NO;
    
    YXHelpItem *item7 = [[YXHelpItem alloc] init];
    item7.titleString = @"我想在手机研修的工作坊发问答可以吗?";
    item7.contentString = @"目前手机研修的工作坊只开放了工作坊人员查看和资源查看功能，其他功能暂时未开放，请您到电脑端完成.";
    item7.isOpen = NO;
    return @[item1,item2,item3,item4,item5,item6,item7];
}

#pragma mark - button Action
- (void)buttonAction:(UIButton *)button{
    YXFeedBackViewController *VC = [[YXFeedBackViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}
@end

