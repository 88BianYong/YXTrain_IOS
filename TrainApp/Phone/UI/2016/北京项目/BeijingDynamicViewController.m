//
//  BeijingDynamicViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingDynamicViewController.h"
#import "BeijingDynamicCell.h"

@interface BeijingDynamicViewController ()

@end

@implementation BeijingDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重要提醒";
    [self.tableView registerClass:[BeijingDynamicCell class] forCellReuseIdentifier:@"BeijingDynamicCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BeijingDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeijingDynamicCell" forIndexPath:indexPath];
    YXDynamicRequestItem_Data *data = self.dataArray[indexPath.row];
    cell.data = data;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXDynamicRequestItem_Data *data = self.dataArray[indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:@"BeijingDynamicCell" configuration:^(BeijingDynamicCell *cell) {
        cell.data = data;
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
