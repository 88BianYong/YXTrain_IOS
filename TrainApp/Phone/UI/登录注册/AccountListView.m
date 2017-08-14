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
    Account *a11 = [Account accountWithName:@"test2016@yanxiu.com" password:@"123456"];
    Account *a12 = [Account accountWithName:@"XY00000163@yanxiu.com" password:@"123456"];
    Account *a13 = [Account accountWithName:@"XY00000193@yanxiu.com" password:@"888888"];
    AccountGroup *g1 = [AccountGroup accountGroupWithName:@"(非北京)测试环境帐号" accounts:@[a11,a12,a13]];
    Account *a21 = [Account accountWithName:@"XY02735506@yanxiu.com" password:@"123456"];
    Account *a22 = [Account accountWithName:@"XY02698346@yanxiu.com" password:@"888888"];
    Account *a23 = [Account accountWithName:@"XY02693619@yanxiu.com" password:@"123456"];
    AccountGroup *g2 = [AccountGroup accountGroupWithName:@"(非北京)正式环境帐号" accounts:@[a21,a22,a23]];
    
    Account *a31 = [Account accountWithName:@"XY03127583@yanxiu.com" password:@"888888"];
    Account *a32 = [Account accountWithName:@"JYY32329@yanxiu.com" password:@"888888"];
    Account *a33 = [Account accountWithName:@"JYY32330@yanxiu.com" password:@"888888"];
    Account *a34 = [Account accountWithName:@"JYY24294@yanxiu.com" password:@"123456"];
    AccountGroup *g3 = [AccountGroup accountGroupWithName:@"(德阳+北京)测试环境帐号" accounts:@[a31,a32,a33,a34]];
    
    Account *a51 = [Account accountWithName:@"XY03019240@yanxiu.com" password:@"123456"];
    AccountGroup *g4 = [AccountGroup accountGroupWithName:@"(北京)正式环境帐号" accounts:@[a51]];
    self.groups = @[g1,g2,g3,g4];
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
