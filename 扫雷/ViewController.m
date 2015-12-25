//
//  ViewController.m
//  扫雷
//
//  Created by 国栋 on 15/12/21.
//  Copyright (c) 2015年 GD. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@property NSMutableArray *list;
@property UIScrollView *chessboard;
@property CGPoint move;
@property long num;
@property CGSize contentSize;

@property UITextField *rowInput,*colInput,*boomInput;
@property UIButton *button;

@end

@implementation ViewController
@synthesize list,chessboard,move,num,contentSize,rowInput,colInput,boomInput,button;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rowInput=[[UITextField alloc]initWithFrame:CGRectMake(0, 20, 50, 30)];
    rowInput.placeholder=@"行数";
    [self.view addSubview:rowInput];
    
    colInput=[[UITextField alloc]initWithFrame:CGRectMake(50, 20, 50, 30)];
    colInput.placeholder=@"列数";
    [self.view addSubview:colInput];
    
    boomInput=[[UITextField alloc]initWithFrame:CGRectMake(100, 20, 50, 30)];
    boomInput.placeholder=@"雷数";
    [self.view addSubview:boomInput];
    
    button=[[UIButton alloc]initWithFrame:CGRectMake(150, 20, [UIScreen mainScreen].bounds.size.width-150, 30)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"重新开始" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self initChessboardWithRow:20 col:20 sizeofSquares:CGSizeMake(30, 30) spaceBetweenSquares:CGSizeMake(3, 3) numberOfBoom:20 chessboardRect:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-50)];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)restart
{
    [rowInput resignFirstResponder];
    [colInput resignFirstResponder];
    [boomInput resignFirstResponder];
    [self setTitle:@"重新开始" color:[UIColor blackColor]];
    
    [chessboard removeFromSuperview];
    chessboard=nil;
    [self initChessboardWithRow:[rowInput.text intValue] col:[colInput.text intValue] sizeofSquares:CGSizeMake(30, 30) spaceBetweenSquares:CGSizeMake(3, 3) numberOfBoom:[boomInput.text intValue] chessboardRect:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-50)];
}
-(void)initChessboardWithRow:(int)row col:(int)col sizeofSquares:(CGSize)size spaceBetweenSquares:(CGSize)space numberOfBoom:(int)boomNumber chessboardRect:(CGRect)rect
{
    list =[NSMutableArray array];
    
    float width=size.width*row+space.width*(row+1);
    float height=size.height*col+space.height*(col+1);
    contentSize=CGSizeMake(width, height);
    
    chessboard=[[UIScrollView alloc]initWithFrame:rect];
    num=row*col-boomNumber;
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    pan.delegate=self;
    [chessboard addGestureRecognizer:pan];
    
    //chessboard.contentOffset=CGPointMake(100, 100);
    
    chessboard.backgroundColor=[UIColor grayColor];
    [self.view addSubview:chessboard];
    
    for (int i=0; i<row; i++) {
        NSMutableArray *collist=[NSMutableArray array];
        for (int j=0; j<col; j++) {
            Squares *squ=[[Squares alloc]initWithDelegate:self x:i y:j sizeofSquares:size spaceBetweenSquares:space];
            [chessboard addSubview:squ];
            [collist addObject:squ];
        }
        [list addObject:collist];
    }
    
    for (int i=0; i<boomNumber; i++) {
    loop1:
        sranddev();
        int theRow=rand()%row;
        int theCol=rand()%col;
        Squares *randSquares=[self objectAtRow:theRow col:theCol];
        if(randSquares.isBoom==YES){
            goto loop1;
        }
        else
        {
            randSquares.isBoom=YES;
            [self objectAtRow:theRow+1 col:theCol+1].num++;
            [self objectAtRow:theRow+1 col:theCol].num++;
            [self objectAtRow:theRow+1 col:theCol-1].num++;
            [self objectAtRow:theRow col:theCol+1].num++;
            [self objectAtRow:theRow col:theCol-1].num++;
            [self objectAtRow:theRow-1 col:theCol+1].num++;
            [self objectAtRow:theRow-1 col:theCol].num++;
            [self objectAtRow:theRow-1 col:theCol-1].num++;
        }
    }
}
-(void)pan:(UIPanGestureRecognizer*)sender
{
    CGPoint trans=[sender translationInView:chessboard];
    float setX=chessboard.contentOffset.x-trans.x+move.x;
    float setY=chessboard.contentOffset.y-trans.y+move.y;
    //NSLog(@"%f %f",contentSize.width,contentSize.height);
    if (setX<0||(setX+chessboard.frame.size.width)>contentSize.width) {
        setX=chessboard.contentOffset.x;
    }
    if (setY<0||(setY+chessboard.frame.size.height)>contentSize.height) {
        setY=chessboard.contentOffset.y;
    }
    //if (setX>0&&setY>0&&(setX+chessboard.frame.size.width)<contentSize.width&&(setY+chessboard.frame.size.height)<contentSize.height) {}
    chessboard.contentOffset=CGPointMake(setX, setY);
    
    move=trans;
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    move=CGPointMake(0, 0);
    return YES;
}
-(Squares*)objectAtRow:(int)theRow col:(int)theCol
{
    NSMutableArray *collist;
    if (theRow<list.count) {
        collist=[list objectAtIndex:theRow];
    }
    else return nil;
    
    Squares *randSquares;
    if (theCol<collist.count) {
        randSquares=[collist objectAtIndex:theCol];
    }
    else return nil;
    return randSquares;
}
-(void)openAround:(Squares *)squ
{
    num--;
    if (num==0) {
        [self setTitle:@"成功" color:[UIColor greenColor]];
    }
    if (squ.num==0) {
        int theRow=squ.x;
        int theCol=squ.y;
        [[self objectAtRow:theRow+1 col:theCol+1]open];
        [[self objectAtRow:theRow+1 col:theCol]open];
        [[self objectAtRow:theRow+1 col:theCol-1]open];
        [[self objectAtRow:theRow col:theCol+1]open];
        [[self objectAtRow:theRow col:theCol-1]open];
        [[self objectAtRow:theRow-1 col:theCol+1]open];
        [[self objectAtRow:theRow-1 col:theCol]open];
        [[self objectAtRow:theRow-1 col:theCol-1]open];
    }
}
-(void)setTitle:(NSString*)str color:(UIColor*)color
{
    [button setTitle:str forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
