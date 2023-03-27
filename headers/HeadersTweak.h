#import <UIKit/UIKit.h>

#import "Log.h"
#import "MaterialKit.h"
#import "PlatterKit.h"
#import "QuartzCore.h"
#import "UserNotificationsKit.h"
#import "UserNotificationsUIKit.h"
#import "Velvet2/ColorDetection.h"
#import "Velvet2/UIColor+Velvet.h"
#import "Velvet2/Velvet2Colorizer.h"
#import "Velvet2/Velvet2PrefsManager.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)