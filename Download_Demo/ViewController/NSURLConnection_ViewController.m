//
//  NSURLConnection.m
//  Download_Demo
//
//  Created by 李伟超 on 15/3/18.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import "NSURLConnection_ViewController.h"

#define DOWNLOAD_URL_1      @"http://192.168.16.126:8888/ApplicationLoader_3.0.dmg"
#define DOWNLOAD_URL        @"http://192.168.16.126:8888/jdk.zip"
#define SAVE_DIRECTION      @"/Users/liweichao/Documents/Download"
#define SAVE_PATH           [self getPath]
#define SAVE_IN_PATH(path)  [self getPath:path]

@implementation NSURLConnection_ViewController {
    long long totalBytes;
    long long currentBytes;
    NSMutableData *TotalData;
    NSMutableData *readData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _progress.hidden = YES;
    
    self.queue = [[NSOperationQueue alloc] init];
    [_queue setMaxConcurrentOperationCount:1];
    
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadWithURL:) object:DOWNLOAD_URL];
    [_queue addOperation:operation1];

//    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadWithURL:) object:DOWNLOAD_URL_1];
//    [_queue addOperation:operation2];
//    [_queue addOperationWithBlock:^{
//        [self downloadWithURL:DOWNLOAD_URL];
//    }];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"path:%@", path);
    
    
    _DownLoadURL.text = DOWNLOAD_URL;
    _SavePath.text = SAVE_PATH;
}

- (void)downloadWithURL:(NSString *)urlstring {
    NSURL *url = [[NSURL alloc] initWithString:urlstring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10.f];
    [request setHTTPMethod:@"GET"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
    [connection start];
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

- (void)getDataFromPath:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:SAVE_PATH]) {
        return;
    }
    self.inputStream = [[NSInputStream alloc] initWithFileAtPath:path];
    [self.inputStream setDelegate:self];
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream open];
//    NSMutableData *data = [NSMutableData dataWithContentsOfFile:path];
//    
//    NSLog(@"%lu",(unsigned long)data.length);
//    if (!data) {
//        data = [NSMutableData data];
//    }
//    return data;
}

- (NSString *)getPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [fileManager displayNameAtPath:DOWNLOAD_URL];
    
    NSString *filePath = SAVE_DIRECTION;
    filePath = [filePath stringByAppendingFormat:@"/%@",fileName];
    
    return filePath;
}

- (NSString *)getPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [fileManager displayNameAtPath:path];
    
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
    if ([sender tag] == 1) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:SAVE_PATH]) {
            NSLog(@"文件已存在");
            return;
        }
        NSURL *url = [[NSURL alloc] initWithString:DOWNLOAD_URL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:10.f];
        [request setHTTPMethod:@"GET"];
        
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        [_connection start];
        
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        [sender setTag:2];
        
    }else {
        [_connection cancel];
        [sender setTitle:@"继续" forState:UIControlStateNormal];
        [sender setTag:1];
    }
    
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
    NSLog(@"==============================\n\n");
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    totalBytes = response.expectedContentLength;
    [_progress setHidden:NO];
    NSLog(@"\n\n\n开始下载");
    if ([[NSFileManager defaultManager] fileExistsAtPath:SAVE_IN_PATH(connection.currentRequest.URL.path)]) {
        NSLog(@"文件已存在");
    }else {
        [[NSData data] writeToFile:SAVE_IN_PATH(connection.currentRequest.URL.path) atomically:YES];
    }
    _fileHandle = [NSFileHandle fileHandleForWritingAtPath:SAVE_IN_PATH(connection.currentRequest.URL.path)];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

//    [self getDataFromPath:SAVE_PATH];
//    NSLog(@"2");
    currentBytes += data.length;
    [_progress setProgress:(double)currentBytes/(double)totalBytes];
    [_fileHandle writeData:data];
    
//    if (!TotalData) {
//        TotalData = [NSMutableData data];
//    }
//    [TotalData appendData:data];
//    [self writereceiveDataToFile:TotalData];
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
    [_progress setHidden:YES];
    [_fileHandle closeFile];
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

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    return YES;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"11");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"\n\n%@\n\n",error);
    if (error.code == -1001) {
        
    }
}

#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
//    NSLog(@"===================%lu",eventCode);
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable: {
            if (!readData) {
                readData = [NSMutableData data];
            }
            uint8_t buf[1024*1024];
            NSUInteger len = 0;
            len = [(NSInputStream *)aStream read:buf maxLength:1024*1024];
            if (len) {
                [readData appendBytes:(const void*)buf length:len];
                NSLog(@"==========%lu",(unsigned long)readData.length);
            }else {
                NSLog(@"no buffer");
            }
            
            break;
        }
        case NSStreamEventEndEncountered:{
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            aStream = nil;
            break;
        }

        default:
            break;
    }
}

@end
