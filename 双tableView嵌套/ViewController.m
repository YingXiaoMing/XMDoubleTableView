//
//  ViewController.m
//  双tableView嵌套
//
//  Created by Kenfor-YF on 16/4/9.
//  Copyright © 2016年 Kenfor-YF. All rights reserved.
//

#import "ViewController.h"
#import "XMButton.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
//组数据
@property(nonatomic,strong)NSArray *sectionArray;
//行数据
@property(nonatomic,strong)NSArray *rowArray;
@property(nonatomic,weak)UITableView *tableView;
//顶部数据
@property(nonatomic,weak)UILabel *header;
//判断cell是否展开
@property(nonatomic,strong)NSMutableDictionary *showDict;
//记录选中的headView
@property(nonatomic,assign)BOOL isSelected;

@end
static NSString *ID =@"VideoID";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self loadDate];
    
}
-(void)setupTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView = tableView;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    self.tableView.tableFooterView = [[UIView alloc]init];
}
-(void)loadDate
{
    self.sectionArray = @[@"设备一",@"设备二",@"设备三",@"设备四"];
    self.rowArray = @[@"前台",@"后台",@"办公室",@"行政室",@"走道一",@"走道二"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rowArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.textLabel.text = self.rowArray[indexPath.row];
    cell.clipsToBounds = YES;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    XMButton *btn = [XMButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:[NSString stringWithFormat:@"未选中的第%ld行",section + 1] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:[NSString stringWithFormat:@"选中的第%ld行",section + 1] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.tag = section;
    return btn;
}
-(void)btnClick:(XMButton *)button
{
    NSInteger didSection = button.tag;
    if (!self.showDict) { //字典如果为空的话
        self.showDict = [NSMutableDictionary dictionary];
    }
    NSString *key = [NSString stringWithFormat:@"%ld",didSection];
    if (![self.showDict objectForKey:key]) {
        [self.showDict setObject:@"isOn" forKey:key];
    }else{
        [self.showDict removeObjectForKey:key];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:didSection] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}
//动态设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.showDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]]) {
        return 44;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

@end
