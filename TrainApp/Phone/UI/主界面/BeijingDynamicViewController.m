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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BeijingDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeijingDynamicCell" forIndexPath:indexPath];
    YXDynamicRequestItem_Data *data = self.dataArray[indexPath.row];
    cell.data = data;
    return cell;
}
@end
