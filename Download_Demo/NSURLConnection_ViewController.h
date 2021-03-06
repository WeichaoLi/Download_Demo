//
//  NSURLConnection.h
//  Download_Demo
//
//  Created by 李伟超 on 15/3/18.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import "BasicViewController.h"

@interface NSURLConnection_ViewController : BasicViewController<NSURLConnectionDataDelegate, NSURLConnectionDelegate, NSStreamDelegate>

@property (weak, nonatomic) IBOutlet UITextField *DownLoadURL;
@property (weak, nonatomic) IBOutlet UITextField *SavePath;

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSFileHandle *fileHandle;

@property (nonatomic, retain) NSOperationQueue *queue;

- (IBAction)beginDownload:(id)sender;
@end
