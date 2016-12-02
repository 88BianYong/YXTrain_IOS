//
//  BeijingActivityListViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingActivityListViewController.h"
#import "BeijingActivityListCell.h"
#import "ActivityListFetcher.h"
@interface BeijingActivityListViewController ()

@end

@implementation BeijingActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[BeijingActivityListCell class] forCellReuseIdentifier:@"BeijingActivityListCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BeijingActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeijingActivityListCell"];
    cell.activity = self.dataArray[indexPath.row];
    if (((ActivityListFetcher *)self.dataFetcher).stageid.integerValue == -2) {
        cell.isShowWorkshop = YES;
    }else {
        cell.isShowWorkshop = NO;
    }
    return cell;
}
@end
