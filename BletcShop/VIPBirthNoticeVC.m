//
//  VIPBirthNoticeVC.m
//  BletcShop
//
//  Created by apple on 2017/9/20.
//  Copyright © 2017年 bletc. All rights reserved.
//

#import "VIPBirthNoticeVC.h"

@interface VIPBirthNoticeVC ()
{
    UIView *alert;
}
@end

@implementation VIPBirthNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(240, 240, 240);
    self.navigationItem.title=@"生日优惠";
    LEFTBACK
    UIButton *customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame=CGRectMake(0, 0, 20, 20);
    [customButton setImage:[UIImage imageNamed:@"生日提醒icon"] forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(noticeTimeLimit) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:customButton];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(13, 15, SCREENWIDTH-26, SCREENHEIGHT-64-15-77)];
    bgView.backgroundColor=[UIColor whiteColor];
    bgView.layer.cornerRadius=12;
    bgView.clipsToBounds=YES;
    [self.view addSubview:bgView];
    
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.width, 268*bgView.width/698)];
    headImage.image=[UIImage imageNamed:@"srbj"];
    [bgView addSubview:headImage];
    int a = arc4random()%2;
    int b=arc4random()%6+1;
    int state=a;//state 代表有会员还是没会员生日==0没有，1有
    NSMutableArray *personArr=[[NSMutableArray alloc]initWithCapacity:0];
    NSDictionary *dic=@{@"image":@"icon3",@"name":@"张大大",@"birth":@"9月26日"};
    for (int k=0; k<b; k++) {
        [personArr addObject:dic];
    }
//    NSArray *personArr=@[@{@"image":@"icon3",@"name":@"张大大",@"birth":@"9月26日"},@{@"image":@"icon3",@"name":@"张大大",@"birth":@"9月26日"},@{@"image":@"icon3",@"name":@"张大大",@"birth":@"9月26日"}];
    
    
    
    UIScrollView *src=[[UIScrollView alloc]initWithFrame:CGRectMake(0, (bgView.height-110)/2-30, bgView.width, 110)];
    src.showsVerticalScrollIndicator=NO;
    src.showsHorizontalScrollIndicator=NO;
    if (personArr.count==1) {
        if (state==0) {
            UIImageView *cryImage=[[UIImageView alloc]initWithFrame:CGRectMake((src.width-54)/2, 0, 54, 54)];
            cryImage.layer.cornerRadius=27;
            cryImage.clipsToBounds=YES;
            cryImage.image=[UIImage imageNamed:@"表情ss"];
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
            cryImage.layer.cornerRadius=27;
            cryImage.clipsToBounds=YES;
            cryImage.image=[UIImage imageNamed:@"icon3"];
            [src addSubview:cryImage];
            
            UIImageView *circle=[[UIImageView alloc]initWithFrame:CGRectMake(cryImage.right-16, cryImage.top, 16, 16)];
            circle.image=[UIImage imageNamed:@"选择ssss"];
            [src addSubview:circle];
            
            UILabel *notice=[[UILabel alloc]initWithFrame:CGRectMake(0, cryImage.bottom+10, src.width, 13)];
            notice.textAlignment=NSTextAlignmentCenter;
            notice.text=@"张大大";
            notice.font=[UIFont systemFontOfSize:13.0];
            notice.textColor=RGB(51,51,51);
            [src addSubview:notice];
            
            UILabel *birth=[[UILabel alloc]initWithFrame:CGRectMake(0, notice.bottom+10, src.width, 12)];
            birth.textAlignment=NSTextAlignmentCenter;
            birth.text=@"9月26日";
            birth.font=[UIFont systemFontOfSize:13.0];
            birth.textColor=RGB(51,51,51);
            [src addSubview:birth];
            
            src.contentSize=CGSizeMake(0, 0);
        }
    }else if(personArr.count<=3){
        for (int i=0; i<personArr.count; i++) {
            UIImageView *cryImage=[[UIImageView alloc]initWithFrame:CGRectMake((src.width-54*personArr.count)/(personArr.count+1) + i%personArr.count*(54+(src.width-54*personArr.count)/(personArr.count+1)), 0, 54, 54)];
            cryImage.layer.cornerRadius=27;
            cryImage.clipsToBounds=YES;
            cryImage.image=[UIImage imageNamed:@"icon3"];
            [src addSubview:cryImage];
            
            UIImageView *circle=[[UIImageView alloc]initWithFrame:CGRectMake(cryImage.right-16, cryImage.top, 16, 16)];
            circle.image=[UIImage imageNamed:@"选择ssss"];
            [src addSubview:circle];
            
            UILabel *notice=[[UILabel alloc]initWithFrame:CGRectMake(cryImage.left, cryImage.bottom+10, cryImage.width, 13)];
            notice.textAlignment=NSTextAlignmentCenter;
            notice.text=@"张大大";
            notice.font=[UIFont systemFontOfSize:13.0];
            notice.textColor=RGB(51,51,51);
            [src addSubview:notice];
            
            UILabel *birth=[[UILabel alloc]initWithFrame:CGRectMake(cryImage.left, notice.bottom+10, notice.width, 12)];
            birth.textAlignment=NSTextAlignmentCenter;
            birth.text=@"9月26日";
            birth.font=[UIFont systemFontOfSize:13.0];
            birth.textColor=RGB(51,51,51);
            [src addSubview:birth];
            
            src.contentSize=CGSizeMake(0, 0);
        }
    }else{
        for (int i=0; i<personArr.count; i++) {
            UIImageView *cryImage=[[UIImageView alloc]initWithFrame:CGRectMake((src.width-54*3)/(3+1) + i%personArr.count*(54+(src.width-54*3)/(3+1)), 0, 54, 54)];
            cryImage.image=[UIImage imageNamed:@"icon3"];
            cryImage.layer.cornerRadius=27;
            cryImage.clipsToBounds=YES;
            [src addSubview:cryImage];
            
            UIImageView *circle=[[UIImageView alloc]initWithFrame:CGRectMake(cryImage.right-16, cryImage.top, 16, 16)];
            circle.image=[UIImage imageNamed:@"选择ssss"];
            [src addSubview:circle];
            
            UILabel *notice=[[UILabel alloc]initWithFrame:CGRectMake(cryImage.left, cryImage.bottom+10, cryImage.width, 13)];
            notice.textAlignment=NSTextAlignmentCenter;
            notice.text=@"张大大";
            notice.font=[UIFont systemFontOfSize:13.0];
            notice.textColor=RGB(51,51,51);
            [src addSubview:notice];
            
            UILabel *birth=[[UILabel alloc]initWithFrame:CGRectMake(cryImage.left, notice.bottom+10, notice.width, 12)];
            birth.textAlignment=NSTextAlignmentCenter;
            birth.text=@"9月26日";
            birth.font=[UIFont systemFontOfSize:13.0];
            birth.textColor=RGB(51,51,51);
            [src addSubview:birth];
            
            src.contentSize=CGSizeMake(cryImage.right, 0);
        }

    }
    [bgView addSubview:src];
    
    UIButton *sendCoupon=[UIButton buttonWithType:UIButtonTypeCustom];
    [sendCoupon setTitle:@"送上生日优惠" forState:UIControlStateNormal];
    [ sendCoupon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendCoupon.backgroundColor=NavBackGroundColor;
    sendCoupon.frame=CGRectMake(19, bgView.height-113, bgView.width-38, 46);
    sendCoupon.layer.cornerRadius=12;
    sendCoupon.clipsToBounds=YES;
    [bgView addSubview:sendCoupon];
    [sendCoupon addTarget:self action:@selector(sendCouponBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *bottomLable=[[UILabel alloc]initWithFrame:CGRectMake(0, sendCoupon.bottom+15, bgView.width, 13)];
    bottomLable.text=@"即将生日的会员会在生日当天收到优惠信息";
    bottomLable.font=[UIFont systemFontOfSize:13.0f];
    bottomLable.textColor=RGB(119, 119, 119);
    bottomLable.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:bottomLable];
    
    if (personArr.count==1&&state==0) {
        sendCoupon.backgroundColor=RGB(166, 166, 166);
        sendCoupon.userInteractionEnabled=NO;
    }
}
//生日提醒
-(void)noticeTimeLimit{
    if (!alert) {
        alert=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
        alert.backgroundColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.3];
        [self.view addSubview:alert];
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(13, 0, SCREENWIDTH-26, 273)];
        bgView.backgroundColor=[UIColor whiteColor];
        bgView.layer.cornerRadius=12;
        bgView.clipsToBounds=YES;
        [alert addSubview:bgView];
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgView.width, 55)];
        title.text=@"开启会员生日提醒有助优惠信息推送";
        title.font=[UIFont systemFontOfSize:16];
        title.textAlignment=NSTextAlignmentCenter;
        title.textColor=RGB(51,51,51);
        [bgView addSubview:title];
        
        UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, title.bottom, bgView.width, 1)];
        line1.backgroundColor=RGB(220,220,220);
        [bgView addSubview:line1];
        
        UILabel *notone=[[UILabel alloc]initWithFrame:CGRectMake(0, line1.bottom, bgView.width, 54)];
        notone.text=@"提前一个月提醒";
        notone.userInteractionEnabled=YES;
        notone.tag=1;
        notone.font=[UIFont systemFontOfSize:16];
        notone.textAlignment=NSTextAlignmentCenter;
        notone.textColor=RGB(51,51,51);
        [bgView addSubview:notone];
        
        UIImageView *checkmark=[[UIImageView alloc]initWithFrame:CGRectMake(bgView.width-60, line1.bottom+17, 20, 20)];
        checkmark.tag=1;
        checkmark.image=[UIImage imageNamed:@"对号ssss"];
        [bgView addSubview:checkmark];
        
        
        UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [notone addGestureRecognizer:tap1];
        
        
        
        UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, notone.bottom, bgView.width, 1)];
        line2.backgroundColor=RGB(220,220,220);
        [bgView addSubview:line2];
        
        UILabel *notow=[[UILabel alloc]initWithFrame:CGRectMake(0, line2.bottom, bgView.width, 54)];
        notow.text=@"提前半个月提醒";
        notow.userInteractionEnabled=YES;
        notow.tag=2;
        notow.font=[UIFont systemFontOfSize:16];
        notow.textAlignment=NSTextAlignmentCenter;
        notow.textColor=RGB(51,51,51);
        [bgView addSubview:notow];
        
        UIImageView *checkmark2=[[UIImageView alloc]initWithFrame:CGRectMake(bgView.width-60, line2.bottom+17, 20, 20)];
        checkmark2.tag=2;
        checkmark2.image=[UIImage imageNamed:@""];
        [bgView addSubview:checkmark2];
        
        
        UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [notow addGestureRecognizer:tap2];
        
        UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(0, notow.bottom, bgView.width, 1)];
        line3.backgroundColor=RGB(220,220,220);
        [bgView addSubview:line3];
        
        UILabel *nothree=[[UILabel alloc]initWithFrame:CGRectMake(0, line3.bottom, bgView.width, 54)];
        nothree.text=@"提前一周提醒";
        nothree.userInteractionEnabled=YES;
        nothree.tag=3;
        nothree.font=[UIFont systemFontOfSize:16];
        nothree.textAlignment=NSTextAlignmentCenter;
        nothree.textColor=RGB(51,51,51);
        [bgView addSubview:nothree];
        
        UIImageView *checkmark3=[[UIImageView alloc]initWithFrame:CGRectMake(bgView.width-60, line3.bottom+17, 20, 20)];
        checkmark3.tag=3;
        checkmark3.image=[UIImage imageNamed:@""];
        [bgView addSubview:checkmark3];
        
        UITapGestureRecognizer *tap3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [nothree addGestureRecognizer:tap3];
        
        UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(0, nothree.bottom, bgView.width, 1)];
        line4.backgroundColor=RGB(220,220,220);
        [bgView addSubview:line4];
        
        UIButton *closeNotice=[[UIButton alloc]initWithFrame:CGRectMake(0, line4.bottom, bgView.width, 54)];
        closeNotice.backgroundColor=[UIColor whiteColor];
        [closeNotice setTitle:@"关闭提醒" forState:UIControlStateNormal];
        [closeNotice setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        closeNotice.titleLabel.font=[UIFont systemFontOfSize:16];
        [bgView addSubview:closeNotice];
        [closeNotice addTarget:self action:@selector(closeNoticeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
}
//送生日问候
-(void)sendCouponBtnClick{
    NSLog(@"老板！！！！！！！！！！");
}
-(void)closeNoticeBtnClick{
    [alert removeFromSuperview];
    alert=nil;
}
-(void)tapClick:(UITapGestureRecognizer *)tap{
    for (UIView *view in tap.view.superview.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView=(UIImageView *)view;
            if (imageView.tag==tap.view.tag) {
                imageView.image=[UIImage imageNamed:@"对号ssss"];
            }else{
                imageView.image=[UIImage imageNamed:@""];
            }
        }
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
