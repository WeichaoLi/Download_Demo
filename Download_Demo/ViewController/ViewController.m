//
//  ViewController.m
//  Download_Demo
//
//  Created by 李伟超 on 15/4/14.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [NSMutableArray arrayWithObjects:
                  @"http协议",
                  @"",
                  @"",
                  @"",
                  @"",
                  nil];
    
    self.viewControllerArray = [NSMutableArray arrayWithObjects:
                            @"HttpViewController",
                            @"",
                            @"",
                            @"",
                            @"",
                            nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ViewControllerClass = self.viewControllerArray[indexPath.row];
    if (ViewControllerClass.length) {
        
        UIViewController *viewController = [[NSClassFromString(ViewControllerClass) alloc] init];
        viewController.title = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    }
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
