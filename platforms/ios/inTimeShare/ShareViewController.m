//
//  ShareViewController.m
//  inTimeShare
//
//  Created by Oleg Mac on 7/21/16.
//
//

#import "ShareViewController.h"
#import <PassKit/PassKit.h>
#import "SSZipArchive.h"



@interface ShareViewController ()

@end

@implementation ShareViewController


- (BOOL)isContentValid {
  return YES;
}

- (void)didSelectPost {
  NSUserDefaults *userdata = [[NSUserDefaults alloc] initWithSuiteName:@"group.intime"];
  NSExtensionItem* item = self.extensionContext.inputItems[0];
  NSArray *contents = item.attachments;
  NSItemProvider* itemProvider = contents[0];
  
  //Get pkpass NSData object through NSItemProvider
  //Store results in NSUserDefaults bridge
  [itemProvider loadItemForTypeIdentifier:@"com.apple.pkpass" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
    PKPass* obj = [[PKPass alloc] initWithData:item error:&error];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      // Generate the file path
      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
      NSString *documentsDirectory = [paths objectAtIndex:0];
      NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"myfile.pkpass"];
      NSString *unzipPath = [documentsDirectory stringByAppendingPathComponent:@"pass.json"];
      
      NSData *pobadata=[NSKeyedArchiver archivedDataWithRootObject:obj];
      NSLog(@"%@", pobadata);
      
      // Save it into file system
     
      [userdata setObject:[[obj passURL] absoluteString] forKey:@"stringURL"];
      [userdata setObject:pobadata forKey:@"pkpassData"];
      NSLog(@"%@", dataPath); 
      NSFileManager *fileManager = [NSFileManager defaultManager];
      
      [pobadata writeToFile:dataPath atomically:YES];
      
      NSFileManager *filemanager = [NSFileManager defaultManager];
      if ([filemanager fileExistsAtPath:dataPath]) {
        [SSZipArchive unzipFileAtPath:dataPath toDestination:documentsDirectory];
        if ([filemanager fileExistsAtPath:unzipPath]) {
          NSLog(@"Exists");
        }
      }
    });
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"intime://"]];
    
    //    [self.extensionContext openURL:[NSURL URLWithString:@"intime://"] completionHandler:^(BOOL success) {
    //           NSLog(@"fun=%s after completion. success=%d", __func__, success);
    //         }];
    
    
    //    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    //    NSString *urlString = @"intime://";
    //    NSString * content = [NSString stringWithFormat : @"<head><meta http-equiv='refresh' content='0; URL=%@'></head>", urlString];
    //    [webView loadHTMLString:content baseURL:nil];
    //    [self.view addSubview:webView];
    //    [webView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2.0];
    
    // open url
        NSURL *destinationURL = [NSURL URLWithString:@"intime://"];
    
        // Get "UIApplication" class name through ASCII Character codes.
        NSString *className = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x55, 0x49, 0x41, 0x70, 0x70, 0x6C, 0x69, 0x63, 0x61, 0x74, 0x69, 0x6F, 0x6E} length:13] encoding:NSASCIIStringEncoding];
        if (NSClassFromString(className)) {
          id object = [NSClassFromString(className) performSelector:@selector(sharedApplication)];
          [object performSelector:@selector(openURL:) withObject:destinationURL];
        }
    // open url
    
    [userdata setObject:[[obj passURL] absoluteString] forKey:@"pkpassFile"];
    [userdata setObject:item forKey:@"pkpassDataFile"];
  }];
  
  [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
  return @[];
}

@end