//
//  UIImage+MOAdditions.m
//  DejaFashion
//
//  Created by Sun lin on 27/11/14.
//  Copyright (c) 2014 Mozat. All rights reserved.
//

#import "UIImage+MOAdditions.h"
static inline double radians (double degrees) {return degrees * M_PI/180;}

@implementation UIImage (MOAdditions)

/*
 Returns the color of the image pixel at point. Returns nil if point lies outside the image bounds.
 If the point coordinates contain decimal parts, they will be truncated.
 
 To get at the pixel data, this method must draw the image into a bitmap context.
 For minimal memory usage and optimum performance, only the specific requested
 pixel is drawn.
 If you need to query pixel colors for the same image repeatedly (e.g., in a loop),
 this approach is probably less efficient than drawing the entire image into memory
 once and caching it.
 */
- (UIColor *)colorAtPixel:(CGPoint)point
{
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return nil;
    }
    
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    // Reference: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
/*
 - (UIColor*) getPixelColorAtLocation:(CGPoint)point {
 UIColor* color = nil;
 CGImageRef inImage = self.CGImage;
 // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
 CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
 if (cgctx == NULL) { return nil;  }
 
 size_t w = CGImageGetWidth(inImage);
 size_t h = CGImageGetHeight(inImage);
 CGRect rect = {{0,0},{w,h}};
 
 // Draw the image to the bitmap context. Once we draw, the memory
 // allocated for the context for rendering will then contain the
 // raw image data in the specified color space.
 CGContextDrawImage(cgctx, rect, inImage);
 
 // Now we can get a pointer to the image data associated with the bitmap
 // context.
 unsigned char* data = CGBitmapContextGetData (cgctx);
 if (data != NULL) {
 //offset locates the pixel in the data from x,y.
 //4 for 4 bytes of data per pixel, w is width of one row of data.
 @try {
 int offset = 4*((w*round(point.y))+round(point.x));
 NSLog(@"offset: %d", offset);
 int alpha =  data[offset];
 int red = data[offset+1];
 int green = data[offset+2];
 int blue = data[offset+3];
 NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
 color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
 }
 @catch (NSException * e) {
 NSLog(@"%@",[e reason]);
 }
 @finally {
 }
 
 }
 // When finished, release the context
 CGContextRelease(cgctx);
 // Free image data memory for the context
 if (data) { free(data); }
 
 return color;
 }
 */

+ (UIImage *)addTwoImageToOne:(UIImage *)oneImg twoImage:(UIImage *)twoImg topleft:(CGPoint)tlPos
{
    UIGraphicsBeginImageContext(oneImg.size);
    
    [oneImg drawInRect:CGRectMake(0, 0, oneImg.size.width, oneImg.size.height)];
    [twoImg drawInRect:CGRectMake(tlPos.x, tlPos.y, twoImg.size.width, twoImg.size.height)];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImg;
}
/*
 - (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
 
 CGContextRef    context = NULL;
 CGColorSpaceRef colorSpace;
 void *          bitmapData;
 NSInteger             bitmapByteCount;
 NSInteger             bitmapBytesPerRow;
 
 // Get image width, height. We'll use the entire image.
 size_t pixelsWide = CGImageGetWidth(inImage);
 size_t pixelsHigh = CGImageGetHeight(inImage);
 
 // Declare the number of bytes per row. Each pixel in the bitmap in this
 // example is represented by 4 bytes; 8 bits each of red, green, blue, and
 // alpha.
 bitmapBytesPerRow   = (pixelsWide * 4);
 bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
 
 // Use the generic RGB color space.
 colorSpace = CGColorSpaceCreateDeviceRGB();
 
 if (colorSpace == NULL)
 {
 fprintf(stderr, "Error allocating color spacen");
 return NULL;
 }
 
 // Allocate memory for image data. This is the destination in memory
 // where any drawing to the bitmap context will be rendered.
 bitmapData = malloc( bitmapByteCount );
 if (bitmapData == NULL)
 {
 fprintf (stderr, "Memory not allocated!");
 CGColorSpaceRelease( colorSpace );
 return NULL;
 }
 
 // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
 // per component. Regardless of what the source image format is
 // (CMYK, Grayscale, and so on) it will be converted over to the format
 // specified here by CGBitmapContextCreate.
 context = CGBitmapContextCreate (bitmapData,
 pixelsWide,
 pixelsHigh,
 8,      // bits per component
 bitmapBytesPerRow,
 colorSpace,
 kCGImageAlphaPremultipliedFirst);
 if (context == NULL)
 {
 free (bitmapData);
 fprintf (stderr, "Context not created!");
 }
 // Make sure and release colorspace before returning
 CGColorSpaceRelease( colorSpace );
 
 return context;
 }
 */

+ (UIImage *)resizeImageRetina:(UIImage *)inputImage size:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1);
    [inputImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

+ (UIImage *)rotateImage:(UIImage *)inputImage rotate:(float)degree{
//    UIGraphicsBeginImageContextWithOptions(inputImage.size, NO, 1);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM (context, 0, inputImage.size.height);
//    CGContextRotateCTM(context, radians(degree));
//    [inputImage drawAtPoint:CGPointZero];
//    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return outputImage;
//    
    CGImageRef imageRef = [inputImage CGImage];
    CGContextRef bitmap;
    bitmap = CGBitmapContextCreate(NULL, inputImage.size.height, inputImage.size.width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef));
    
    CGContextRotateCTM (bitmap, radians(degree));
    CGContextTranslateCTM (bitmap, 0, -inputImage.size.height);
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, inputImage.size.height, inputImage.size.width), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    return [UIImage imageWithCGImage:ref];
}

+(UIImage *)correctCameraImage:(UIImage *)inputImage{
    CGImageRef imgRef = inputImage.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = inputImage.imageOrientation;
    
    switch(orient) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)imageFileNamed:(NSString *)filename
{
    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageFile];
    return image;
}

+ (NSString *)si_splashImageNameForOrientation:(UIDeviceOrientation)orientation
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    
    NSString *viewOrientation = @"Portrait";
    
    if (UIDeviceOrientationIsLandscape(orientation))
    {
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
        viewOrientation = @"Landscape";
    }
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for (NSDictionary *dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
            return dict[@"UILaunchImageName"];
    }
    return nil;
}

+ (UIImage*)si_splashImageForOrientation:(UIDeviceOrientation)orientation
{
    NSString *imageName = [self si_splashImageNameForOrientation:orientation];
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}


@end

