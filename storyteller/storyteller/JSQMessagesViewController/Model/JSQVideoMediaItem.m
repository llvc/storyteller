//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQVideoMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"

#import "UIImage+JSQMessages.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface JSQVideoMediaItem ()

@property (strong, nonatomic) UIImageView *cachedVideoImageView;
- (UIImage*) drawImage:(UIImage*) fgImage inImage:(UIImage*) bgImage atPoint:(CGPoint) point;
@end


@implementation JSQVideoMediaItem

#pragma mark - Initialization

- (instancetype)initWithFileURL:(NSURL *)fileURL isReadyToPlay:(BOOL)isReadyToPlay
{
    self = [super init];
    if (self) {
        _fileURL = [fileURL copy];
        _isReadyToPlay = isReadyToPlay;
        _cachedVideoImageView = nil;
        _photoType = NO;
    }
    return self;
}

- (void)dealloc
{
    _fileURL = nil;
    _cachedVideoImageView = nil;
}

- (void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
    _cachedVideoImageView = nil;
}

#pragma mark - Setters

- (void)setFileURL:(NSURL *)fileURL
{
    _fileURL = [fileURL copy];
    _cachedVideoImageView = nil;
}

- (void)setIsReadyToPlay:(BOOL)isReadyToPlay
{
    _isReadyToPlay = isReadyToPlay;
    _cachedVideoImageView = nil;
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedVideoImageView = nil;
}

#pragma mark - JSQMessageMediaData protocol

- (UIView *)mediaView
{
    if (self.fileURL == nil || !self.isReadyToPlay) {
        return nil;
    }
    
    if (self.cachedVideoImageView == nil) {
        CGSize size = [self mediaViewDisplaySize];
        UIImage *playIcon = [[UIImage jsq_defaultPlayImage] jsq_imageMaskedWithColor:[UIColor lightGrayColor]];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:playIcon];
        imageView.backgroundColor = [UIColor blackColor];
        imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        imageView.contentMode = UIViewContentModeCenter;
        imageView.clipsToBounds = YES;
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            @autoreleasepool {
                CGImageRef iref = [rep fullScreenImage];
                if (iref) {
                    UIImage *image_bg = [UIImage imageWithCGImage:iref];
//                    image_bg = [self imageWithImage:image_bg];
                    
                    //resize image
                    CGRect rect = CGRectMake(0, 0, size.width, size.height+130);
                    
                    UIGraphicsBeginImageContext( rect.size );
                    [image_bg drawInRect:rect];
                    UIImage *resizedPhoto = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    NSData *imageData = UIImagePNGRepresentation(resizedPhoto);
                    image_bg = [UIImage imageWithData:imageData];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        CGPoint drawPosition = CGPointMake(image_bg.size.width/2 - playIcon.size.width/2, image_bg.size.height/2 - playIcon.size.height/2);
                        
                        //overlay playicon on photo
                        UIImage *imageWithPlayIcon = [self drawImage:playIcon inImage:image_bg atPoint:drawPosition];

                        if (!self.photoType) {//draw play icon for video type
                            [imageView setImage:imageWithPlayIcon];
                        } else {
                            [imageView setImage:image_bg];
                        }
                    });
                    iref = nil;
                }
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            NSLog(@"Can't get image - %@",[myerror localizedDescription]);
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:self.fileURL
                       resultBlock:resultblock
                      failureBlock:failureblock];
        
        self.cachedVideoImageView = imageView;
    }
    
    return self.cachedVideoImageView;
}

- (CGSize)mediaViewDisplaySize
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return CGSizeMake(315.0f, 420.0f);
    }
    
    return CGSizeMake(210.0f, 150.0f);
}

- (UIImage*)imageWithImage: (UIImage*) sourceImage
{
    //set image width
    float i_width;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        i_width = 315.0f;
    } else {
        i_width = 200.0f;
    }
    
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*) drawImage:(UIImage*) fgImage inImage:(UIImage*) bgImage atPoint:(CGPoint) point
{
    UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
    [bgImage drawInRect:CGRectMake( 0, 0, bgImage.size.width, bgImage.size.height)];
    [fgImage drawInRect:CGRectMake( point.x, point.y, fgImage.size.width, fgImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (![super isEqual:object]) {
        return NO;
    }
    
    JSQVideoMediaItem *videoItem = (JSQVideoMediaItem *)object;
    
    return [self.fileURL isEqual:videoItem.fileURL]
            && self.isReadyToPlay == videoItem.isReadyToPlay;
}

- (NSUInteger)hash
{
    return super.hash ^ self.fileURL.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: fileURL=%@, isReadyToPlay=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.fileURL, @(self.isReadyToPlay), @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _fileURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fileURL))];
        _isReadyToPlay = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isReadyToPlay))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.fileURL forKey:NSStringFromSelector(@selector(fileURL))];
    [aCoder encodeBool:self.isReadyToPlay forKey:NSStringFromSelector(@selector(isReadyToPlay))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQVideoMediaItem *copy = [[[self class] allocWithZone:zone] initWithFileURL:self.fileURL
                                                                   isReadyToPlay:self.isReadyToPlay];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end
