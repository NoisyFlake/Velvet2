#import <UIKit/UIKit.h>

@interface Velvet2PrefsManager : NSUserDefaults
+ (instancetype)sharedInstance;
- (instancetype)initWithSuiteName:(NSString *)suitename;
- (id)settingForKey:(NSString *)key withIdentifier:(NSString *)identifier;
- (UIColor *)colorForKey:(NSString *)key withIdentifier:(NSString *)identifier;
- (CGFloat)alphaValueForKey:(NSString *)key withIdentifier:(NSString *)identifier;
@end