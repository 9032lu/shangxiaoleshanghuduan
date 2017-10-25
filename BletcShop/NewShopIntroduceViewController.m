//
//  NewShopIntroduceViewController.m
//  BletcShop
//
//  Created by apple on 16/12/13.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import "NewShopIntroduceViewController.h"
#import "PictureDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "PictureAndVeidoDetailVC.h"
#import "PickReasonView.h"
#import "PickDateTimeView.h"
@interface NewShopIntroduceViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,strong)NSArray *imageArray;
@end

@implementation NewShopIntroduceViewController
{
    __block UIScrollView *bgScrollView;
    __block UITextView *intrTextView;
    __block UITextField *timeTF;
    __block UITextView *serviceText;
    __block UITextView *noticeTextView;
//    __block UITextView *wnoticeTextView;
    
    UIView *textDetailView;
    UIView *noticeView;
    
    UITextView *mytextView;
    CGFloat oldoffset;
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self postRequestGetImageInfo];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDismiss:) name:UIKeyboardWillHideNotification object:nil];

}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    
}
-(void)keyboardShow:(NSNotification*)notification{
    
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGFloat offset = mytextView.superview.top+ mytextView.bottom+10 - (SCREENHEIGHT -64- keyboardRect.size.height);
    NSLog(@"==%lf===%lf=====%lf",offset,mytextView.bottom,(SCREENHEIGHT - keyboardRect.size.height));
    
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (offset>0) {
        
       [UIView animateWithDuration:duration animations:^{
          
            oldoffset = bgScrollView.contentOffset.y;
           
         
           bgScrollView.contentOffset = CGPointMake(0, offset);
           
       }];
    }
    
}

-(void)keyboardDismiss:(NSNotification*)notification{
    
    
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
        [UIView animateWithDuration:duration animations:^{
            
            bgScrollView.contentOffset = CGPointMake(0, oldoffset);
            
        }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"商家介绍";
    
  

    
    LEFTBACK
    oldoffset = 0.0f;
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    self.navigationItem.rightBarButtonItem=item;
    
    self.view.backgroundColor=RGB(240, 240, 240);
    
    bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    bgScrollView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    bgScrollView.contentSize=CGSizeMake(SCREENWIDTH, 690);
    bgScrollView.backgroundColor=RGB(240, 240, 240);
    [self.view addSubview:bgScrollView];
    //1.
    UIView *shopIntroduceView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90)];
    shopIntroduceView.backgroundColor=[UIColor whiteColor];
    [bgScrollView addSubview:shopIntroduceView];
    
    UILabel *intrName=[[UILabel alloc]initWithFrame:CGRectMake(19, 16, 100, 16)];
    intrName.text=@"商家简介：";
    intrName.font=[UIFont systemFontOfSize:16.0f];
    [shopIntroduceView addSubview:intrName];
    //------
    intrTextView=[[UITextView alloc]initWithFrame:CGRectMake(11, 35, SCREENWIDTH-22, 45)];
    intrTextView.backgroundColor=RGB(240, 240, 240);
    intrTextView.font=[UIFont systemFontOfSize:15.0f];
    [shopIntroduceView addSubview:intrTextView];
    //2.
    UIView *businessTimeAndServiceView=[[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 170)];
    businessTimeAndServiceView.backgroundColor=[UIColor whiteColor];
    [bgScrollView addSubview:businessTimeAndServiceView];
    //timelabel
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(19, 10, 100, 16)];
    timeLabel.text=@"营业时间：";
    timeLabel.font=[UIFont systemFontOfSize:16.0f];
    [businessTimeAndServiceView addSubview:timeLabel];
    //-------
    timeTF=[[UITextField alloc]initWithFrame:CGRectMake(11, 30, SCREENWIDTH-22, 45)];
    timeTF.placeholder=@"  09:00-22:00(周末法定节假日通用)";
    timeTF.font=[UIFont systemFontOfSize:15.0f];
    timeTF.delegate = self;
    timeTF.backgroundColor=RGB(240, 240, 240);
    [businessTimeAndServiceView addSubview:timeTF];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, 84, SCREENWIDTH, 1)];
    lineView1.backgroundColor=RGB(240, 240, 240);
    [businessTimeAndServiceView addSubview:lineView1];
    //servicelabel
    UILabel *serviceLabel=[[UILabel alloc]initWithFrame:CGRectMake(19, 95, 100, 16)];
    serviceLabel.text=@"门店服务：";
    serviceLabel.font=[UIFont systemFontOfSize:16.0f];
    [businessTimeAndServiceView addSubview:serviceLabel];
    //------
    serviceText=[[UITextView alloc]initWithFrame:CGRectMake(11, 95+16+3, SCREENWIDTH-22, 45)];
    serviceText.backgroundColor=RGB(240, 240, 240);
    serviceText.font=[UIFont systemFontOfSize:15.0f];
    serviceText.delegate =self;
    [businessTimeAndServiceView addSubview:serviceText];

    
    
    textDetailView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(businessTimeAndServiceView.frame)+10, SCREENWIDTH, 136)];
    textDetailView.backgroundColor=[UIColor whiteColor];
    [bgScrollView addSubview:textDetailView];
    
    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(19, 10, 100, 16)];
    detailLabel.text=@"图文详情：";
    [textDetailView addSubview:detailLabel];
    
    UILabel *lookLable=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, 10, 100, 16)];
    lookLable.text=@"点击查看 >";
    lookLable.font=[UIFont systemFontOfSize:13.0f];
    lookLable.textColor=[UIColor grayColor];
    [textDetailView addSubview:lookLable];
    
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setClick)];
    [textDetailView addGestureRecognizer:tapRecognizer];
    

    
    
    //noticeView
    noticeView=[[UIView alloc]initWithFrame:CGRectMake(0, textDetailView.bottom+10, SCREENWIDTH, 230)];
    noticeView.backgroundColor=[UIColor whiteColor];
    [bgScrollView addSubview:noticeView];
    //notice
    UILabel *noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(19, 10, 100, 16)];
    noticeLabel.text=@"购买须知：";
    [noticeView addSubview:noticeLabel];
    
    noticeTextView=[[UITextView alloc]initWithFrame:CGRectMake(11, 30, SCREENWIDTH-22, 106+75+8)];
    noticeTextView.backgroundColor=RGB(240, 240, 240);
    noticeTextView.font=[UIFont systemFontOfSize:15.0f];
    noticeTextView.delegate = self;
    [noticeView addSubview:noticeTextView];
    
//    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0, 144, SCREENWIDTH, 1)];
//    lineView2.backgroundColor=RGB(240, 240, 240);
//    [noticeTextView addSubview:lineView2];
//    //温馨提示
//    UILabel *buyNote=[[UILabel alloc]initWithFrame:CGRectMake(19, 155, 100, 16)];
//    buyNote.text=@"温馨提示：";
//    [noticeView addSubview:buyNote];
//
//    wnoticeTextView=[[UITextView alloc]initWithFrame:CGRectMake(11, 175, SCREENWIDTH-22, 45)];
//    wnoticeTextView.backgroundColor=RGB(240, 240, 240);
//    wnoticeTextView.font=[UIFont systemFontOfSize:15.0f];
//    [noticeView addSubview:wnoticeTextView];
//    wnoticeTextView.delegate = self;

    //imageAndText
       [self postRequestGetInfo];


}
-(void)btnClick{
    
    [intrTextView resignFirstResponder];
    [timeTF resignFirstResponder];
    [serviceText resignFirstResponder];
    [noticeTextView resignFirstResponder];
    //[wnoticeTextView resignFirstResponder];
    
    [self postRequestSetInfo];
    
}
-(void)setClick{
    PictureAndVeidoDetailVC *picVC = [[PictureAndVeidoDetailVC alloc]init];
    
//    PictureDetailViewController *picVC = [[PictureDetailViewController alloc]init];
    [self.navigationController pushViewController:picVC animated:YES ];
}
//get
-(void)postRequestGetInfo
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Info/get",BASEURL ];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    __block NewShopIntroduceViewController *tempSelf=self;
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"postRequestGetInfo%@", result);
        tempSelf.data = result;
        if (tempSelf.data.count>0) {
            intrTextView.text=tempSelf.data[0][@"intro"];
            serviceText.text=tempSelf.data[0][@"service"];
            noticeTextView.text=tempSelf.data[0][@"notice"];
            //wnoticeTextView.text=tempSelf.data[0][@"tip"];
            timeTF.text=tempSelf.data[0][@"time"];
        }
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

//set
-(void)postRequestSetInfo{
    NSString *urlStr=[[NSString alloc]initWithFormat:@"%@MerchantType/Info/mod",BASEURL];
    NSMutableDictionary *userInfos=[NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    [userInfos setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    [userInfos setObject:intrTextView.text forKey:@"intro"];
    [userInfos setObject:timeTF.text forKey:@"time"];
    [userInfos setObject:serviceText.text forKey:@"service"];
    [userInfos setObject:noticeTextView.text forKey:@"notice"];
    [userInfos setObject:@"" forKey:@"tip"];
    
    [KKRequestDataService requestWithURL:urlStr params:userInfos httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, id result) {
        
        NSLog(@"postRequestGetInfo%@", result);
        NSString *title, *act_title;
        
        
        
        if ([result[@"result_code"] intValue]==1) {

            title = @"恭喜你!";
            act_title = @"提交成功";
        }else{

            title = @"您并未进行任何修改";
            act_title = @"提交失败";

        }
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:title];
        [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, title.length)];

        [alertControl setValue:titleAtt forKey:@"attributedTitle"];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:act_title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            

        }];
        
        
        //修改按钮
            [action setValue:[UIColor blackColor] forKey:@"titleTextColor"];
        
               [alertControl addAction:action];
        
        [self presentViewController:alertControl animated:YES completion:nil];

        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}
//获取商家图文详情的方法
-(void)postRequestGetImageInfo
{
    
    NSString *url =[[NSString alloc]initWithFormat:@"%@MerchantType/Imgtxt/get",BASEURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [params setObject:[appdelegate.shopInfoDic objectForKey:@"muid"] forKey:@"muid"];
    NewShopIntroduceViewController *tempSelf=self;
    
    [KKRequestDataService requestWithURL:url params:params httpMethod:@"POST" finishDidBlock:^(AFHTTPRequestOperation *operation, NSArray * result) {
        
        NSLog(@"postRequestGetImageInfo=%@", result);
        tempSelf.imageArray = result;

        if (tempSelf.imageArray.count>0) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                CGRect frame = textDetailView.frame ;
                frame.size.height = 136;
                textDetailView.frame = frame;
                
                CGRect notFrame = noticeView.frame;
                notFrame.origin.y = textDetailView.bottom +10;
                
                noticeView.frame = notFrame;
                
            }];

            for (UIView  *view in textDetailView.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    [view removeFromSuperview];
                    
                }
            }
            
            for (int i = 0; i < MIN(tempSelf.imageArray.count, 3); i ++) {
                
              
                UIImageView *imageView3=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-270)/4+i%3*120, 36, 90, 90)];
                imageView3.contentMode = UIViewContentModeScaleAspectFit;

                [textDetailView addSubview:imageView3];
                NSURL * nurl2=[[NSURL alloc] initWithString:[[SHOPIMAGE_New stringByAppendingString:[result[i]  objectForKey:@"image_url"]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [imageView3 sd_setImageWithURL:nurl2 placeholderImage:[UIImage imageNamed:@"icon3.png"] options:SDWebImageRetryFailed];
                
            }
            

        }else{
            [UIView animateWithDuration:0.5 animations:^{
                
                for (UIView  *view in textDetailView.subviews) {
                    if ([view isKindOfClass:[UIImageView class]]) {
                        [view removeFromSuperview];
                        
                    }
                }
                CGRect frame = textDetailView.frame ;
                frame.size.height = 36;
                textDetailView.frame = frame;
                
                CGRect notFrame = noticeView.frame;
                notFrame.origin.y = textDetailView.bottom +10;
                
                noticeView.frame = notFrame;

            }];
           
        }
        
    } failuerDidBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField ==timeTF) {
        
        PickDateTimeView *pickTimeView = [[PickDateTimeView alloc]init];
        pickTimeView.dataSource = @[@[@"00:00",@"1:00",@"2:00",@"3:00",@"4:00",@"5:00",@"6:00",@"7:00",@"8:00",@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",],@[@"00:00",@"1:00",@"2:00",@"3:00",@"4:00",@"5:00",@"6:00",@"7:00",@"8:00",@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",]];

        [self.view addSubview:pickTimeView];
        
        [pickTimeView show];
        
        pickTimeView.sureBtnClick = ^(NSString *value) {
            
            
            timeTF.text = value;
            NSLog(@"0-----0=%@",value);
        };

        
        return NO;
    }else
        return YES;
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if (textView ==serviceText) {
    
        [self.view endEditing:YES];

        PickReasonView *pickReasonView = [[PickReasonView alloc]init];
        pickReasonView.title = @"请选择门店服务";
        pickReasonView.dataSource = @[@"支持WIFI",@"提供车位",@"提供包间",@"提供纸巾",@"提供打包服务",@"其它(详情请咨询商家)"];
        pickReasonView.mutab_select = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:pickReasonView];
        
        [pickReasonView show];
        
        pickReasonView.sureBtnClick = ^(NSArray *value) {
            
            for (NSInteger i = 0; i <value.count; i ++) {
                
                if (i==0) {
                    serviceText.text =value[0];
                }else{
                    serviceText.text = [NSString stringWithFormat:@"%@,%@",serviceText.text,value[i]];
                }
            }
            
            
            NSLog(@"0-----0=%@",value);
        };

        
        
        return NO;
    }else if (textView == noticeTextView)
    {
        [self.view endEditing:YES];

        PickReasonView *pickReasonView = [[PickReasonView alloc]init];
        pickReasonView.title = @"请选择购买须知";
        pickReasonView.dataSource = @[@"需要至少提前两小时预约",@"需要提前一天预约",@"无需预约",@"不在与其他优惠同享",@"本店每张会员卡仅限一人使用",@"消费时需出示本人证件",@"会员可使用/体验店内所有产品",@"其它(详情请咨询商家)"];
        pickReasonView.mutab_select = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:pickReasonView];
        
        [pickReasonView show];
        
        pickReasonView.sureBtnClick = ^(NSArray *value) {

            
            for (NSInteger i = 0; i <value.count; i ++) {
                
                if (i==0) {
                    noticeTextView.text =value[0];
                }else{
                    noticeTextView.text = [NSString stringWithFormat:@"%@\r%@",noticeTextView.text,value[i]];
                }
            }
            NSLog(@"0-----0=%@",value);
        };
        
        
        
        return NO;

    }else
    {
        mytextView = textView;
        return YES;

    }
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
