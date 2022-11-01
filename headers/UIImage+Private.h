#import <Foundation/Foundation.h>

@interface UIImage (Private)
+(id)_applicationIconImageForBundleIdentifier:(id)identifier format:(int)format scale:(double)scale;
+ (UIImage*)kitImageNamed:(NSString*)name;
@end