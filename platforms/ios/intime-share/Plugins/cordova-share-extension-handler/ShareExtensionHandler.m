#import "ShareExtensionHandler.h"
#import "ShareViewController.h"
#import <Cordova/CDV.h>
#import <Cordova/CDVPluginResult.h>
#import <PassKit/PassKit.h>

@implementation ShareExtensionHandler

- (void)getJsonDataFromSharedPkpassFile:(CDVInvokedUrlCommand *)command {
		NSUserDefaults *userdata = [[NSUserDefaults alloc] initWithSuiteName:@"group.intime"];
		CDVPluginResult* result;

		if ([userdata stringForKey:@"barcodeMsg"] != nil) {
      NSString *data = [userdata stringForKey:@"barcodeMsg"];
      result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:data];
    }
  
		[self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)deletePkpass:(CDVInvokedUrlCommand *)command {
		NSUserDefaults *userdata = [[NSUserDefaults alloc] initWithSuiteName:@"group.intime"];
		[userdata setObject:nil forKey:@"barcodeMsg"];
}

@end