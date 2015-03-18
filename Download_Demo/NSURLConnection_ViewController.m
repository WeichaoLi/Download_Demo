//
//  NSURLConnection.m
//  Download_Demo
//
//  Created by 李伟超 on 15/3/18.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import "NSURLConnection_ViewController.h"

@implementation NSURLConnection_ViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)ClickButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSURL *url = [[NSURL alloc] initWithString:_DownLoadURL.text];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    switch (button.tag) {
        case 0:{
            /**
             *  同步
             */
            NSURLResponse *response;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
            if (data) {
                //文件本地保存
                [self writereceiveDataToFile:data];
                
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"联网失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        }
            break;
        case 1:{
            /**
             *  异步
             */
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [queue setMaxConcurrentOperationCount:1];
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (!connectionError) {
                    if (!data) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"联网失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                        return;
                    }
                    
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
                        //文件本地保存
                        [self writereceiveDataToFile:data];
                    });
                }
            }];
        }
        break;
        default:
            break;
    }
}

- (void)writereceiveDataToFile:(NSData *)data {
    assert(data != nil);
    
//    NSString *filePath = [[NSArray arrayWithObjects:NSHomeDirectory(), @"Documents", @"DownLoad", nil] componentsJoinedByString:@"/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [fileManager displayNameAtPath:_DownLoadURL.text];
    
    if (fileName.length > 50) {
        fileName = @"1001.flv";
    }
    NSString *filePath = _SavePath.text;
    filePath = [filePath stringByAppendingFormat:@"/%@",fileName];
    NSLog(@"%@\n\n",filePath);
    
    if ([data writeToFile:filePath atomically:YES]) {
        NSLog(@"保存成功");
    }
    
}

@end
