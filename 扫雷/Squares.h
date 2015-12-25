//
//  Squares.h
//  扫雷
//
//  Created by 国栋 on 15/12/21.
//  Copyright (c) 2015年 GD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Squares;
@protocol SquaresDelegate <NSObject>

-(void)openAround:(Squares*)squ;
-(void)setTitle:(NSString*)str color:(UIColor*)color;

@end


@interface Squares : UIButton

@property id<SquaresDelegate> delegate;
@property CGSize size,space;
@property BOOL isBoom,isOpen,isMake;
@property int x,y,num;
@property UILongPressGestureRecognizer *lon;
@property NSDate *date;

-(instancetype)initWithDelegate:(id<SquaresDelegate>)theDelegate x:(int)theX y:(int)theY  sizeofSquares:(CGSize)theSize spaceBetweenSquares:(CGSize)theSpace;
-(void)open;

@end
