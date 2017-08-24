//
//  AddCouponHomeVC.m
//  BletcShop
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "AddCouponHomeVC.h"
#import "AddCouponVC.h"
#import "ShaperView.h"
#import "CouponCell.h"
#import "UIImageView+WebCache.h"
#import "AddCouponDetailsVC.h"
@interface AddCouponHomeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataArray;
    UIImageView *imageView;
    UILabel *noticeLabel;
     CGFloat heights;
}
@end

@implementation AddCouponHomeVC
-(NSDictionary *)delete_dic{
    if (!_delete_dic) {
        _delete_dic = [NSDictionary dictionary];
    }
    return _delete_dic;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self postGetCouponRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     heights=0;
    self.view.backgroundColor=RGB(238, 238, 238);
    self.navigationItem.title=@"优惠券";
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addCoupon)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
    _dataArray=[[NSArray alloc]init];//@[dic1,dic2,dic3];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCell *cell = [CouponCell couponCellWithTableView:tableView];
    
    if (_dataArray.count!=0) {
        NSURL * nurl1=[[NSURL alloc] initWithString:[[SHOPIMAGE_ADDIMAGE stringByAppendingString:[NSString getTheNoNullStr:[_dataArray[indexPath.row]  objectForKey:@"image_url"] andRepalceStr:@""]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [cell.headImg sd_setImageWithURL:nurl1 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
        cell.shopNamelab.text=_dataArray[indexPath.row][@"store"];
        cell.couponMoney.text=_dataArray[indexPath.row][@"sum"];
        cell.deadTime.text=[NSString stringWithFormat:@"有效期为:%@～%@",_dataArray[indexPath.row][@"date_start"],_dataArray[indexPath.row][@"date_end"]];
        cell.limitLab.text=_dataArray[indexPath.row][@"content"];
        
        
        if ([_dataArray[indexPath.row][@"validate"] isEqualToString:@"true"]) {
            cell.showImg.hidden = YES ;
        }else{
            cell.showImg.hidden = NO ;
            
        }
        
        if ([_dataArray[indexPath.row][@"coupon_type"] isEqualToString:@"ONLINE"]||[_dataArray[indexPath.row][@"coupon_type"] isEqualToString:@"null"]) {
            cell.onlineState.image=[UIImage imageNamed:@"线上shop"];
            
            }else{
            cell.onlineState.image=[UIImage imageNamed:@"线下shop"];
            
        }

    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 126;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddCouponDetailsVC *vc=[[AddCouponDetailsVC alloc]init];
    vc.infoDic=_dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)postGetCouponRequest{
    /*
     muid=>商户ID
     sum => 优惠券金额
     condition => 优惠条件
     remain => 发布数量
     date_start => 开始日期
     date_end => 结束日期
     content => 优惠券内容
     */
    if (imageView) {
        [imageView removeFromSuperview];
    }
    if (noticeLabel) {
        [noticeLabel removeFromSuperview];
    }
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/coupon/merchantGet",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    NSLog(@"------%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
        if ([result count]>0) {
            _dataArray=result;
        }else{
            _dataArray=@[];
            [self initNoneActiveView];

        }
         [_tableView reloadData];
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
}
-(void)initNoneActiveView{
    self.view.backgroundColor=RGB(240, 240, 240);
    
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-92, 63, 184, 117)];
    imageView.image=[UIImage imageNamed:@"CC588055F2B4764AA006CD2B6ACDD25C.jpg"];
    [self.view addSubview:imageView];
    
    noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+46, SCREENWIDTH, 30)];
    noticeLabel.font=[UIFont systemFontOfSize:15.0f];
    noticeLabel.textColor=RGB(153, 153, 153);
    noticeLabel.textAlignment=NSTextAlignmentCenter;
    noticeLabel.text=@"您还没有添加代金券哦！";
    [self.view addSubview:noticeLabel];
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    _delete_dic=_dataArray[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"删除优惠券？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.delegate=self;
        [alertView show];
    
    }];
    return @[deleteAction];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        [self postRequestDeleteAdmin];
    }
}
-(void)postRequestDeleteAdmin{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/coupon/del",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:_delete_dic[@"coupon_id"] forKey:@"coupon_id"];
    
    NSLog(@"------%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result===%@",result);
        
        if ([result[@"result_code"] intValue]==1)
            
        {
            [self tishiSting:@"删除成功!"];
            [self postGetCouponRequest];
            
        }else if([result[@"result_code"] intValue]==1062)
        {
            [self tishiSting:@"删除重复!"];
            
            
        }else{
            [self tishiSting:@"删除失败!"];
            
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    

}
-(void)tishiSting:(NSString*)tishi{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = NSLocalizedString(tishi, @"HUD message title");
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.frame = CGRectMake(25, SCREENHEIGHT/2, SCREENWIDTH-50, 100);
    [hud hideAnimated:YES afterDelay:4.f];
    
}

-(void)addCoupon{
    AddCouponVC *couponVC=[[AddCouponVC alloc]init];
    [self.navigationController pushViewController:couponVC animated:YES];
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
