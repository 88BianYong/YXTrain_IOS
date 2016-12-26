//
//  AccountListView.m
//  TrainApp
//
//  Created by niuzhaowang on 2016/12/26.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "AccountListView.h"

@interface Account : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *password;
+ (Account *)accountWithName:(NSString *)name password:(NSString *)password;
@end
@implementation Account
+ (Account *)accountWithName:(NSString *)name password:(NSString *)password {
    Account *account = [[Account alloc]init];
    account.name = name;
    account.password = password;
    return account;
}
@end

@interface AccountGroup : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<__kindof Account *> *accounts;
+ (AccountGroup *)accountGroupWithName:(NSString *)name accounts:(NSArray<__kindof Account *> *)accounts;
@end
@implementation AccountGroup
+ (AccountGroup *)accountGroupWithName:(NSString *)name accounts:(NSArray<__kindof Account *> *)accounts {
    AccountGroup *group = [[AccountGroup alloc]init];
    group.name = name;
    group.accounts = accounts;
    return group;
}
@end

//////////////////////////////////////////////

@interface AccountListView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray<__kindof AccountGroup *> *groups;
@end
@implementation AccountListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupData];
        [self setupUI];
    }
    return self;
}

- (void)setupData {
    Account *a1 = [Account accountWithName:@"XY02307737@yanxiu.com" password:@"youkedenglu"];
    Account *a2 = [Account accountWithName:@"22222" password:@"11111"];
    Account *a3 = [Account accountWithName:@"33333" password:@"11111"];
    AccountGroup *g1 = [AccountGroup accountGroupWithName:@"AAA" accounts:@[a1,a2,a3]];
    
    Account *a4 = [Account accountWithName:@"44444" password:@"11111"];
    Account *a5 = [Account accountWithName:@"55555" password:@"11111"];
    Account *a6 = [Account accountWithName:@"66666" password:@"11111"];
    AccountGroup *g2 = [AccountGroup accountGroupWithName:@"BBB" accounts:@[a4,a5,a6]];
    
    Account *a7 = [Account accountWithName:@"77777" password:@"11111"];
    Account *a8 = [Account accountWithName:@"88888" password:@"11111"];
    Account *a9 = [Account accountWithName:@"99999" password:@"11111"];
    AccountGroup *g3 = [AccountGroup accountGroupWithName:@"CCC" accounts:@[a7,a8,a9]];
    
    self.groups = @[g1,g2,g3];
}

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc]init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups[section].accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.groups[indexPath.section].accounts[indexPath.row].name;
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.groups[section].name;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Account *account = self.groups[indexPath.section].accounts[indexPath.row];
    BLOCK_EXEC(self.accountSelectBlock,account.name,account.password);
}

@end
