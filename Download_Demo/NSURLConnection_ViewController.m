//
//  NSURLConnection.m
//  Download_Demo
//
//  Created by 李伟超 on 15/3/18.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import "NSURLConnection_ViewController.h"

#define DOWNLOAD_URL        @"http://192.168.16.91:8888/jdk.zip"
#define SAVE_DIRECTION      @"/Users/liweichao/Documents/Download"
#define SAVE_PATH           [self getPath]

@implementation NSURLConnection_ViewController {
    long long totalBytes;
    NSMutableData *TotalData;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)ClickButton:(id)sender {

    NSURL *url = [[NSURL alloc] initWithString:DOWNLOAD_URL];
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

- (NSMutableData *)getDataFromPath:(NSString *)path {
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:path];
    NSLog(@"%@",SAVE_PATH);
    NSLog(@"%lu",(unsigned long)data.length);
    if (!data) {
        data = [NSMutableData data];
    }
    return data;
}

- (NSString *)getPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [fileManager displayNameAtPath:DOWNLOAD_URL];
    
    NSString *filePath = SAVE_DIRECTION;
    filePath = [filePath stringByAppendingFormat:@"/%@",fileName];
    
    return filePath;
}

- (void)writereceiveDataToFile:(NSData *)data {
    assert(data != nil);
    
    if ([data writeToFile:SAVE_PATH atomically:YES]) {
        NSLog(@"保存成功");
    }
    
}

- (IBAction)beginDownload:(id)sender {
    if ([[NSFileManager defaultManager] fileExistsAtPath:SAVE_PATH]) {
        NSLog(@"文件已存在");
        return;
    }
//    NSURL *url = [[NSURL alloc] initWithString:DOWNLOAD_URL];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"GET"];
//    
//    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
//    
//    [urlConnection start];
    
    NSString *paramURLAsString= DOWNLOAD_URL;
    if ([paramURLAsString length] == 0){
        NSLog(@"Nil or empty URL is given");
        return;
    }
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    /* 设置缓存的大小为1M*/
    [urlCache setMemoryCapacity:10*1024*1024];
    //创建一个nsurl
    NSURL *url = [NSURL URLWithString:paramURLAsString];
    //创建一个请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0f];
    //从请求中获取缓存输出
    NSCachedURLResponse *response = [urlCache cachedResponseForRequest:request];
    //判断是否有缓存
    if (response != nil){
        NSLog(@"如果有缓存输出，从缓存中获取数据");
        [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
    }
    self.connection = [[NSURLConnection alloc] initWithRequest:request
                                                      delegate:self
                                              startImmediately:YES];
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
    NSLog(@"%lld",response.expectedContentLength);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    NSLog(@"2");
//    @autoreleasepool {
//        TotalData = [self getDataFromPath:SAVE_PATH];
//        [TotalData appendData:data];
//        [self writereceiveDataToFile:TotalData];
//        TotalData = nil;
//    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    NSLog(@"3");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    NSLog(@"4");
    return cachedResponse;
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
