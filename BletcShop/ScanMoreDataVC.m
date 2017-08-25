//
//  ScanMoreDataVC.m
//  BletcShop
//
//  Created by Bletc on 2017/8/24.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ScanMoreDataVC.h"
#import "Data_stastCell.h"
#import "DOPDropDownMenu.h"
#import "NewBuyCardRecordVC.h"

@interface ScanMoreDataVC ()<UITableViewDelegate,UITableViewDataSource,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>
{
    DOPDropDownMenu *_menu;
    NSString *year_s;
    NSString *month_s;
}
@property (strong, nonatomic) IBOutlet UITableView *table_View;
@property(nonatomic,strong) NSArray *content_A;
@property(nonatomic,strong) NSDictionary *data_dic;

@property(nonatomic,strong)NSArray *date_A;
@end

@implementation ScanMoreDataVC
-(NSDictionary *)data_dic{
    if (!_data_dic) {
        _data_dic = [NSDictionary dictionary];
    }
    return _data_dic;
}

-(NSArray *)content_A{
    if (!_content_A) {
        _content_A = @[
                       @{@"title":@"消费",@"allMoney":@"消费总金额",@"allCount":@"消费笔数",@"allPeople":@"消费人数"},
                       @{@"title":@"现金支付",@"allMoney":@"支付金额",@"allCount":@"支付笔数",@"allPeople":@"支付人数"}];
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
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"更多详情";
    LEFTBACK
    self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    
    self.table_View.estimatedRowHeight = 100;
    self.table_View.rowHeight = UITableViewAutomaticDimension;
  
    
    _menu = [[DOPDropDownMenu alloc]initWithOrigin:CGPointMake(0, 0) andHeight:43 andSuperView:self.view];
    
    
    _menu.delegate = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
    
    
    [_menu selectDefalutIndexPath];

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
    
    
    
    NSString *string = (![month_s isEqualToString:@"全年"] &&  month_s.length !=0) ? [NSString stringWithFormat:@"%@-%@",year_s,month_s] : year_s;
    
    
    [self getdataWithDate:string];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.content_A.count;
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
        cell.moneylab.text = [NSString stringWithFormat:@"%.2f",[[NSString getTheNoNullStr:self.data_dic[@"consum"][@"sum"] andRepalceStr:@"0"] floatValue]];
        cell.peopleLab.text = [NSString getTheNoNullStr:self.data_dic[@"consum"][@"mem"] andRepalceStr:@"0"];
        cell.numberlab.text = [NSString getTheNoNullStr:self.data_dic[@"consum"][@"num"] andRepalceStr:@"0"];
        
    }
    
    
    if (indexPath.row == 1) {
        cell.moneylab.text = [NSString stringWithFormat:@"%.2f",[[NSString getTheNoNullStr:self.data_dic[@"tally"][@"sum"] andRepalceStr:@"0"] floatValue]];
        cell.peopleLab.text = [NSString getTheNoNullStr:self.data_dic[@"tally"][@"mem"] andRepalceStr:@"0"];
        cell.numberlab.text = [NSString getTheNoNullStr:self.data_dic[@"tally"][@"num"] andRepalceStr:@"0"];
        
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


-(void)getdataWithDate:(NSString*)date{
    
    NSString *url = [NSString stringWithFormat:@"%@MerchantType/DataCount/getExtraData",BASEURL];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary*paramer = [NSMutableDictionary dictionary];
    
    [paramer setValue:date forKey:@"date"];
    [paramer setValue:app.shopInfoDic[@"muid"] forKey:@"muid"];
    
    NSLog(@"---%@",paramer);
    
    [KKRequestDataService requestWithURL:url params:paramer httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"---%@",result);

        self.data_dic = result;
        
        
        [self.table_View reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

@end
