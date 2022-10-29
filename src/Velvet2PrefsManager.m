#import "Headers/Velvet2PrefsManager.h"

@implementation Velvet2PrefsManager

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
        @"backgroundType": @"default",
    }];

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
    return [UIColor colorWithCIColor:[CIColor colorWithString:colorString]];
}

@end