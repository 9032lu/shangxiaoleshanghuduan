//
//  AddCouponHomeVC.m
//  BletcShop
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "ChooseGivenCouponsVC.h"
#import "ADDCoupomSSVC.h"
#import "ShaperView.h"
#import "CouponCell.h"
#import "UIImageView+WebCache.h"
#import "AddCouponDetailsVC.h"
#import "SendCouponCompleteVC.h"
@interface ChooseGivenCouponsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSMutableArray *_dataArray;
    UIImageView *imageView;
    UILabel *noticeLabel;
    CGFloat heights;
    MBProgressHUD *shophud;
}
@property(nonatomic, strong) NSMutableArray *deleteArr;//删除数据的数组
@property(nonatomic,strong)LZDButton *leftPopBtn;
@property(nonatomic,strong)LZDButton *leftCancleBtn;
@property(nonatomic,strong)LZDButton *rightBtn;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation ChooseGivenCouponsVC
-(NSDictionary *)delete_dic{
    if (!_delete_dic) {
        _delete_dic = [NSDictionary dictionary];
    }
    return _delete_dic;
}

-(LZDButton *)leftPopBtn{
    if (!_leftPopBtn) {
        
        __weak typeof(self) weakSelf = self;
        
        _leftPopBtn =[LZDButton creatLZDButton];
        _leftPopBtn.frame = CGRectMake(13, 31, 10, 20);
        [_leftPopBtn setImage:[UIImage imageNamed:@"返回（白）"] forState:0];
        _leftPopBtn.block = ^(LZDButton *sender) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _leftPopBtn;
}
-(LZDButton *)leftCancleBtn{
    if (!_leftCancleBtn) {
        __weak typeof(self) weakSelf = self;
        
        _leftCancleBtn = [LZDButton creatLZDButton];
        _leftCancleBtn.frame = CGRectMake(13, 0, 40, 30);
        
        [_leftCancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftCancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftCancleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        
        self.leftCancleBtn.block = ^(LZDButton *btn){
            
            weakSelf.tableView.editing = NO;
            
            weakSelf.rightBtn.selected = NO;
            
            [weakSelf.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
            weakSelf.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:weakSelf.leftPopBtn];
        };
        
    }
    
    return _leftCancleBtn;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self postGetCouponRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    heights=0;
    self.deleteArr = [NSMutableArray array];
    
    self.view.backgroundColor=RGB(238, 238, 238);
    self.navigationItem.title=@"优惠券";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftPopBtn];
    
    
    
//    LZDButton *rightBtn = [LZDButton creatLZDButton];
//    rightBtn.frame = CGRectMake(kWeChatScreenWidth-50, 0, 40, 30);
//    
//    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    
//    self.rightBtn = rightBtn;
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    
//    
//    
//    
//    rightBtn.block = ^(LZDButton *btn){
//        __weak typeof(self) weakSelf = self;
//        
//        
//        if (btn.selected) {
//            
//            weakSelf.tableView.editing = NO;
//            btn.selected = NO;
//            
//            [btn setTitle:@"编辑" forState:UIControlStateNormal];
//            
//            [weakSelf showHint:[NSString stringWithFormat:@"删除选中的-%lu-项",(unsigned long)weakSelf.deleteArr.count]];
//            weakSelf.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:weakSelf.leftPopBtn];
//            
//            [weakSelf.deleteArr removeAllObjects];
//            
//        }else{
//            
//            
//            
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"编辑" preferredStyle:UIAlertControllerStyleActionSheet];
//            
//            NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"编辑"];
//            [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, [[hogan string] length])];
//            //            [hogan addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [[hogan string] length])];
//            [alertController setValue:hogan forKey:@"attributedMessage"];
//            
//            UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                ADDCoupomSSVC *couponVC=[[ADDCoupomSSVC alloc]init];
//                [weakSelf.navigationController pushViewController:couponVC animated:YES];
//                
//            }];
//            
//            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                
//                [btn setTitle:@"删除" forState:UIControlStateNormal];
//                
//                btn.selected = YES;
//                
//                weakSelf.tableView.editing = YES;
//                
//                
//                
//                weakSelf.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:weakSelf.leftCancleBtn];
//                
//                
//                
//            }];
//            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                
//                
//                
//                
//            }];
//            
//            [alertController addAction:addAction];
//            [alertController addAction:deleteAction];
//            [alertController addAction:cancleAction];
//            
//            [weakSelf presentViewController:alertController animated:YES completion:^{
//                
//            }];
//            
//            
//        }
//        
//        
//    };
    
    UIButton *NewAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    NewAdd.frame = CGRectMake(/*SCREENWIDTH-40, 20+(topView.height-20-25)/2,*/0,0, 20, 20);
    //    [NewAdd setTitle:@"新增产品" forState:UIControlStateNormal];
    [NewAdd setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateNormal];
    [NewAdd setImage:[UIImage imageNamed:@"add_yellow"] forState:UIControlStateHighlighted];
    
    //    NewAdd.backgroundColor = [UIColor redColor];
    //    NewAdd.layer.cornerRadius = 10;
    [NewAdd addTarget:self action:@selector(addProAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [topView addSubview:NewAdd];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:NewAdd];
    
    _dataArray=[[NSMutableArray alloc]initWithCapacity:0];//@[dic1,dic2,dic3];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-82) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.editing = NO;
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-64-82, SCREENWIDTH, 82)];
    bottomView.backgroundColor=RGB(240, 240, 240);
    [self.view addSubview:bottomView];
    
    UILabel *noticeLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 33)];
    noticeLable.backgroundColor=RGB(229,229,229);
    noticeLable.text=@"    选择推送并短信通知对方";
    noticeLable.font=[UIFont systemFontOfSize:12];
    [bottomView addSubview:noticeLable];
    
    UIImageView *chooseImg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-15-13, 9, 15, 15)];
    chooseImg.image=[UIImage imageNamed:@"选择ssss"];
    [bottomView addSubview:chooseImg];
    
    UIButton *goVC=[UIButton buttonWithType:UIButtonTypeCustom];
    goVC.frame=CGRectMake(0, noticeLable.bottom, SCREENWIDTH, 49);
    goVC.backgroundColor=RGB(9,192,132);
    [goVC setTitle:@"确认推送" forState:UIControlStateNormal];
    [goVC setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    goVC.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [bottomView addSubview:goVC];
    [goVC addTarget:self action:@selector(goVCBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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
        cell.couponMoney.text=[NSString stringWithFormat:@"%@元",_dataArray[indexPath.row][@"sum"]];
        cell.couponMoney.font=[UIFont systemFontOfSize:22];
        cell.deadTime.text=[NSString stringWithFormat:@"有效期为:%@～%@",_dataArray[indexPath.row][@"date_start"],_dataArray[indexPath.row][@"date_end"]];
        cell.limitLab.text=_dataArray[indexPath.row][@"content"];
        
        cell.youjian.hidden=YES;
        cell.chooseCircle.hidden=NO;
        if ([_dataArray[indexPath.row][@"chooseState"] isEqualToString:@"none"]) {
            cell.chooseCircle.image=[UIImage imageNamed:@"选择nnnn"];
            cell.coverView.hidden=NO;
        }else{
            cell.chooseCircle.image=[UIImage imageNamed:@"选择ssss"];
            cell.coverView.hidden=YES;
        }
        
        if ([_dataArray[indexPath.row][@"validate"] isEqualToString:@"true"]) {
            cell.showImg.hidden = YES ;
        }else{
            cell.showImg.hidden = NO ;
            
        }
        
        if ([_dataArray[indexPath.row][@"coupon_type"] isEqualToString:@"ONLINE"]||[_dataArray[indexPath.row][@"coupon_type"] isEqualToString:@"null"]) {
            cell.onlineState.image=[UIImage imageNamed:@"线上shop"];
            cell.detail.text=[NSString stringWithFormat:@"办卡使用，满%@元可用",_dataArray[indexPath.row][@"pri_condition"]];
        }else{
            cell.onlineState.image=[UIImage imageNamed:@"线下shop"];
             cell.detail.text=[NSString stringWithFormat:@"进店使用，满%@元可用",_dataArray[indexPath.row][@"pri_condition"]];
        }
        cell.lookMore.hidden=NO;
        [cell.lookMore addTarget:self action:@selector(lookMoreBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
        cell.lookMore.tag=indexPath.row;
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
//    if (tableView.editing) {
//        [self.deleteArr addObject:[_dataArray objectAtIndex:indexPath.row]];
//        
//    }else{
//        AddCouponDetailsVC *vc=[[AddCouponDetailsVC alloc]init];
//        vc.statess=1;
//        vc.infoDic=_dataArray[indexPath.row];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        
//        
//    }
    
    NSMutableDictionary *dic=_dataArray[indexPath.row];
    if ([dic[@"chooseState"] isEqualToString:@"none"]) {
        [dic setObject:@"yes" forKey:@"chooseState"];
    }else{
        [dic setObject:@"none" forKey:@"chooseState"];
    }
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:dic];
    [_tableView reloadData];
}

//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (tableView.editing) {
        [self.deleteArr removeObject:[_dataArray objectAtIndex:indexPath.row]];
        
    }
}

-(void)postGetCouponRequest{
    
    if (imageView) {
        [imageView removeFromSuperview];
    }
    if (noticeLabel) {
        [noticeLabel removeFromSuperview];
    }
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/member/getCoupon",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    NSLog(@"------%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"%@",result);
        if (_dataArray.count>0) {
            [_dataArray removeAllObjects];
        }
        if ([result count]>0) {
            for (int i=0; i<[result count]; i++) {
                NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:result[i]];
                [dic setObject:@"none" forKey:@"chooseState"];
                [_dataArray addObject:dic];
            }
            
        }else{
            
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
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/member/delCoupon",BASEURL];
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
//推送
-(void)goVCBtnClick{
    
    //
    NSMutableArray *couponids=[[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i<_dataArray.count; i++) {
        NSMutableDictionary *dic=_dataArray[i];
        if (![dic[@"chooseState"] isEqualToString:@"none"]) {
            [couponids addObject:dic[@"coupon_id"]];
        }
    }
    NSString *jsonString_couponids=[NSString arrayToJSONString:couponids];
    //
    NSMutableArray *uuids=[[NSMutableArray alloc]initWithCapacity:0];
    for (int j=0; j<self.vips.count; j++) {
        [uuids addObject:self.vips[j][@"uuid"]];
    }
     NSString *jsonString_uuids=[NSString arrayToJSONString:uuids];
    
    if (couponids.count>0) {
        [self postSendCounponsToVips:jsonString_couponids uuids:jsonString_uuids];
    }else{
        //提示，请选优惠券
         [self tishiSting:@"请选择优惠券!"];
    }
   
    
    
}

-(void)postSendCounponsToVips:(NSString *)coupon_ids uuids:(NSString *)uuidss{
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/member/propCoupon",BASEURL];
    //  http://101.201.100.191/cnconsum/App/MerchantType/member/propCoupon
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:appdelegate.shopInfoDic[@"muid"] forKey:@"muid"];
    [params setObject:uuidss forKey:@"uuids"];
    [params setObject:coupon_ids forKey:@"coupon_ids"];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    shophud =[MBProgressHUD showHUDAddedTo:window animated:YES];
    shophud.label.text = @"正在推送...";
    NSLog(@"------%@",params);
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        NSLog(@"result===%@",result);
        
       
        
        if ([result[@"result_code"] intValue]==1)
            
        {
            shophud.label.text = @"推送成功！";
            [self performSelector:@selector(goNext) withObject:nil afterDelay:0.3];
           
            
        }else if([result[@"result_code"] intValue]==1062)
        {
             shophud.label.text = @"推送重复！";
           
        }else{
             shophud.label.text = @"推送失败！";
            
        }
         //[shophud hideAnimated:YES];
        [shophud hideAnimated:YES afterDelay:0.3];
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         shophud.label.text = @"接口出错404！";
         [shophud hideAnimated:YES afterDelay:0.3];
        //[shophud hideAnimated:YES];
        NSLog(@"%@", error);
        
    }];
}
-(void)goNext{
    PUSH(SendCouponCompleteVC);
}
-(void)lookMoreBtnClick:(UIButton *)sender{
    AddCouponDetailsVC *vc=[[AddCouponDetailsVC alloc]init];
    vc.statess=1;
    vc.infoDic=_dataArray[sender.tag];
    [self.navigationController pushViewController:vc animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(void)addProAction:(UIButton *)sender{
    ADDCoupomSSVC *couponVC=[[ADDCoupomSSVC alloc]init];
    [self.navigationController pushViewController:couponVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

