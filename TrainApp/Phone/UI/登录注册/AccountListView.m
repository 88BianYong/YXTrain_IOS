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
@property (nonatomic, strong) NSMutableArray<__kindof AccountGroup *> *groups;
@end
@implementation AccountListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.groups = [[NSMutableArray<__kindof AccountGroup*> alloc] init];
        [self setupData];
        [self setupUI];
    }
    return self;
}

- (void)setupData {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"account" ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *account = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    [account enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = obj[@"groupContent"];
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        [array enumerateObjectsUsingBlock:^(NSDictionary *content, NSUInteger idx, BOOL * _Nonnull stop) {
            Account *account = [Account accountWithName:content[@"userName"] password:content[@"password"]];
            [mutableArray addObject:account];
        }];
        AccountGroup *group = [AccountGroup accountGroupWithName:obj[@"groupName"] accounts:mutableArray];
        [self.groups addObject:group];
    }];
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
