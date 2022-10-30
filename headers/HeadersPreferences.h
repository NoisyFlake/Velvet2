#import <Foundation/Foundation.h>
#import <Preferences/PSSpecifier.h>
#import <AudioToolbox/AudioServices.h>

#import "CoreServices.h"
#import "Log.h"
#import "MaterialKit.h"
#import "NSTask.h"
#import "Preferences.h"
#import "QuartzCore.h"
#import "UIImage+Private.h"
#import "UIView+Private.h"
#import "UIViewController+Private.h"
#import "Velvet2/ColorDetection.h"
#import "Velvet2/UIColor+Velvet.h"
#import "Velvet2/Velvet2Colorizer.h"
#import "Velvet2/Velvet2ColorPicker.h"
#import "Velvet2/Velvet2LinkCell.h"
#import "Velvet2/Velvet2PrefsManager.h"
#import "Velvet2/Velvet2RootListController.h"
#import "Velvet2/Velvet2SettingsController.h"
#import "Velvet2/Velvet2Slider.h"
#import "Velvet2/Velvet2Switch.h"

#define kVelvetColor [UIColor colorWithRed: 0.46 green: 0.83 blue: 1.00 alpha: 1.00]