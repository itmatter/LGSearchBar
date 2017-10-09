//
//  ViewController.m
//  LGSearchBarController
//
//  Created by 李礼光 on 2017/10/9.
//  Copyright © 2017年 LG. All rights reserved.
//

#import "ViewController.h"
#import "LGSearchBarViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    

}


- (IBAction)button:(id)sender {
        [self presentViewController:[[LGSearchBarViewController alloc]init] animated:NO completion:nil];
}


@end
