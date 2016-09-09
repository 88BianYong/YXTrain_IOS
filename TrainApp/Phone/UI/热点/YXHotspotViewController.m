//
//  YXHotspotViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHotspotViewController.h"
#import "YXHotspotWordsCell.h"
#import "YXHotspotPictureCell.h"
#import "YXRotateListRequest.h"
#import "YXBroseWebView.h"
@interface YXHotspotViewController ()

@end

@implementation YXHotspotViewController

- (void)viewDidLoad {
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.title = @"热点";
    [self setupUI];
    [self layoutInterface];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"getRotateList_mock" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        NSError *error;
        YXRotateListRequestItem *requestItem = [[YXRotateListRequestItem alloc] initWithData:data error:&error];
        [self.dataArray addObjectsFromArray:requestItem.rotates];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - setupUI
- (void)setupUI{
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.estimatedRowHeight = 30.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXHotspotWordsCell class] forCellReuseIdentifier:@"YXHotspotWordsCell"];
    [self.tableView registerClass:[YXHotspotPictureCell class] forCellReuseIdentifier:@"YXHotspotPictureCell"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.0f)];
    self.tableView.tableHeaderView = headerView;
}

- (void)layoutInterface{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXRotateListRequestItem_Rotates *rotate = self.dataArray[indexPath.row];
    if (indexPath.row % 2 == 0) {
        YXHotspotWordsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHotspotWordsCell" forIndexPath:indexPath];
        cell.titleLabel.attributedText = [self contentStringWithDesc:rotate.name];
        cell.timeLabel.text= @"5小时前发布";
        return cell;
    } else {
        YXHotspotPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHotspotPictureCell" forIndexPath:indexPath];
        cell.titleLabel.attributedText = [self contentStringWithDesc:rotate.name];
        cell.timeLabel.text= @"5小时前发布";
        [cell.posterImageView sd_setImageWithURL:[NSURL URLWithString:rotate.resurl]];
        return cell;
    }
}
- (NSMutableAttributedString *)contentStringWithDesc:(NSString *)desc{
    NSRange range = NSMakeRange(0, desc.length);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:desc];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"334466"],NSParagraphStyleAttributeName:paragraphStyle} range:range];
    return attributedString;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YXRotateListRequestItem_Rotates *model = self.dataArray[indexPath.row];
    YXBroseWebView *webView = [[YXBroseWebView alloc] init];
    webView.urlString = model.typelink;
    webView.titleString = model.name;
    [self.navigationController pushViewController:webView animated:YES];
}
@end
