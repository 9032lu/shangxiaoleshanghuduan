//
//  MyFunsVC.m
//  BletcShop
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "MyFunsVC.h"
#import "FunsTableViewCell.h"
#import "BuyMessagesVC.h"
#import "ChooseGivenCouponsVC.h"
#import "UIImageView+WebCache.h"
#import "SendMessageToAllVC.h"
@interface MyFunsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *bottom;
    UIImageView *tipImage;
    UILabel *selectWord;
    NSArray *typeArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UIView *coverView;
@property(nonatomic,strong)NSMutableArray *listData;
@property(nonatomic,strong)NSMutableArray *selectedListData;
@end

@implementation MyFunsVC
-(UIView *)coverView{
    if (_coverView==nil) {
        _coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
        _coverView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _coverView.layer.cornerRadius=8;
        _coverView.clipsToBounds=YES;
        
        UIView *tipView=[[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH-101-15, 0, 101, 101)];
        tipView.backgroundColor=[UIColor blackColor];
        tipView.layer.cornerRadius=8;
        tipView.clipsToBounds=YES;
        [_coverView addSubview:tipView];
        
        UIButton *msgSendButton=[UIButton buttonWithType:UIButtonTypeCustom];
        msgSendButton.frame=CGRectMake(0, 0, tipView.width, 50);
        [msgSendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [msgSendButton setTitle:@"群发消息" forState:UIControlStateNormal];
        msgSendButton.titleLabel.font=[UIFont systemFontOfSize:16.0f];
        [tipView addSubview:msgSendButton];
        [msgSendButton addTarget:self action:@selector(showChooseState) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, msgSendButton.bottom, tipView.width, 1)];
        line.backgroundColor=[UIColor whiteColor];
        [tipView addSubview:line];
        
        UIButton *msgBuyButton=[UIButton buttonWithType:UIButtonTypeCustom];
        msgBuyButton.frame=CGRectMake(0, line.bottom, tipView.width, 50);
        [msgBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [msgBuyButton setTitle:@"购买群发" forState:UIControlStateNormal];
        msgBuyButton.titleLabel.font=[UIFont systemFontOfSize:16.0f];
        [tipView addSubview:msgBuyButton];
        [msgBuyButton addTarget:self action:@selector(msgBuyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_coverView addGestureRecognizer:tap];
    
    return _coverView;
}
-(void)tapClick:(UITapGestureRecognizer *)tap{
    [tap.view removeFromSuperview];
    _coverView=nil;
}
//消息群发
-(void)showChooseState{
    [_coverView removeFromSuperview];
    _coverView=nil;
    CGRect frame=bottom.frame;
    frame.origin.y=frame.origin.y-49;
    bottom.frame=frame;
    self.tableView.editing=YES;
}
//购买群发
-(void)msgBuyButtonClick{
    [_coverView removeFromSuperview];
    _coverView=nil;
    PUSH(BuyMessagesVC)
}
//顶部搜索四个按钮的点击事件
- (IBAction)btnClick:(UIButton *)sender {
    for (UIView *view in sender.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button=(UIButton *)view;
            if (button.tag==sender.tag) {
                [button setTitleColor:RGB(241,122,18) forState:UIControlStateNormal];
            }else{
                [button setTitleColor:RGB(119,119,119) forState:UIControlStateNormal];
            }
        }
    }
    self.tableView.editing=NO;
    CGRect frame=bottom.frame;
    frame.origin.y=SCREENHEIGHT-64;
    bottom.frame=frame;
    
    [self postRequestGetFunsWithType:sender.tag];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    LEFTBACK
    self.navigationItem.title=@"我的粉丝";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"群发消息" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
    typeArray=@[@"",@"collect",@"scan",@"coupon"];
    
    self.listData=[[NSMutableArray alloc]initWithCapacity:0];
    
    self.selectedListData=[[NSMutableArray alloc]initWithCapacity:0];
    
    
    bottom=[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-64, SCREENWIDTH, 49)];
    bottom.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottom];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
    line.backgroundColor=RGB(125, 125, 125);
    [bottom addSubview:line];
    
    tipImage=[[UIImageView alloc]initWithFrame:CGRectMake(30, 15, 20, 20)];
    tipImage.image=[UIImage imageNamed:@"选择nnnn"];
    [bottom addSubview:tipImage];
    
    selectWord=[[UILabel alloc]initWithFrame:CGRectMake(tipImage.right+10, 1, 40, 48)];
    selectWord.text=@"全选";
    selectWord.font=[UIFont systemFontOfSize:16];
    selectWord.textColor=RGB(51, 51, 51);
    [bottom addSubview:selectWord];
    
    UIButton *selectAllButton=[UIButton buttonWithType:UIButtonTypeCustom];
    selectAllButton.frame=CGRectMake(0, 0, 130, 49);
    [bottom addSubview:selectAllButton];
    
    [selectAllButton addTarget:self action:@selector(selectAllButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    float remainWidth=SCREENWIDTH-100-31;
    
    UIButton *couponSendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    couponSendBtn.frame=CGRectMake(selectWord.right+30, 1, remainWidth/2.0, 48);
    couponSendBtn.backgroundColor=RGB(9,192,132);
    [couponSendBtn setTitle:@"发送优惠券" forState:UIControlStateNormal];
    [couponSendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    couponSendBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [bottom addSubview:couponSendBtn];
    
    [couponSendBtn addTarget:self action:@selector(couponSendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *msgSendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    msgSendBtn.frame=CGRectMake(couponSendBtn.right+1, 1, remainWidth/2.0, 48);
    msgSendBtn.backgroundColor=RGB(9,192,132);
    [msgSendBtn setTitle:@"发送活动信息" forState:UIControlStateNormal];
    [msgSendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    msgSendBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [bottom addSubview:msgSendBtn];
    
    [msgSendBtn addTarget:self action:@selector(msgSendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self postRequestGetFunsWithType:0];
    
}
//全选或取消全选
-(void)selectAllButtonClick{
    if ([selectWord.text isEqualToString:@"全选"]) {
        [self.listData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
        }];
        tipImage.image=[UIImage imageNamed:@"选择ssss"];
        selectWord.text=@"取消";
    }else{
        [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView deselectRowAtIndexPath:obj animated:NO];
        }];
        tipImage.image=[UIImage imageNamed:@"选择nnnn"];
        selectWord.text=@"全选";
    }

}
//发送优惠券
-(void)couponSendBtnClick{
    [self.selectedListData removeAllObjects];
//    NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
    [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [insets addIndex:obj.row];
        [self.selectedListData addObject:self.listData[idx]];
    }];
    if (self.selectedListData.count>0) {
        PUSH(ChooseGivenCouponsVC)
        vc.vips=self.selectedListData;
    }
    
}
//发送优惠信息
-(void)msgSendBtnClick{
    [self.selectedListData removeAllObjects];
    //    NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
    [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        [insets addIndex:obj.row];
        [self.selectedListData addObject:self.listData[idx]];
    }];
    if (self.selectedListData.count>0) {
        PUSH(SendMessageToAllVC)
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:0];
        for (int i = 0; i<self.selectedListData.count; i++) {
            NSMutableDictionary *addDic=[NSMutableDictionary dictionaryWithDictionary:self.selectedListData[i]];
            [addDic setObject:addDic[@"nickname"] forKey:@"user"];
            [dic setObject:addDic forKey:[NSString stringWithFormat:@"%d",i]];
            
        }
        vc.dic=dic;
    }
    
    
}
//rightItemClick
-(void)rightItemClick{
    
    CGRect frame=bottom.frame;
    frame.origin.y=SCREENHEIGHT-64;
    bottom.frame=frame;
    
    self.tableView.editing=NO;
    
    [_coverView removeFromSuperview];
    _coverView=nil;
    [self.view addSubview:self.coverView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FunsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FunsCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FunsTableViewCell" owner:self options:nil] firstObject];
    
    }
    NSString *nick = [NSString getTheNoNullStr:self.listData[indexPath.row][@"nickname"] andRepalceStr:@""];
    cell.nickName.text=[NSString stringWithFormat:@"名称：%@",nick];
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HEADIMAGE,self.listData[indexPath.row][@"headimage"]]] placeholderImage:[UIImage imageNamed:@"userHeader"]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelect+++%ld",indexPath.row);
    [self.selectedListData removeAllObjects];
    [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        [insets addIndex:obj.row];
        [self.selectedListData addObject:self.listData[idx]];
    }];
    if (self.selectedListData.count==self.listData.count) {
        tipImage.image=[UIImage imageNamed:@"选择ssss"];
        selectWord.text=@"取消";
    }else{
        tipImage.image=[UIImage imageNamed:@"选择nnnn"];
        selectWord.text=@"全选";
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didDeselect---%ld",indexPath.row);
    [self.selectedListData removeAllObjects];
    [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        [insets addIndex:obj.row];
        [self.selectedListData addObject:self.listData[idx]];
    }];
    if (self.selectedListData.count==self.listData.count) {
        tipImage.image=[UIImage imageNamed:@"选择ssss"];
        selectWord.text=@"取消";
    }else{
        tipImage.image=[UIImage imageNamed:@"选择nnnn"];
        selectWord.text=@"全选";
    }
}
//获取粉丝接口
-(void)postRequestGetFunsWithType:(NSInteger) index{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Fans/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    if (index!=0) {
        [params setObject:typeArray[index] forKey:@"type"];
    }
    NSLog(@"------%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
        
        if (self.listData.count>0) {
            [self.listData removeAllObjects];
        }
        if ([result count]>0) {
            for (int i=0; i<[result count]; i++) {
                [self.listData addObject:result[i]];
            }
            
        }else{
            
        }
        [_tableView reloadData];
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
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
