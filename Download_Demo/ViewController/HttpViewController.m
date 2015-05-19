//
//  HttpViewController.m
//  Download_Demo
//
//  Created by 李伟超 on 15/3/18.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import "HttpViewController.h"

@implementation HttpViewController

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithObjects:
                      @"NSURLConnection",
                      @"",
                      @"",
                      @"",
                      @"",
                      nil];
    
    self.viewControllerArray = [NSMutableArray arrayWithObjects:
                                @"NSURLConnection_ViewController",
                                @"",
                                @"",
                                @"",
                                @"",
                                nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ViewControllerClass = self.viewControllerArray[indexPath.row];
    if (ViewControllerClass.length) {

        UIStoryboard *mainStroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [mainStroyBoard instantiateViewControllerWithIdentifier:ViewControllerClass];

        viewController.title = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
