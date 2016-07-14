//
//  BasicViewController.m
//  FindFriends
//
//  Created by jiao qing on 14/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

#import "BasicViewController.h"
#import "FindFriends-swift.h"

@interface BasicViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIBarButtonItem *backBar;
@end

@implementation BasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"";
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont mediumfont:15];
        _titleLabel.frame = CGRectMake(0, 0, 0, 30);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor defaultBlack];
    }
    return _titleLabel;
}

-(void)willMoveToParentViewController:(UIViewController *)parent{
    if (parent) {
        self.navigationItem.titleView = self.titleLabel;
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = self.backBar;
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//        self.navigationController.navigationBar.translucent = NO;
    }
}

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
}

-(UIBarButtonItem *)backBar{
    if (!_backBar) {
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44.0f)];
        [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *backIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 23, 19)];
        backIV.image = [UIImage imageNamed:@"BackIconNormal"];
        [backBtn addSubview:backIV];
        
        return [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
    return _backBar;
}


- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
