#import "../headers/HeadersTweak.h"

@implementation Velvet2PrefsManager

static void sendUpdateNotification() {
    // Send the notification to our hooks
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.noisyflake.velvet2/updateStyle" object:nil];
}

+ (instancetype)sharedInstance {
    static Velvet2PrefsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Velvet2PrefsManager alloc] initWithSuiteName:@"com.noisyflake.velvet2"];
    });
    return sharedInstance;
}

- (instancetype)initWithSuiteName:(NSString *)suitename {
    Velvet2PrefsManager *prefs = [super initWithSuiteName:suitename];

    [prefs registerDefaults:@{
        @"enabled": @YES,
        @"cornerRadiusEnabled": @NO,
        @"cornerRadiusCustom": @19,
        @"backgroundType": @"icon",
        @"backgroundIconAlpha": @50,
        @"backgroundGradientDirection": @"right",
        @"borderWidth": @2,
        @"borderType": @"icon",
        @"borderIconAlpha": @100,
        @"borderGradientDirection": @"right"
    }];

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)sendUpdateNotification, CFSTR("com.noisyflake.velvet2/preferenceUpdate"), NULL, CFNotificationSuspensionBehaviorCoalesce);

    return prefs;
}

- (id)settingForKey:(NSString *)key withIdentifier:(NSString *)identifier {
    if (identifier) {
        id result = [self objectForKey:[NSString stringWithFormat:@"%@_%@", key, identifier]];
        if (result) return result;
    }

    return [self objectForKey:key];
}

- (UIColor *)colorForKey:(NSString *)key withIdentifier:(NSString *)identifier {
    NSString *colorString = [self settingForKey:key withIdentifier:identifier];
    return [UIColor colorFromP3String:colorString];
}

- (CGFloat)alphaValueForKey:(NSString *)key withIdentifier:(NSString *)identifier {
    NSString *string = [self settingForKey:key withIdentifier:identifier];
    return [string floatValue] / 100;
}
@end