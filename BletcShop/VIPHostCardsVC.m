//
//  VIPHostCardsVC.m
//  BletcShop
//
//  Created by apple on 2017/10/16.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "VIPHostCardsVC.h"
#import "VIPHostCardsTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface VIPHostCardsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    SDRefreshHeaderView *_refreshheader;
    SDRefreshFooterView *_refreshFooter;
    UIImageView *head;
    UILabel *nick;
    UILabel *totalMoney;
}
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSourse_A;
@end

@implementation VIPHostCardsVC
-(NSMutableArray *)dataSourse_A{
    if (!_dataSourse_A) {
        _dataSourse_A = [NSMutableArray array];
    }
    return _dataSourse_A;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.index = 1;//buy_sum
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(13, 23, SCREENWIDTH-26, SCREENHEIGHT-64-23)];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.layer.cornerRadius=6;
    bgView.clipsToBounds=YES;
    bgView.layer.borderWidth=1.0f;
    bgView.layer.borderColor=RGB(220, 220, 220).CGColor;
    [self.view addSubview:bgView];
    
    head=[[UIImageView alloc]initWithFrame:CGRectMake(11, 11, 54, 54)];
    head.image=[UIImage imageNamed:@""];
    head.layer.cornerRadius=27;
    head.clipsToBounds=YES;
    [bgView addSubview:head];
    
    nick=[[UILabel alloc]initWithFrame:CGRectMake(11, head.bottom+4, head.width+100, 16)];
    nick.text=@"";
    nick.textColor=RGB(51,51,51);
    nick.font=[UIFont systemFontOfSize:13];
    [bgView addSubview:nick];
    
    totalMoney=[[UILabel alloc]initWithFrame:CGRectMake(head.right+10, 0, bgView.width-head.right-10, nick.bottom+5)];
    totalMoney.text=@"";
    totalMoney.textAlignment=NSTextAlignmentCenter;
    totalMoney.font=[UIFont systemFontOfSize:18];
    totalMoney.textColor=RGB(241,122,18);
    [bgView addSubview:totalMoney];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, totalMoney.bottom, bgView.width, 1)];
    line.backgroundColor=RGB(220, 220, 220);
    [bgView addSubview:line];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, line.bottom, bgView.width, SCREENHEIGHT-64-112) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight=600;
    _tableView.rowHeight=UITableViewAutomaticDimension;
    [bgView addSubview:_tableView];
    
    [self getdataRequest];
    
    _refreshheader = [SDRefreshHeaderView refreshView];
    [_refreshheader addToScrollView:_tableView];
    _refreshheader.isEffectedByNavigationController = NO;
    
    __block typeof(self)tempSelf =self;
    _refreshheader.beginRefreshingOperation = ^{
        tempSelf.index=1;
        //请求数据
        [tempSelf getdataRequest];
    };
    
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:_tableView];
    _refreshFooter.beginRefreshingOperation =^{
        tempSelf.index++;
        //数据请求
        [tempSelf getdataRequest];
        
    };
}
-(void)getdataRequest{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/member/getConsum",BASEURL];
    //http://101.201.100.191/cnconsum/App/MerchantType/member/getConsum
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:self.dic[@"uuid"] forKey:@"uuid"];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:[NSString stringWithFormat:@"%ld",self.index] forKey:@"index"];
    NSLog(@"params---%@",params);
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result===%@",result);
        [_refreshFooter endRefreshing];
        [_refreshheader endRefreshing];
        if (_index ==1) {
            [self.dataSourse_A removeAllObjects];
            
            self.dataSourse_A = [result[@"consum_list"] mutableCopy];
            
        }else{
            [self.dataSourse_A addObjectsFromArray:result[@"consum_list"]];
        }
        [head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,result[@"info"][@"headImage"]]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
        nick.text=[NSString getTheNoNullStr:result[@"info"][@"nickname"] andRepalceStr:@""];
        totalMoney.text=[NSString stringWithFormat:@"消费总额：%@元",[NSString getTheNoNullStr:result[@"consum_sum"] andRepalceStr:@"0"]];
        
        NSString *costMoney=[NSString stringWithFormat:@"%@",[NSString getTheNoNullStr:result[@"consum_sum"] andRepalceStr:@"0"]];
        float total=[costMoney floatValue];
        totalMoney.text=[NSString stringWithFormat:@"消费总额：%@元",[NSString stringWithFormat:@"%.2f",total]];
        
        [self.tableView reloadData];
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        [_refreshFooter endRefreshing];
        [_refreshheader endRefreshing];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourse_A.count;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 58;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VIPHostCardsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VIPHostCardsCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"VIPHostCardsTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if (self.dataSourse_A.count!=0) {
        NSDictionary *dic = _dataSourse_A[indexPath.row];
        cell.cardContaint.text=@"冰封 X4\n凉皮 X5\n夹馍 X5\n酸梅汤 X1";
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:cell.cardType.text];
        
        [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:31.0] range:NSMakeRange(0, 3)];
        cell.cardType.attributedText=AttributedStr;
        
    }
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
