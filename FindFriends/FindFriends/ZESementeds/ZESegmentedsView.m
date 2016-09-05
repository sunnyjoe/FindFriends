//
//  ZESegmentedsView.m
//  
//
//  Created by wzm on 16/4/8.
//  Copyright © 2016年 wzm. All rights reserved.
//

#import "ZESegmentedsView.h"

@implementation ZESegmentedsView

- (instancetype)initWithFrame:(CGRect)frame
               segmentedCount:(NSInteger)segmentedCount
              segmentedTitles:(NSArray *)titleArr {
    
    NSInteger semtViewWidth  = frame.size.width - ((NSInteger)frame.size.width%segmentedCount);
    NSInteger semtViewHeight = frame.size.height;
    
    if (self == [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, semtViewWidth, semtViewHeight)]) {
        
  
        

        NSInteger itemsWidth = semtViewWidth/segmentedCount;
        NSInteger itemsHeight = semtViewHeight;
        
        int j;
        
        for (int i = 0; i < segmentedCount; i++) {
            
            //NSLog(@"添加了%d个btn",i);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat x = i * itemsWidth;
            CGFloat y = 0;
            
            btn.frame = CGRectMake(x, y, itemsWidth, itemsHeight);
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = 1000 + i;
            btn.layer.masksToBounds = YES;
        
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:36/255.0 green:127/255.0 blue:211/255.0 alpha:1.0f] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            
            [self addSubview:btn];
            
            j = i;
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake( x+ itemsWidth, y, 1, itemsHeight)];
            lineView.backgroundColor = [UIColor colorWithRed:36/255.0 green:127/255.0 blue:211/255.0 alpha:1.0f];
                
            [self addSubview:lineView];
    
            
    
            
            [btn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
        }
        
        
    }
    
    self.layer.borderColor = [UIColor colorWithRed:36/255.0 green:127/255.0 blue:211/255.0 alpha:1.0f].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    

    
    return self;
}


#pragma mark - 按钮点击事件


- (void)clickItem:(UIButton *)btn {

    //NSLog(@"点击了btn");
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        btn.backgroundColor = [UIColor colorWithRed:36/255.0 green:127/255.0 blue:211/255.0 alpha:1.0f];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(selectedZESegmentedsViewItemAtIndex:)]) {
            
            [_delegate selectedZESegmentedsViewItemAtIndex:btn.tag - 1000];
            
        }

        
    }else{
    
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitleColor:[UIColor colorWithRed:36/255.0 green:127/255.0 blue:211/255.0 alpha:1.0f] forState:UIControlStateNormal];
        
        if (_delegate && [_delegate respondsToSelector:@selector(selectedZESegmentedsViewItemAtIndex:)]) {
            
            [_delegate selectedZESegmentedsViewItemAtIndex:btn.tag];
            
        }

        
        
    }
    
    


}

@end
