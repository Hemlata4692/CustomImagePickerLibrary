//
//  ImagePicker.m
//  CustomImagePickerController
//
//  Created by Hema on 21/07/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ImagePicker.h"
#import <AssetsLibrary/AssetsLibrary.h>
@import Photos;

@implementation ImagePicker {
    ALAssetsLibrary *alObjc;
    NSMutableArray *assetsArray;
}

//asset library
-(void)uiImagePickerLoader {
    alObjc = [[ALAssetsLibrary alloc] init];
    assetsArray = [[NSMutableArray alloc] init];
    [alObjc enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                      usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
             if (asset != NULL){
                 //change type for videos
                 if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                     [assetsArray addObject:asset];
                 }
             }
             else{
                 [_delegate loadImages:assetsArray];
             }
         }
          ];
     }
                    failureBlock:^(NSError *error)
     {
         // .. handle error
     }
     ] ;
}
@end
