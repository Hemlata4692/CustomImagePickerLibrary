//
//  ImagePicker.h
//  CustomImagePickerController
//
//  Created by Hema on 21/07/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImagePickerDelegate <NSObject>
@required
- (void)loadImages:(NSMutableArray*)assestValue;

@end

@interface ImagePicker : NSObject {
    id <ImagePickerDelegate> _delegate;
}
@property (nonatomic,strong) id delegate;
-(void)uiImagePickerLoader;

@end
