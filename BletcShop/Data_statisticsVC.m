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
#import "ScanMoreDataVC.h"
#import "NewBuyCardRecordVC.h"
#import "ChatForAllDatasVC.h"
@interface Data_statisticsVC ()<UITableViewDelegate,UITableViewDataSource,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>
{
    DOPDropDownMenu *_menu;
    CGFloat contentOffset_y;
    
    CGFloat origin_Y;
    
    NSString *year_s;
    NSString *month_s;
    
}
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UITableView *table_View;
@property (strong, nonatomic) IBOutlet UIView *menu_backView;
@property (strong, nonatomic) IBOutlet UILabel *total_money;

@property(nonatomic,strong) NSArray *content_A;
@property(nonatomic,strong) NSDictionary *data_dic;

@property(nonatomic,strong)NSArray *date_A;
@property BOOL show;
@end

@implementation Data_statisticsVC

-(NSDictionary *)data_dic{
    if (!_data_dic) {
        _data_dic = [NSDictionary dictionary];
    }
    return _data_dic;
}

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
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
      NSString *nowdate =  [formatter stringFromDate:date];
        NSMutableArray *year_A = [NSMutableArray array];
        
        for (int i = [nowdate intValue]; i >= 2016; i --) {
            
            [year_A addObject:[NSString stringWithFormat:@"%d年",i]];
        }
        

        NSArray *month_A = @[@"全年",@"01月",@"02月",@"03月",@"04月",@"05月",@"06月",@"07月",@"08月",@"09月",@"10月",@"11月",@"12月"];

        
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

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

    [_menu selectDefalutIndexPath];
    
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
    
    if (indexPath.column ==0) {
        year_s = [[menu titleForRowAtIndexPath:indexPath] stringByReplacingOccurrencesOfString:@"年" withString:@""];
    }
    if (indexPath.column ==1) {
        month_s = [[menu titleForRowAtIndexPath:indexPath] stringByReplacingOccurrencesOfString:@"月" withString:@""];
        
    }

    
   
    self.date_string = (![month_s isEqualToString:@"全年"] &&  month_s.length !=0) ? [NSString stringWithFormat:@"%@-%@",year_s,month_s] : year_s;
    
    
    [self getdataWithDate:_date_string];
    
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
    
    
    if (indexPath.row == 0) {
        cell.moneylab.text = [NSString stringWithFormat:@"%.2f",[[NSString getTheNoNullStr:self.data_dic[@"card_buy"][@"sum"] andRepalceStr:@"0"] floatValue]];
        
        cell.peopleLab.text = [NSString getTheNoNullStr:self.data_dic[@"card_buy"][@"mem"] andRepalceStr:@"0"];
        cell.numberlab.text = [NSString getTheNoNullStr:self.data_dic[@"card_buy"][@"num"] andRepalceStr:@"0"];

    }
    
   
    if (indexPath.row == 1) {
        cell.moneylab.text = [NSString stringWithFormat:@"%.2f",[[NSString getTheNoNullStr:self.data_dic[@"card_renew"][@"sum"] andRepalceStr:@"0"] floatValue]];
        cell.peopleLab.text = [NSString getTheNoNullStr:self.data_dic[@"card_renew"][@"mem"] andRepalceStr:@"0"];
        cell.numberlab.text = [NSString getTheNoNullStr:self.data_dic[@"card_renew"][@"num"] andRepalceStr:@"0"];
        
    }

    if (indexPath.row == 2) {
        cell.moneylab.text = [NSString stringWithFormat:@"%.2f",[[NSString getTheNoNullStr:self.data_dic[@"card_upgrade"][@"sum"] andRepalceStr:@"0"] floatValue]];
        cell.peopleLab.text = [NSString getTheNoNullStr:self.data_dic[@"card_upgrade"][@"mem"] andRepalceStr:@"0"];
        cell.numberlab.text = [NSString getTheNoNullStr:self.data_dic[@"card_upgrade"][@"num"] andRepalceStr:@"0"];
        
    }

    cell.moneylab.textColor = ([cell.moneylab.text intValue]==0) ?RGB(242,55,36): RGB(19,162,49);
    cell.peopleLab.textColor = ([cell.peopleLab.text intValue]==0) ?RGB(242,55,36): RGB(19,162,49);
    cell.numberlab.textColor = ([cell.numberlab.text intValue]==0) ?RGB(242,55,36): RGB(19,162,49);

   
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PUSH(NewBuyCardRecordVC)
    vc.title = [self.content_A[indexPath.row][@"title"] stringByAppendingString:@"明细"];
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
    
    AppDelegate *dele=(AppDelegate *)[UIApplication sharedApplication].delegate;
    ChatForAllDatasVC *chatForAllDatasVC=[[ChatForAllDatasVC alloc]init];
    NSString *string = (![month_s isEqualToString:@"全年"] &&  month_s.length !=0) ? [NSString stringWithFormat:@"%@-%@",year_s,month_s] : year_s;
    chatForAllDatasVC.url=[NSString stringWithFormat:@"http://www.cnconsum.com/cnconsum/App/Extra/chart/getTotalChart?muid=%@&date=%@",dele.shopInfoDic[@"muid"],string];
    [self.navigationController pushViewController:chatForAllDatasVC animated:YES];
}
- (IBAction)leftBtnclick:(id)sender {
    POP
}

- (IBAction)lookOtherTap:(UITapGestureRecognizer *)sender {
    
    PUSH(ScanMoreDataVC)
}


-(void)getdataWithDate:(NSString*)date{
    
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/DataCount/getTotalData",BASEURL];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];

    [paramer setValue:date forKey:@"date"];
    [paramer setValue:app.shopInfoDic[@"muid"] forKey:@"muid"];

    NSLog(@"---%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        
        self.data_dic = result;
        
        self.total_money.text = [NSString stringWithFormat:@"%.2f元",[self.data_dic[@"total_sum"] doubleValue]];
        
        [self.table_View reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    
}

@end
