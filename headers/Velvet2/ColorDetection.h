#import <TargetConditionals.h>
#import <UIKit/UIKit.h>

// Local maxima as found during the image analysis. We need this class for ordering by cell hit count.
@interface CCLocalMaximum : NSObject

// Hit count of the cell
@property (assign, nonatomic) unsigned int hitCount;

// Linear index of the cell
@property (assign, nonatomic) unsigned int cellIndex;

// Average color of cell
@property (assign, nonatomic) double red;
@property (assign, nonatomic) double green;
@property (assign, nonatomic) double blue;

// Maximum color component value of average color 
@property (assign, nonatomic) double brightness;

@end

// Flags that determine how the colors are extract
typedef enum CCFlags: NSUInteger
{
    // This ignores all pixels that are darker than a threshold
    CCOnlyBrightColors   = 1 << 0,

    // This ignores all pixels that are brighter than a threshold
    CCOnlyDarkColors     = 1 << 1,

    // This filters the result array so that only distinct colors are returned
    CCOnlyDistinctColors = 1 << 2,
    
    // This orders the result array by color brightness (first color has highest brightness). If not set,
    // colors are ordered by frequency (first color is "most frequent").
    CCOrderByBrightness  = 1 << 3,
    
    // This orders the result array by color darkness (first color has lowest brightness). If not set,
    // colors are ordered by frequency (first color is "most frequent").
    CCOrderByDarkness    = 1 << 4,

    // Removes colors from the result if they are too close to white
    CCAvoidWhite         = 1 << 5,
    
    // Removes colors from the result if they are too close to black
    CCAvoidBlack         = 1 << 6
    
} CCFlags;

// The color cube is made out of these cells
typedef struct CCCubeCell {
    
    // Count of hits (dividing the accumulators by this value gives the average)
    unsigned int hitCount;

    // Accumulators for color components
    double redAcc;
    double greenAcc;
    double blueAcc;
    
} CCCubeCell;

// This class implements a simple method to extract the most dominant colors of an image.
// How it does it: It projects all pixels of the image into a three dimensional grid (the "cube"),
// then finds local maximas in that grid and returns the average colors of these "maximum cells"
// ordered by their hit count (kind of "color frequency").
// You should call these methods on a background thread. Depending on the image size they can take
// some time.
@interface CCColorCube : NSObject

// Extracts and returns dominant colors of the image (the array contains UIColor objects). Result might be empty.
- (NSArray <UIColor *> * _Nullable )extractColorsFromImage:(UIImage * _Nonnull)image flags:(CCFlags)flags;

// Same as above but avoids colors too close to the specified one.
// IMPORTANT: The avoidColor must be in RGB, so create it with colorWithRed method of UIColor!
- (NSArray <UIColor *> * _Nullable )extractColorsFromImage:(UIImage * _Nonnull)image flags:(CCFlags)flags avoidColor:(UIColor * _Nonnull)avoidColor;

// Tries to get count bright colors from the image, avoiding the specified one (only if avoidColor is non-nil).
// IMPORTANT: The avoidColor (if set) must be in RGB, so create it with colorWithRed method of UIColor!
// Might return less than count colors! 
- (NSArray <UIColor *> * _Nullable )extractBrightColorsFromImage:(UIImage * _Nonnull)image avoidColor:(UIColor * _Nonnull)avoidColor count:(NSUInteger)count;

// Tries to get count dark colors from the image, avoiding the specified one (only if avoidColor is non-nil).
// IMPORTANT: The avoidColor (if set) must be in RGB, so create it with colorWithRed method of UIColor!
// Might return less than count colors!
- (NSArray <UIColor *> * _Nullable )extractDarkColorsFromImage:(UIImage * _Nonnull)image avoidColor:(UIColor * _Nonnull)avoidColor count:(NSUInteger)count;

// Tries to get count colors from the image
// Might return less than count colors!
- (NSArray <UIColor *> * _Nullable )extractColorsFromImage:(UIImage * _Nonnull)image flags:(CCFlags)flags count:(NSUInteger)count;

@end