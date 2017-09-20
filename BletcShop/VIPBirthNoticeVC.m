//
//  VIPBirthNoticeVC.m
//  BletcShop
//
//  Created by apple on 2017/9/20.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "VIPBirthNoticeVC.h"

@interface VIPBirthNoticeVC ()

@end

@implementation VIPBirthNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(240, 240, 240);
    self.navigationItem.title=@"生日问候";
    LEFTBACK
    UIButton *customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame=CGRectMake(0, 0, 20, 20);
    [customButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(noticeTimeLimit) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:customButton];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(13, 15, SCREENWIDTH-26, SCREENHEIGHT-64-15-77)];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.layer.cornerRadius=12;
    bgView.clipsToBounds=YES;
    [self.view addSubview:bgView];
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.width, 100)];
    headImage.image=[UIImage imageNamed:@""];
    [bgView addSubview:headImage];
    
    NSArray *personArr=@[@{@"image":@"icon3",@"name":@"张大大",@"birth":@"9月26日生日"},@{@"image":@"icon3",@"name":@"张大大",@"birth":@"9月26日生日"},@{@"image":@"icon3",@"name":@"张大大",@"birth":@"9月26日生日"}];
    int state=0;//state 代表有会员还是没会员生日==0没有，1有
    
    
    UIScrollView *src=[[UIScrollView alloc]initWithFrame:CGRectMake(0, (bgView.height-110)/2, bgView.width, 110)];
    src.showsVerticalScrollIndicator=NO;
    src.showsHorizontalScrollIndicator=NO;
    if (personArr.count==1) {
        if (state==0) {
            UIImageView *cryImage=[[UIImageView alloc]initWithFrame:CGRectMake((src.width-54)/2, 0, 54, 54)];
            cryImage.image=[UIImage imageNamed:@""];
            [src addSubview:cryImage];
            
            UILabel *notice=[[UILabel alloc]initWithFrame:CGRectMake(0, cryImage.bottom+10, src.width, 13)];
            notice.textAlignment=NSTextAlignmentCenter;
            notice.text=@"会员生日没到喔";
            notice.font=[UIFont systemFontOfSize:13.0];
            notice.textColor=RGB(153,153,153);
            [src addSubview:notice];
        
            src.contentSize=CGSizeMake(0, 0);
        }else{
            UIImageView *cryImage=[[UIImageView alloc]initWithFrame:CGRectMake((src.width-54)/2, 0, 54, 54)];
            cryImage.image=[UIImage imageNamed:@"icon3"];
            [src addSubview:cryImage];
            
            UILabel *notice=[[UILabel alloc]initWithFrame:CGRectMake(0, cryImage.bottom+10, src.width, 13)];
            notice.textAlignment=NSTextAlignmentCenter;
            notice.text=@"张大大";
            notice.font=[UIFont systemFontOfSize:13.0];
            notice.textColor=RGB(51,51,51);
            [src addSubview:notice];
            
            UILabel *birth=[[UILabel alloc]initWithFrame:CGRectMake(0, notice.bottom+10, src.width, 12)];
            birth.textAlignment=NSTextAlignmentCenter;
            birth.text=@"9月26日生日";
            birth.font=[UIFont systemFontOfSize:13.0];
            birth.textColor=RGB(51,51,51);
            [src addSubview:birth];
            
            src.contentSize=CGSizeMake(0, 0);
        }
    }else if(personArr.count<=3){
        for (int i=0; i<personArr.count; i++) {
            UIImageView *cryImage=[[UIImageView alloc]initWithFrame:CGRectMake((src.width-54*personArr.count)/(personArr.count+1) + i%personArr.count*(54+(src.width-54*personArr.count)/(personArr.count+1)), 0, 54, 54)];
            cryImage.image=[UIImage imageNamed:@"icon3"];
            [src addSubview:cryImage];
            
            UILabel *notice=[[UILabel alloc]initWithFrame:CGRectMake(cryImage.left, cryImage.bottom+10, cryImage.width, 13)];
            notice.textAlignment=NSTextAlignmentCenter;
            notice.text=@"张大大";
            notice.font=[UIFont systemFontOfSize:13.0];
            notice.textColor=RGB(51,51,51);
            [src addSubview:notice];
            
            UILabel *birth=[[UILabel alloc]initWithFrame:CGRectMake(cryImage.left, notice.bottom+10, notice.width, 12)];
            birth.textAlignment=NSTextAlignmentCenter;
            birth.text=@"9月26日生日";
            birth.font=[UIFont systemFontOfSize:13.0];
            birth.textColor=RGB(51,51,51);
            [src addSubview:birth];
            
            src.contentSize=CGSizeMake(0, 0);
        }
    }else{
        for (int i=0; i<personArr.count; i++) {
            UIImageView *cryImage=[[UIImageView alloc]initWithFrame:CGRectMake((src.width-54*3)/(3+1) + i%personArr.count*(54+(src.width-54*3)/(personArr.count+1)), 0, 54, 54)];
            cryImage.image=[UIImage imageNamed:@"icon3"];
            [src addSubview:cryImage];
            
            UILabel *notice=[[UILabel alloc]initWithFrame:CGRectMake(cryImage.left, cryImage.bottom+10, cryImage.width, 13)];
            notice.textAlignment=NSTextAlignmentCenter;
            notice.text=@"张大大";
            notice.font=[UIFont systemFontOfSize:13.0];
            notice.textColor=RGB(51,51,51);
            [src addSubview:notice];
            
            UILabel *birth=[[UILabel alloc]initWithFrame:CGRectMake(cryImage.left, notice.bottom+10, notice.width, 12)];
            birth.textAlignment=NSTextAlignmentCenter;
            birth.text=@"9月26日生日";
            birth.font=[UIFont systemFontOfSize:13.0];
            birth.textColor=RGB(51,51,51);
            [src addSubview:birth];
            
            src.contentSize=CGSizeMake(cryImage.right, 0);
        }

    }
    [bgView addSubview:src];
    
    UIButton *sendCoupon=[UIButton buttonWithType:UIButtonTypeCustom];
    [sendCoupon setTitle:@"送上生日优惠信息" forState:UIControlStateNormal];
    [ sendCoupon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendCoupon.backgroundColor=NavBackGroundColor;
    sendCoupon.frame=CGRectMake(19, src.height-113, src.width-38, 46);
    sendCoupon.layer.cornerRadius=12;
    sendCoupon.clipsToBounds=YES;
    [src addSubview:sendCoupon];
    [sendCoupon addTarget:self action:@selector(sendCouponBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *bottomLable=[[UILabel alloc]initWithFrame:CGRectMake(0, sendCoupon.bottom+15, src.width, 13)];
    bottomLable.text=@"即将生日的会员会在生日当天收到优惠信息";
    bottomLable.font=[UIFont systemFontOfSize:13.0f];
    bottomLable.textColor=RGB(119, 119, 119);
    bottomLable.textAlignment=NSTextAlignmentCenter;
    [src addSubview:bottomLable];
    
}
//生日提醒
-(void)noticeTimeLimit{
    
}
//送生日问候
-(void)sendCouponBtnClick{
    
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
