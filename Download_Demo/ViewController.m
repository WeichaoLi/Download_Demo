//
//  ViewController.m
//  Download_Demo
//
//  Created by 李伟超 on 15/3/18.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *viewControllerArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"下载";
    
    _dataArray = [NSMutableArray arrayWithObjects:
                  @"http协议",
                  @"",
                  @"",
                  @"",
                  @"",
                  nil];
    
    _viewControllerArray = [NSMutableArray arrayWithObjects:
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    
//    static BOOL nibRegister = NO;
//    if (!nibRegister) {
//        UINib *nib = [UINib nibWithNibName:@"CustomTableViewCell" bundle:nil];
//        [tableView registerNib:nib forCellReuseIdentifier:identifier];
//        nibRegister = YES;
//    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ViewControllerClass = _viewControllerArray[indexPath.row];
    if (ViewControllerClass.length) {
        
        UIStoryboard *mainStroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [mainStroyBoard instantiateViewControllerWithIdentifier:ViewControllerClass];
        
//        UIViewController *viewController = [[NSClassFromString(ViewControllerClass) alloc] init];
        
        viewController.title = _dataArray[indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end

