//
//  BITDeviceHardware.h
//
//  Used to determine EXACT version of device software is running on.

#import <Foundation/Foundation.h>

/*!
 @abstract Convenience for extracting the concrete device name (not only family).
 @discussion Taken from https://github.com/fahrulazmi/UIDeviceHardware.
 */
@interface BITDeviceHardware : NSObject

/*!
 @abstract Returns the platform identifier (e.g. "iPad6,7" for iPad Pro Wifi)
 */
+ (NSString *)platform;

/*!
 @abstract If the platform is known, returns the device type (e.g. "iPad Pro").
 @discussion Defaults to the platform identifier if that one it unknown.
 */
+ (NSString *)platformString;

@end
