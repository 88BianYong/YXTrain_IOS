//
//  StudentsLearnController.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StudentsLearnController.h"
#import "StudentsLearnSwipeCell.h"
@interface StudentsLearnController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation StudentsLearnController
- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理";
    [self setupUI];
    [self setupLayout];
    [self setupRightWithTitle:@"编辑"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup UI
- (void)setupUI {
    [self.tableView registerClass:[StudentsLearnSwipeCell class] forCellReuseIdentifier:@"StudentsLearnSwipeCell"];
}
- (void)setupLayout {
    [self stopLoading];
}
- (void)naviRightAction {
    self.editing = !self.editing;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView reloadData];
}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentsLearnSwipeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentsLearnSwipeCell" forIndexPath:indexPath];
    [cell setupModeEditable:self.editing];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  @"编辑";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    self.editing = YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.editing) {
        return UITableViewCellEditingStyleDelete;
    }else {
        return UITableViewCellEditingStyleNone;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentsLearnSwipeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isChooseBool = !cell.isChooseBool;
}

@end
