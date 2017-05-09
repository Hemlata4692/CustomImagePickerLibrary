//
//  PhotoGridViewController.h
//  CustomImagePickerLibrary
//
//  Created by Hema on 08/05/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoGridViewController : ViewController
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@end
