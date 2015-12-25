//
//  Squares.m
//  扫雷
//
//  Created by 国栋 on 15/12/21.
//  Copyright (c) 2015年 GD. All rights reserved.
//

#import "Squares.h"

@implementation Squares
@synthesize delegate,size,space,isBoom,isOpen,isMake,x,y,num,lon,date;

-(instancetype)initWithDelegate:(id<SquaresDelegate>)theDelegate x:(int)theX y:(int)theY sizeofSquares:(CGSize)theSize spaceBetweenSquares:(CGSize)theSpace
{
    if (self=[super init]) {
        delegate=theDelegate;
        size=theSize;
        space=theSpace;
        isBoom=NO;
        isOpen=NO;
        isMake=NO;
        x=theX;
        y=theY;
        num=0;
        date=[NSDate date];
        float coordinateX=size.width*x+space.width*(x+1);
        float coordinateY=size.height*y+space.height*(y+1);
        self.frame=CGRectMake(coordinateX, coordinateY, size.width, size.height);
        self.backgroundColor=[UIColor blueColor];
        [self addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
        lon=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(mark)];
        lon.minimumPressDuration=0.2;
        [self addGestureRecognizer:lon];
    }
    return self;
}
-(void)open
{
    if (isMake==YES) {
        return;
    }
    if (isOpen==NO) {
        isOpen=YES;
        if (isBoom==NO) {
            self.backgroundColor=[UIColor whiteColor];
            NSString *number=[NSString stringWithFormat:@"%d",num];
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [delegate openAround:self];
            if (num!=0)
            {
                [self setTitle:number forState:UIControlStateNormal];
            }
        }
        else
        {
            [delegate setTitle:@"失败" color:[UIColor redColor]];
            self.backgroundColor=[UIColor redColor];
        }
    }
}
-(void)mark
{
    if (isOpen==YES) {
        return;
    }
    if ([[NSDate date]timeIntervalSinceDate:date]<1) {
        return;
    }
    date=[NSDate date];
    if (isMake==NO) {
        isMake=YES;
        self.backgroundColor=[UIColor orangeColor];
        
    }
    else
    {
        isMake=NO;
        self.backgroundColor=[UIColor blueColor];
    }
}
@end
