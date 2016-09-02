#import "ShareExtensionHandler.h"
#import "ShareViewController.h"
#import <Cordova/CDV.h>
#import <Cordova/CDVPluginResult.h>
#import <PassKit/PassKit.h>

@implementation ShareExtensionHandler

- (NSMutableDictionary* )getDictionaryPkpassItems:(PKPass *)obj  withKeyArray: (NSArray *)keyArray {
		NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
		
		for (NSString *key in keyArray) {
      NSString *value = [NSString stringWithFormat:@"%@", [obj localizedValueForFieldKey:key]];
      
      [result setObject:value forKey:key];
    }
  
  [result setObject:[[obj passURL] absoluteString] forKey:@ "url"];
  NSURL *pkpassUrl = [obj passURL];
  NSData *data = [NSData dataWithContentsOfURL:pkpassUrl];
  
  
		return result;
}


- (void)getJsonDataFromSharedPkpassFile:(CDVInvokedUrlCommand *)command {
		NSUserDefaults *userdata = [[NSUserDefaults alloc] initWithSuiteName:@"group.intime"];
  
		NSArray *keyIdentifiers = [command.arguments objectAtIndex:0];
  
		NSString *jsonString = @"";
		CDVPluginResult* result;
  
		if ([userdata objectForKey:@"pkpassDataFile"] != nil) {
      NSError *error = nil;
      NSLog(@"%@",[userdata dataForKey:@"pkpassDataFile"]);
      NSString *stringObj = [[NSString alloc] initWithData:[userdata dataForKey:@"pkpassDataFile"] encoding:NSUTF8StringEncoding];
      NSLog(@"%@", stringObj);
      PKPass *obj = [[PKPass alloc] initWithData:[userdata dataForKey:@"pkpassDataFile"] error:&error];
      NSMutableDictionary *dic = [self getDictionaryPkpassItems:obj withKeyArray:@[@"message", @"seat", @"barcodes", @"headerFields", @"origin", @"cancel"]];
//      [dic setObject:[userdata stringForKey:@"pkpassFilepath"] forKey:@"pkPassLocalFilePath"];
      
      NSData *data = [userdata dataForKey:@"pkpassData"];
      NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                         options:NSJSONWritingPrettyPrinted
                                                           error:&error];
      
      jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
      result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArrayBuffer:data];
    }
  
		[self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)deletePkpass:(CDVInvokedUrlCommand *)command {
		NSUserDefaults *userdata = [[NSUserDefaults alloc] initWithSuiteName:@"group.intime"];
		[userdata setObject:nil forKey:@"pkpassDataFile"];
}

@end