//
//  CustomKeybord.m
//  autobole
//
//  Created by wyz on 2017/7/18.
//  Copyright © 2017年 autobole. All rights reserved.
//

#import "CustomKeyboard.h"

#define kContentHeight 220
#define plateNumberLength 7
#define labelWidth (kScreenWidth/13)


@implementation CustomKeyboard
{
    UIView* _backView;
    UIView* _headerView;
    UIView* _provinceView;
    UIView* _letterView;
    NSArray* _letters;
    NSArray* _provinces;
    NSMutableArray* _values;
    NSMutableArray* _labels;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setup];
        [self backView];
        [self headerView];
        [self provinceView];
        [self letterView];
    }
    return self;
}
+(CustomKeyboard *)initWithDelegate:(id)delegate{
    CustomKeyboard* keyboard=[[CustomKeyboard alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    keyboard.backgroundColor=[UIColor clearColor];
    keyboard.delegate=delegate;
    return keyboard;
}
//
-(void)setup{
    UIButton* hideBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kContentHeight)];
    [hideBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hideBtn];
    _letters=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"];
    _provinces=@[@"川",@"鄂",@"贵",@"桂",@"甘",@"赣",@"沪",@"黑",@"京",@"津",@"吉",@"晋",@"冀",@"鲁",@"辽",@"闽",@"蒙",@"宁",@"琼",@"青",@"陕",@"苏",@"皖",@"新",@"湘",@"豫",@"云",@"渝",@"粤",@"藏",@"浙",@"使",@"领",@"警",@"学",@"港",@"澳"];
    _values=[NSMutableArray array];
    _labels=[NSMutableArray array];
}
-(void)backView{
    _backView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kContentHeight)];
    _backView.backgroundColor=ColorFromHex(0xeeeeee);
    [self addSubview:_backView];
}
-(void)headerView{
    _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    _headerView.backgroundColor=[UIColor whiteColor];
    [_backView addSubview:_headerView];
    
    for (int i=0; i<plateNumberLength; i++) {
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(i*38, 0, 38, 38)];
        [_headerView addSubview:view];
        
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(4, 4, 30, 30)];
        label.textAlignment=NSTextAlignmentCenter;
        label.layer.borderColor=i==0?[UIColor redColor].CGColor:[UIColor blackColor].CGColor;
        label.layer.borderWidth=1;
        label.layer.cornerRadius=3;
        [view addSubview:label];
        [_labels addObject:label];
    }
    
    UIButton* doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-50, 7, 44, 30)];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:ColorFromHex(0x1FBCD2) forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.layer.cornerRadius=5;
    doneBtn.layer.borderColor=ColorFromHex(0x1FBCD2).CGColor;
    doneBtn.layer.borderWidth=1;
    [_headerView addSubview:doneBtn];
}
-(void)provinceView{
    _provinceView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kContentHeight-44)];
    _provinceView.backgroundColor=ColorFromHex(0xeeeeee);
    float viewWidth=kScreenWidth/10;
    
    for (int i=0; i<30; i++) {
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(i%10*viewWidth, i/10*44, viewWidth, 44)];
        [_provinceView addSubview:view];
        
        UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(viewWidth/2-labelWidth/2, 7, labelWidth, 30)];
        [btn setTitle:_provinces[i] forState:UIControlStateNormal];
        btn.tag=i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.cornerRadius=5;
        [view addSubview:btn];
    }
    
    UIView* cancelView=[[UIView alloc]initWithFrame:CGRectMake(0, 132, viewWidth*1.5, 44)];
    [_provinceView addSubview:cancelView];
    UIButton* switchBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, viewWidth*1.5-10, 34)];
    [switchBtn setTitle:@"ABC" forState:UIControlStateNormal];
    [switchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [switchBtn setBackgroundColor:[UIColor lightGrayColor]];
    [switchBtn addTarget:self action:@selector(switchProvinceAndLetter:) forControlEvents:UIControlEventTouchUpInside];
    switchBtn.layer.cornerRadius=5;
    [cancelView addSubview:switchBtn];
    
    UIView* deleteView=[[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-viewWidth*1.5, 132, viewWidth*1.5, 44)];
    [_provinceView addSubview:deleteView];
    UIButton* deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, viewWidth*1.5-10, 34)];
    [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    deleteBtn.contentEdgeInsets=UIEdgeInsetsMake(3, 3, 3, 3);
    [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.layer.cornerRadius=5;
    deleteBtn.layer.masksToBounds=YES;
    [deleteView addSubview:deleteBtn];
    
    NSArray* arr=[_provinces subarrayWithRange:NSMakeRange(30, 7)];
    for (int i=0; i<arr.count; i++) {
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(viewWidth*1.5+i%10*viewWidth, 132, viewWidth, 44)];
        [_provinceView addSubview:view];
        
        UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(viewWidth/2-labelWidth/2, 7, labelWidth, 30)];
        btn.tag=30+i;
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.cornerRadius=5;
        [view addSubview:btn];
    }
    [_backView addSubview:_provinceView];
}
-(void)letterView{
    _letterView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kContentHeight-44)];
    _letterView.backgroundColor=ColorFromHex(0xeeeeee);
    _letterView.hidden=YES;
    float viewWidth=kScreenWidth/10;
    for (int i=0; i<20; i++) {
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(i%10*viewWidth, i/10*44, viewWidth, 44)];
        [_letterView addSubview:view];
        
        UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(viewWidth/2-labelWidth/2, 7, labelWidth, 30)];
        btn.tag=i;
        [btn setTitle:_letters[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.cornerRadius=5;
        [view addSubview:btn];
    }
    NSArray* arr=[_letters subarrayWithRange:NSMakeRange(20, 9)];
    for (int i=0; i<arr.count; i++) {
        float viewWidth=kScreenWidth/9;
        
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(i*viewWidth, 88, viewWidth, 44)];
        [_letterView addSubview:view];
        
        UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(viewWidth/2-labelWidth/2, 7, labelWidth, 30)];
        btn.tag=20+i;
        [btn addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.cornerRadius=5;
        [view addSubview:btn];
    }
    
    UIView* cancelView=[[UIView alloc]initWithFrame:CGRectMake(0, 132, viewWidth*1.5, 44)];
    [_letterView addSubview:cancelView];
    UIButton* switchBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, viewWidth*1.5-10, 34)];
    [switchBtn setTitle:@"省" forState:UIControlStateNormal];
    [switchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [switchBtn setBackgroundColor:[UIColor lightGrayColor]];
    [switchBtn addTarget:self action:@selector(switchProvinceAndLetter:) forControlEvents:UIControlEventTouchUpInside];
    switchBtn.layer.cornerRadius=5;
    [cancelView addSubview:switchBtn];
    
    
    UIView* deleteView=[[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-viewWidth*1.5, 132, viewWidth*1.5, 44)];
    [_letterView addSubview:deleteView];
    UIButton* deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, viewWidth*1.5-10, 34)];
    [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    deleteBtn.contentEdgeInsets=UIEdgeInsetsMake(3, 3, 3, 3);
    [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.layer.cornerRadius=5;
    [deleteView addSubview:deleteBtn];
    
    NSArray* arr2=[_letters subarrayWithRange:NSMakeRange(29, 7)];
    for (int i=0; i<arr2.count; i++) {
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(viewWidth*1.5+i%10*viewWidth, 132, viewWidth, 44)];
        [_letterView addSubview:view];
        
        UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(viewWidth/2-labelWidth/2, 7, labelWidth, 30)];
        btn.tag=29+i;
        [btn addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:arr2[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.cornerRadius=5;
        [view addSubview:btn];
    }
    [_backView addSubview:_letterView];
}


//action
-(void)switchProvinceAndLetter:(UIButton*)sender{
    _provinceView.hidden=[sender.titleLabel.text isEqualToString:@"ABC"];
    _letterView.hidden=!_provinceView.hidden;
}
-(void)delete:(UIButton*)sender{
    [_values removeLastObject];
    [self refreshData];
}
-(void)textChanged:(UIButton*)sender{
    NSString* value=_letterView.hidden==YES?_provinces[sender.tag]:_letters[sender.tag];
    NSLog(@"%@",value);
    if (_values.count<plateNumberLength) {
        [_values addObject:value];
    }
    [self refreshData];
}
-(void)done{
    if (_values.count==plateNumberLength) {
        [self hide];
        [_delegate customKeyboard:self didFinished:[_values componentsJoinedByString:@""]];
    }else{
        [SVProgressHUD dismissWithDelay:1];
        [SVProgressHUD showErrorWithStatus:@"位数不够!"];
    }
}
-(void)refreshData{
    _provinceView.hidden=_values.count>0;
    _letterView.hidden=!_provinceView.hidden;
    
    for (int i=0; i<plateNumberLength; i++) {
        UILabel* label=_labels[i];
        if (i+1>_values.count) {
            label.text=@"";
            label.layer.borderColor=i==_values.count?[UIColor redColor].CGColor:[UIColor blackColor].CGColor;
        }else{
            label.text=_values[i];
            label.layer.borderColor=[UIColor blackColor].CGColor;
        }
    }
}

//public
-(void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor=[UIColor colorWithWhite:0 alpha:.3];
        _backView.frame=CGRectMake(0, kScreenHeight-kContentHeight, kScreenWidth, kContentHeight);
    }];
}
-(void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor=[UIColor clearColor];
        _backView.frame=CGRectMake(0, kScreenHeight, kScreenWidth, kContentHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//other
-(UIColor*)randomColor{
    CGFloat hue = (arc4random() %256/256.0);
    CGFloat saturation = (arc4random() %128/256.0) +0.5;
    CGFloat brightness = (arc4random() %128/256.0) +0.5;
    UIColor*color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}
@end
