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

    NSURL *url = [[NSURL alloc] initWithString:_DownLoadURL.text];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    switch (1) {
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
    
    NSString *filePath = _SavePath.text;
    filePath = [filePath stringByAppendingFormat:@"/%@",fileName];
    NSLog(@"%@\n\n",filePath);
    
    if ([data writeToFile:filePath atomically:YES]) {
        NSLog(@"保存成功");
    }
    
}

- (IBAction)beginDownload:(id)sender {
    
    NSURL *url = [[NSURL alloc] initWithString:_DownLoadURL.text];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [urlConnection start];
}

#pragma mark - NSURLConnectionDataDelegate

/*
 - (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;
 - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
 
 - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
 
 - (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request;
 - (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
 totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;
 
 - (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse;
 
 - (void)connectionDidFinishLoading:(NSURLConnection *)connection;
 */

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"1");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    NSLog(@"2");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"END");
}

#pragma mark - NSURLConnectionDelegate

/*
 - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
 - (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
 - (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
 
 // Deprecated authentication delegates.
 - (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
 - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
 - (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
 */

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"11");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}

@end
