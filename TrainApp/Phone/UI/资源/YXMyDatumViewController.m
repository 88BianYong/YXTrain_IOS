//
//  YXMyDatumViewController.m
//  TrainApp
//
//  Created by 李五民 on 16/6/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXMyDatumViewController.h"

@interface YXMyDatumViewController ()

@end

@implementation YXMyDatumViewController

- (void)viewDidLoad {
    [self setupDataFetcher];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupDataFetcher{
    self.wholeDatumFetcher = [[YXWholeDatumFetcher alloc]init];
    self.wholeDatumFetcher.pagesize = 20;
    NSDictionary *dic = @{@"interf":@"SearchFilter",@"source":@"ios"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (error) {
        self.wholeDatumFetcher.condition = nil;
    } else {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        self.wholeDatumFetcher.condition = jsonString;
    }
    self.dataFetcher = self.wholeDatumFetcher;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
