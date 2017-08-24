//
//  Data_statisticsVC.m
//  BletcShop
//
//  Created by Bletc on 2017/8/23.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "Data_statisticsVC.h"
#import "Data_stastCell.h"
#import "DOPDropDownMenu.h"
@interface Data_statisticsVC ()<UITableViewDelegate,UITableViewDataSource,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>
{
    DOPDropDownMenu *_menu;
    CGFloat contentOffset_y;
    
    CGFloat origin_Y;
}
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UITableView *table_View;
@property (strong, nonatomic) IBOutlet UIView *menu_backView;

@property(nonatomic,strong) NSArray *content_A;

@property(nonatomic,strong)NSArray *date_A;
@property BOOL show;
@end

@implementation Data_statisticsVC


-(NSArray *)content_A{
    if (!_content_A) {
        _content_A = @[
  @{@"title":@"办卡",@"allMoney":@"办卡总金额",@"allCount":@"办卡笔数",@"allPeople":@"办卡人数"},
  @{@"title":@"续卡",@"allMoney":@"续卡总金额",@"allCount":@"续卡笔数",@"allPeople":@"续卡人数"},
  @{@"title":@"升级",@"allMoney":@"升级总金额",@"allCount":@"升级笔数",@"allPeople":@"升级人数"}];
    }
    return  _content_A;
}
-(NSArray *)date_A{
    if (!_date_A) {
        NSArray *year_A = @[@"2016",@"2017"];
        NSArray *month_A = @[@"全年",@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];

        
        _date_A = @[year_A,month_A];
    }
    return _date_A;
}





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
 
    
    self.table_View.estimatedRowHeight = 100;
    self.table_View.rowHeight = UITableViewAutomaticDimension;
    self.table_View.sectionHeaderHeight= 0.01;
    self.table_View.sectionFooterHeight = 40;
    self.table_View.showsVerticalScrollIndicator = NO;
    UIView *view= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    view.backgroundColor = RGB(240,240,240);
    self.table_View.tableFooterView= view;
    self.table_View.tableHeaderView = self.headerView;
    

    CGPoint point = [_menu_backView convertPoint:CGPointMake(0, 0) toView:self.view];
    origin_Y = point.y;
    
    
    __weak typeof(self) weakSelf = self;
    _menu = [[DOPDropDownMenu alloc]initWithOrigin:point andHeight:self.menu_backView.height andSuperView:self.view];
    _menu.menuRowClcikBolck = ^(NSInteger currentIndex, BOOL show) {
        weakSelf.show = show;
        
        if (show) {
            contentOffset_y =weakSelf.table_View.contentOffset.y;

        }
        [weakSelf.view bringSubviewToFront: [weakSelf.view viewWithTag:999]];

    };

    _menu.delegate = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
   
    
    [self.view bringSubviewToFront: [self.view viewWithTag:999]];

}


-(NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    
    return self.date_A[indexPath.column][indexPath.row];
}

-(NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    
    
    return [self.date_A[column] count];
}
-(NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    return self.date_A.count;
}


-(void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    NSLog(@"------%ld",indexPath.row);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.content_A.count;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.footView;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Data_stastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"data_statiseID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"Data_stastCell" owner:self options:nil] firstObject];
    }
    
    NSDictionary *dic = self.content_A[indexPath.row];
    cell.title_lab.text = dic[@"title"];
    cell.peo_lab.text = dic[@"allPeople"];
    cell.mon_lab.text = dic[@"allMoney"];
    cell.num_lab.text = dic[@"allCount"];
    
    return cell;
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if (scrollView.contentOffset.y <0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    
    
    if (self.show) {
        scrollView.contentOffset = CGPointMake(0, contentOffset_y);
        
    }

    CGRect frame = _menu.frame;
    frame.origin.y = origin_Y-scrollView.contentOffset.y;
    _menu.frame = frame;
    
    
}
- (IBAction)rightBtnClick:(id)sender {
    
}
- (IBAction)leftBtnclick:(id)sender {
    POP
}

- (IBAction)lookOtherTap:(UITapGestureRecognizer *)sender {
}


@end
