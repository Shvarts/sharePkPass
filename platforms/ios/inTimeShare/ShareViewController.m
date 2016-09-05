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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      // Generate the file path
      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
      NSString *documentsDirectory = [paths objectAtIndex:0];
      NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"myfile.pkpass"];
      
      [((NSData*)item) writeToFile:dataPath atomically:YES];
      
      NSFileManager *filemanager = [NSFileManager defaultManager];
      
      if ([filemanager fileExistsAtPath:dataPath]) {
        [SSZipArchive unzipFileAtPath:dataPath toDestination:documentsDirectory];
        
        NSString *unzipPath = [documentsDirectory stringByAppendingPathComponent:@"pass.json"];
        
        NSString *myJSON = [[NSString alloc] initWithContentsOfFile:unzipPath encoding:NSUTF8StringEncoding error:NULL];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        NSDictionary *barcode = [json objectForKey:@"barcode"];
        [userdata setObject:[barcode objectForKey:@"message"] forKey:@"barcodeMsg"];
      }
    });
    
    // open url
    NSURL *destinationURL = [NSURL URLWithString:@"intime://"];
    
    // Get "UIApplication" class name through ASCII Character codes.
    NSString *className = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x55, 0x49, 0x41, 0x70, 0x70, 0x6C, 0x69, 0x63, 0x61, 0x74, 0x69, 0x6F, 0x6E} length:13] encoding:NSASCIIStringEncoding];
    if (NSClassFromString(className)) {
      id object = [NSClassFromString(className) performSelector:@selector(sharedApplication)];
      [object performSelector:@selector(openURL:) withObject:destinationURL];
    }
    // open url
  }];
  
  [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
  return @[];
}

@end