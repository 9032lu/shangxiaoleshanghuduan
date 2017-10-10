//
//  LZDDopDownView.m
//  BletcShop
//
//  Created by Bletc on 2017/9/21.
//  Copyright © 2017年 bletc. All rights reserved.
//

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define kTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define kDetailTextColor [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1]
#define kSeparatorColor [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]
#define kCellBgColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]
#define kTextSelectColor [UIColor colorWithRed:246/255.0 green:79/255.0 blue:0/255.0 alpha:1]

#define kTableViewCellHeight 43
#define kTableViewHeight 300
#define kButtomImageViewHeight 21

#import "LZDDopDownView.h"


@interface LZDDopDownView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger currentSelectedMenudIndex;  // 当前选中列


@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) BOOL show;

@property (nonatomic, strong) UITableView *tableView;   // 列表
@property (nonatomic, strong) UIImageView *buttomImageView; // 底部imageView
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, weak) UIView *bottomShadow;
@property (nonatomic, assign) NSInteger numOfMenu;


@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *indicators;
@property (nonatomic, copy) NSArray *bgLayers;

@property(nonatomic,strong)NSIndexPath *selectIndexPath;//选中的行

@property(nonatomic,strong)NSMutableDictionary *fode_muta_dic;
@end


@implementation LZDDopDownView
{
    CGFloat _tableViewHeight;
    
    
    NSInteger old_section_index;
}


-(NSArray *)data_source_A{
    if (!_data_source_A) {
        _data_source_A = [NSArray array];
    }
    return _data_source_A;
}

-(NSMutableDictionary *)fode_muta_dic{
    if (!_fode_muta_dic) {
        _fode_muta_dic =[NSMutableDictionary dictionary];
        for (int i = 0; i<self.data_source_A.count; i++) {
            
            if (i==0) {
                [_fode_muta_dic setValue:@"1" forKey:@"0"];
            }else{
                [_fode_muta_dic setValue:@"0" forKey:[NSString stringWithFormat:@"%d",i]];

            }
        }
    }
    return _fode_muta_dic;
}


#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height andSuperView:(UIView*)supview {
    CGSize screenSize = supview.bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    if (self) {
        _origin = origin;

        _show = NO;
        _numOfMenu = 2;
        _currentSelectedMenudIndex = 0;

        _tableViewHeight = IS_IPHONE_4_OR_LESS ? 200 : kTableViewHeight;
        old_section_index = 0;
        
        CGFloat textLayerInterval = self.frame.size.width / ( _numOfMenu * 2);
        CGFloat separatorLineInterval = self.frame.size.width / _numOfMenu;
        CGFloat bgLayerInterval = self.frame.size.width / _numOfMenu;
        
        NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
        NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
        NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
        
        
        for (int i = 0; i < _numOfMenu; i++) {
            //bgLayer
            CGPoint bgLayerPosition = CGPointMake((i+0.5)*bgLayerInterval, self.frame.size.height/2);
            CALayer *bgLayer = [self createBgLayerWithColor:[UIColor whiteColor] andPosition:bgLayerPosition];
            [self.layer addSublayer:bgLayer];
            [tempBgLayers addObject:bgLayer];
            //title
            CGPoint titlePosition = CGPointMake( (i * 2 + 1) * textLayerInterval , self.frame.size.height / 2);
            
            NSString *titleString = @"标题标题标题标题标题";
//            if (!self.isClickHaveItemValid && _dataSourceFlags.numberOfItemsInRow && [_dataSource menu:self numberOfItemsInRow:0 column:i]>0) {
//                titleString = [_dataSource menu:self titleForItemsInRowAtIndexPath:[DOPIndexPath indexPathWithCol:i row:0 item:0]];
//            }else {
//                titleString =[_dataSource menu:self titleForRowAtIndexPath:[DOPIndexPath indexPathWithCol:i row:0]];
//            }
            
            CATextLayer *title = [self createTextLayerWithNSString:titleString withColor:kTextColor andPosition:titlePosition];
            [self.layer addSublayer:title];
            [tempTitles addObject:title];
            //indicator
            CAShapeLayer *indicator = [self createIndicatorWithColor:kTextColor andPosition:CGPointMake((i + 1)*separatorLineInterval - 10, self.frame.size.height / 2)];
            [self.layer addSublayer:indicator];
            [tempIndicators addObject:indicator];
            
            //separator
            if (i != _numOfMenu - 1) {
                CGPoint separatorPosition = CGPointMake(ceilf((i + 1) * separatorLineInterval-1), self.frame.size.height / 2);
                CAShapeLayer *separator = [self createSeparatorLineWithColor:kSeparatorColor andPosition:separatorPosition];
                [self.layer addSublayer:separator];
            }
            
            
        }

        _titles = [tempTitles copy];
        _indicators = [tempIndicators copy];
        _bgLayers = [tempBgLayers copy];

        _selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        
        

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0) style:UITableViewStyleGrouped];
        _tableView.rowHeight = kTableViewCellHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.separatorColor = kSeparatorColor;
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 13);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableFooterView = [[UIView alloc]init];
        
        
        
        _buttomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, kButtomImageViewHeight)];
        _buttomImageView.image = [UIImage imageNamed:@"icon_chose_bottom"];
        
        //self tapped
        self.backgroundColor = [UIColor whiteColor];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, screenSize.width, screenSize.height-(self.frame.origin.y + self.frame.size.height))];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
        
        //add bottom shadow
        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, screenSize.width, 0.5)];
        bottomShadow.backgroundColor = kSeparatorColor;
        bottomShadow.hidden = NO;
        [self addSubview:bottomShadow];
        _bottomShadow = bottomShadow;
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.data_source_A.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.data_source_A[section][@"content"];
    

    
    if ([self.fode_muta_dic[[NSString stringWithFormat:@"%ld",section]] boolValue]) {
        return arr.count;

    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return kTableViewCellHeight;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIButton *backView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kTableViewCellHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.tag = section;
    [backView addTarget:self action:@selector(sectionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, SCREENWIDTH-42, backView.height)];
    titleLab.textColor =kTextColor;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.text = self.data_source_A[section][@"title"];
    [backView addSubview:titleLab];
    
    UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(13, backView.height-0.5, SCREENWIDTH-26, 0.5)];
    bottomShadow.backgroundColor = kSeparatorColor;
    [backView addSubview:bottomShadow];


    return backView;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LZDdopCell *cell = [LZDdopCell creatLZDDopCellWithTableView:tableView];
    
    NSArray *arr = self.data_source_A[indexPath.section][@"content"];

    
    cell.titleLab.text = arr[indexPath.row];

    if (indexPath==self.selectIndexPath) {
        cell.titleLab.textColor = kTextSelectColor;
    }else{
        cell.titleLab.textColor = kTextColor;

    }
    

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectIndexPath = indexPath;
    
    CATextLayer *title = (CATextLayer *)_titles[0];
    CATextLayer *content = (CATextLayer *)_titles[1];
    

    NSArray *arr = self.data_source_A[indexPath.section][@"content"];
    
    
    content.string = arr[indexPath.row];
    title.string = self.data_source_A[indexPath.section][@"title"];
    
    
    [_tableView reloadData];
    
    
    if (self.selectBlock) {
        self.selectBlock(indexPath.section, indexPath.row);
    }

    NSLog(@"===%ld==%ld",indexPath.section,indexPath.row);
//
    
    
    
    
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
    
}

-(void)sectionClick:(UIButton*)sender{
    
   // 2  2
    for (int i = 0; i<self.data_source_A.count; i++) {
        
        if (i==sender.tag) {
            
            if ([_fode_muta_dic[[NSString stringWithFormat:@"%d",i]] boolValue]) {
                [_fode_muta_dic setValue:@"0" forKey:[NSString stringWithFormat:@"%d",i]];

            }else{
                [_fode_muta_dic setValue:@"1" forKey:[NSString stringWithFormat:@"%d",i]];

            }

        }else{
            
                [_fode_muta_dic setValue:@"0" forKey:[NSString stringWithFormat:@"%d",i]];

 
        }
        
        
    }

    old_section_index =sender.tag;

    [_tableView reloadData];
    
    
    NSInteger num =0 ;
    
    
    for (int i = 0; i <[_tableView numberOfSections]; i ++) {
        
        num += ([_tableView numberOfRowsInSection:i]+1);
        
    }
    
    
    CGFloat tableViewHeight = num * kTableViewCellHeight > _tableViewHeight+1 ? _tableViewHeight:num*kTableViewCellHeight+1;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _tableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, tableViewHeight);
        
        _buttomImageView.frame = CGRectMake(self.origin.x, CGRectGetMaxY(_tableView.frame)-2, self.frame.size.width, kButtomImageViewHeight);
    }];

    

}


- (void)selectDefalutIndexPath
{
    [self.tableView.delegate tableView:_tableView didSelectRowAtIndexPath:_selectIndexPath];
}
#pragma mark - gesture handle
- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
        
        
    }];
}


- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    
    
    CGPoint touchPoint = [paramSender locationInView:self];

    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    

    
    if (tapIndex == _currentSelectedMenudIndex && _show) {
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _currentSelectedMenudIndex = tapIndex;
            _show = NO;
        }];
    } else {
              if (_show) {
            

        }else{
           
            _currentSelectedMenudIndex = tapIndex;
            [_tableView reloadData];
            

            [self animateIdicator:_indicators[tapIndex] background:_backGroundView tableView:_tableView title:_titles[tapIndex] forward:YES complecte:^{
                _show = YES;
            }];

            
        }
        
        
}
    
    
}

#pragma mark - animation method

- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background tableView:(UITableView *)tableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    
   
    
    [self animateIndicator:indicator Forward:forward complete:^{
        
        
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateTableView:tableView show:forward complete:^{
                }];
            }];
        }];
    }];
    
    complete();
}
- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete {
    
    NSLog(@"=======%@",title.string);
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    if (!show) {
        title.foregroundColor = kTextColor.CGColor;
    } else {
        title.foregroundColor = kTextSelectColor.CGColor;
    }
    complete();
}

- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    if (forward) {
        // 展开
        indicator.fillColor = kTextSelectColor.CGColor;
    } else {
        // 收缩
        indicator.fillColor = kTextColor.CGColor;
    }
    
    complete();
}


- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)())complete {
    
    if (show) {
   

        [self.superview addSubview:_tableView];
            
        [self.superview addSubview:_buttomImageView];
        
        NSInteger num =0 ;
        

        for (int i = 0; i <[_tableView numberOfSections]; i ++) {
            
            num += ([_tableView numberOfRowsInSection:i]+1);
            
        }
        
        
        CGFloat tableViewHeight = num * kTableViewCellHeight > _tableViewHeight+1 ? _tableViewHeight:num*kTableViewCellHeight+1;
        
        [UIView animateWithDuration:0.2 animations:^{
            
             _tableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, tableViewHeight);
            
            _buttomImageView.frame = CGRectMake(self.origin.x, CGRectGetMaxY(_tableView.frame)-2, self.frame.size.width, kButtomImageViewHeight);
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
           
            
                _tableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            
            _buttomImageView.frame = CGRectMake(self.origin.x, CGRectGetMaxY(_tableView.frame)-2, self.frame.size.width, kButtomImageViewHeight);
        } completion:^(BOOL finished) {
            
            
            [_tableView removeFromSuperview];
            [_buttomImageView removeFromSuperview];
            
        }];
    }
    complete();
}

#pragma mark - init support

- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 20)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    return layer;
}

- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width/self.numOfMenu, self.frame.size.height-1);
    layer.backgroundColor = color.CGColor;
    
    return layer;
}
- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 0.8;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    
    return layer;
}

- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {
    
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 14;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.truncationMode = kCATruncationEnd;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}

- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    //CGFloat fontSize = 14.0;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return CGSizeMake(ceilf(size.width)+2, size.height);
}

@end




@implementation LZDdopCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = kSeparatorColor;
        [self creatSubViews];
    }
    return self;
    
}

+(instancetype)creatLZDDopCellWithTableView:(UITableView*)tableView{
    
    static NSString *identifier = @"lzdDopCell";

    LZDdopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        
        cell = [[LZDdopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
    
    
}


-(void)creatSubViews{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kTableViewCellHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:backView];
    
    self.cellBackView = backView;
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(42, 0, SCREENWIDTH-42, backView.height)];
    titleLab.textColor =kTextColor;
    titleLab.font = [UIFont systemFontOfSize:14];
    [backView addSubview:titleLab];
    
    self.titleLab = titleLab;
    
    UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(13, backView.height-0.5, SCREENWIDTH-26, 0.5)];
    bottomShadow.backgroundColor = kSeparatorColor;
    [backView addSubview:bottomShadow];

}
@end
