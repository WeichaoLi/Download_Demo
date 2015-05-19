//
//  NSURLConnection.h
//  Download_Demo
//
//  Created by 李伟超 on 15/3/18.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import "BasicViewController.h"

@interface NSURLConnection_ViewController : BasicViewController<NSURLConnectionDataDelegate, NSStreamDelegate, NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *DownLoadURL;
@property (weak, nonatomic) IBOutlet UILabel *SavePath;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSFileHandle *fileHandle;

@property (nonatomic, retain) NSOperationQueue *queue;

- (IBAction)beginDownload:(id)sender;
@end
