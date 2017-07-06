/**
 * @brief  controls the scan screen user interface.
 *
 *
 * The overlay controller can be used to configure various scan screen UI elements such as
 * search bar, toolbar, torch, camera switch icon, scandit logo and the viewfinder.
 *
 * Developers can inherit from the ScanditSDKOverlayController to implement their own
 * scan screen user interfaces.
 *
 * @since 1.0.0
 *
 *  Copyright 2010 Mirasense AG. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "AudioToolbox/AudioServices.h"
#import "ScanditSDKBarcodePicker.h"


@class ScanditSDKOverlayController;

/**
 * @brief protocol to handle barcode scan, cancel and manual search events.
 * @ingroup scanditsdk-ios-api
 * @since 1.0.0
 */
@protocol ScanditSDKOverlayControllerDelegate
/**
 * @brief Is called when a barcode is successfully decoded.
 *
 * The dictionary contains two key-value pairs.
 *
 * key: "barcode"
 * value: barcode data decoded (as UTF8 encoded NSString)
 *
 * key: "symbology"
 * value: the symbology of the barcode decoded. The following barcode symbology identifiers are returned:
 *
 * "EAN8", "EAN13", "UPC12", "UPCE", "CODE128", "GS1-128", "CODE39", "CODE93", "ITF", "MSI",
 * "CODABAR", "GS1-DATABAR", "GS1-DATABAR-EXPANDED", "QR", "GS1-QR", "DATAMATRIX", "GS1-DATAMATRIX", 
 * "PDF417"
 *
 * @since 1.0.0
 *
 * @param overlayController ScanditSDKOverlayController that is delegating
 * @param barcode dictionary with two key value pairs ("barcode","symbology")
 *
 */
- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)overlayController
                     didScanBarcode:(NSDictionary *)barcode;

/**
 * @brief Is called when the user clicks the cancel button in the scan user interface
 *
 * @since 1.0.0
 *
 * @param overlayController ScanditSDKOverlayController that is delegating
 * @param status dictionary (currently empty)
 *
 */
- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)overlayController
                didCancelWithStatus:(NSDictionary *)status;

/**
 * @brief Is called when the search bar is shown and the user enters a search term manually.
 *
 * @since 1.0.0
 *
 * @param overlayController ScanditSDKOverlayController that is delegating
 * @param text manual search input encoded as an NSString
 */
- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)overlayController
                    didManualSearch:(NSString *)text;
@end

/**
 * Enumeration of different camera switch options.
 *
 * @since 3.0.0
 */
typedef enum {
	CAMERA_SWITCH_NEVER,
	CAMERA_SWITCH_ON_TABLET,
	CAMERA_SWITCH_ALWAYS
	
} CameraSwitchVisibility;


/**
 * @brief  controls the scan screen user interface.
 *
 * The overlay controller can be used to configure various scan screen UI elements such as
 * search bar, toolbar, torch, camera switch icon, scandit logo and the viewfinder.
 *
 * Developers can inherit from the ScanditSDKOverlayController to implement their own
 * scan screen user interfaces.
 *
 * @ingroup scanditsdk-ios-api
 *
 * @since 1.0.0
 *
 * \nosubgrouping
 *
 *  Copyright 2010 Mirasense AG. All rights reserved.
 */
@interface ScanditSDKOverlayController : UIViewController <UISearchBarDelegate> {
	id<ScanditSDKOverlayControllerDelegate> delegate;
	
    UISearchBar *searchBar;
    UIToolbar *toolBar;
	
}

/**
 * @brief The overlay controller delegate that handles callbacks such as didScanBarcode or
 * didCancelWithStatus.
 *
 * @since 1.0.0
 *
 */
@property (nonatomic, assign) id<ScanditSDKOverlayControllerDelegate> delegate;

/**
 * @brief The manual search bar that can be shown at the top of the scan sreen.
 *
 * @since 1.0.0
 *
 */
@property (nonatomic, retain) UISearchBar *manualSearchBar;

/**
 * @brief The tool bar that can be shown at the bottom of the scan screen.
 *
 * @since 1.0.0
 *
 */
@property (nonatomic, retain) UIToolbar *toolBar;


/** @name Sound Configuration
 *  Customize the scan sound.
 */
///@{

/**
 * @brief Enables (or disables) the sound when a barcode is recognized. If the phone's ring mode
 * is set to muted or vibrate, no beep will be played regardless of the value.
 *
 * Enabled by default.
 *
 * @since 1.0.0
 *
 * @param enabled Whether the beep is enabled.
 */
- (void)setBeepEnabled:(BOOL)enabled;

/**
 * @brief Enables or disables the vibration when a code was recognized. If the phone's ring mode
 * is set to muted, no beep will be played regardless of the value.
 *
 * Enabled by default.
 *
 * @since 1.0.0
 *
 * @param enabled Whether vibrate is enabled.
 */
- (void)setVibrateEnabled:(BOOL)enabled;

/**
 * @brief Sets the audio sound played when a code has been successfully recognized.
 *
 * File needs to be placed in Resources folder.
 *
 * Note: This feature is only available with the
 * Scandit SDK Enterprise Packages.
 *
 * The default is: "beep.wav"
 *
 * @since 2.0.0
 *
 * @param path The file name of the sound file (without suffix).
 * @param extension The file type.
 * @return Whether the change was successful.
 */
- (BOOL)setScanSoundResource:(NSString *)path ofType:(NSString *)extension;
///@}


/** @name Torch Configuration
 *  Enable and customize appearance of the torch icon.
 */
///@{

/**
 * @brief Enables or disables the torch toggle button for all devices/cameras that support a torch.
 *
 * By default it is enabled. The torch icon is never shown when the camera does not have a
 * torch (most tablets, front cameras, etc).
 *
 * @since 2.0.0
 *
 * @param enabled Whether the torch button should be shown.
 */
- (void)setTorchEnabled:(BOOL)enabled;

/**
 * @deprecated Use #setTorchOnImageResource:pressedResource:ofType: instead.
 *
 * @brief Sets the image which is being drawn when the torch is on.
 *
 * If you want this to be displayed in proper resolution on high resolution screens, you need to 
 * also provide a resource with the same name but @2x appended and in higher resolution (like 
 * flashlight-turn-on-icon@2x.png).
 *
 * File needs to be placed in Resources folder.
 *
 * By default this is: "flashlight-turn-on-icon.png"
 *
 * @since 2.0.0
 *
 * @param fileName The file name for when the torch is on (without suffix).
 * @param extension The file type.
 * @return Whether the change was successful.
 */
- (BOOL)setTorchOnImageResource:(NSString *)fileName
                         ofType:(NSString *)extension;

/**
 * @brief Sets the images which are being drawn when the torch is on.
 *
 * If you want this to be displayed in proper resolution on high resolution screens, you need to
 * also provide a resource with the same name but @2x appended and in higher resolution (like
 * flashlight-turn-on-icon@2x.png).
 *
 * File needs to be placed in Resources folder.
 *
 * By default this is: "flashlight-turn-on-icon.png" and "flashlight-turn-on-icon-pressed.png"
 *
 * @since 2.0.0
 *
 * @param fileName The file name for when the torch is on (without suffix).
 * @param pressedFileName The file name for when the torch is on and it is pressed (without suffix).
 * @param extension The file type.
 * @return Whether the change was successful.
 */
- (BOOL)setTorchOnImageResource:(NSString *)fileName
                pressedResource:(NSString *)pressedFileName
                         ofType:(NSString *)extension;

/**
 * @deprecated Use #setTorchOffImageResource:pressedResource:ofType: instead.
 
 * @brief Sets the image which is being drawn when the torch is off.
 *
 * If you want this to be displayed in proper resolution on high resolution screens, you need to
 * also provide a resource with the same name but @2x appended and in higher resolution (like
 * flashlight-turn-on-icon@2x.png).
 *
 * File needs to be placed in Resources folder.
 *
 * By default this is: "flashlight-turn-off-icon.png"
 *
 * @since 2.0.0
 *
 * @param fileName The file name for when the torch is off (without suffix).
 * @param extension The file type.
 * @return Whether the change was successful.
 */
- (BOOL)setTorchOffImageResource:(NSString *)fileName
                          ofType:(NSString *)extension;

/**
 * @brief Sets the images which are being when the torch is off.
 *
 * If you want this to be displayed in proper resolution on high resolution screens, you need to
 * also provide a resource with the same name but @2x appended and in higher resolution (like
 * flashlight-turn-on-icon@2x.png).
 *
 * By default this is: "flashlight-turn-off-icon.png" and "flashlight-turn-off-icon-pressed.png"
 *
 * @since 2.0.0
 *
 * @param fileName The file name for when the torch is off (without suffix).
 * @param pressedFileName The file name for when the torch is off and it is pressed (without suffix).
 * @param extension The file type.
 * @return Whether the change was successful.
 */
- (BOOL)setTorchOffImageResource:(NSString *)fileName
                 pressedResource:(NSString *)pressedFileName
                          ofType:(NSString *)extension;

/**
 * @brief Sets the position at which the button to enable the torch is drawn.
 *
 * The X and Y coordinates are relative to the screen size, which means they have to be between 
 * 0 and 1.
 *
 * By default this is set to x = 0.05, y = 0.01, width = 67, height = 33.
 *
 * @since 2.0.0
 *
 * @param x Relative x coordinate.
 * @param y Relative y coordinate.
 * @param width Width in pixels.
 * @param height Height in pixels.
 */
- (void)setTorchButtonRelativeX:(float)x relativeY:(float)y width:(float)width height:(float)height;
///@}


/** @name Camera Switch Configuration
 *  Enable camera switch and set icons
 */
///@{

/**
 * @brief Sets when the camera switch button is visible for devices that have more than one camera.
 *
 * By default it is CameraSwitchVisibility#CAMERA_SWITCH_NEVER.
 *
 * @since 3.0.0
 *
 * @param visibility The visibility of the camera switch button
 *                   (CameraSwitchVisibility#CAMERA_SWITCH_NEVER,
 *                   CameraSwitchVisibility#CAMERA_SWITCH_ON_TABLET,
 *                   CameraSwitchVisibility#CAMERA_SWITCH_ALWAYS)
 */
- (void)setCameraSwitchVisibility:(CameraSwitchVisibility)visibility;

/**
 * @brief Sets the image which is being drawn when the camera switch button is visible.
 *
 * If you want this to be displayed in proper resolution on high resolution screens, you need to
 * also provide a resource with the same name but @2x appended and in higher resolution (like
 * flashlight-turn-on-icon@2x.png).
 *
 * File needs to be placed in Resources folder.
 *
 * By default this is: "camera-swap-icon.png"
 *
 * @since 3.0.0
 *
 * @param fileName The file name of the camera swap button's image (without suffix).
 * @param extension The file type.
 * @return Whether the change was successful.
 */
- (BOOL)setCameraSwitchImageResource:(NSString *)fileName
                              ofType:(NSString *)extension;

/**
 * @brief Sets the images which are being drawn when the camera switch button is visible.
 *
 * If you want this to be displayed in proper resolution on high resolution screens, you need to
 * also provide a resource with the same name but @2x appended and in higher resolution (like
 * flashlight-turn-on-icon@2x.png).
 *
 * File needs to be placed in Resources folder.
 *
 * By default this is: "camera-swap-icon.png" and "camera-swap-icon-pressed.png"
 *
 * @since 3.0.0
 *
 * @param fileName The file name of the camera swap button's image (without suffix).
 * @param pressedFileNameThe file name of the camera swap button's image when pressed (without suffix).
 * @param extension The file type.
 * @return Whether the change was successful.
 */
- (BOOL)setCameraSwitchImageResource:(NSString *)fileName
                     pressedResource:(NSString *)pressedFileName
                              ofType:(NSString *)extension;

/**
 * @brief Sets the position at which the button to switch the camera is drawn.
 *
 * The X and Y coordinates are relative to the screen size, which means they have to be between 
 * 0 and 1. Be aware that the x coordinate is calculated from the right side of the screen and not 
 * the left like with the torch button.
 *
 * By default this is set to x = 0.05, y = 0.01, width = 67 and height = 33.
 *
 * @since 3.0.0
 *
 * @param x Relative x coordinate (from the right screen edge).
 * @param y Relative y coordinate.
 * @param width Width in pixels.
 * @param height Height in pixels.
 */
- (void)setCameraSwitchButtonRelativeInverseX:(float)x
									relativeY:(float)y
										width:(float)width
									   height:(float)height;
///@}

/** @name Viewfinder Configuration
 *  Customize the viewfinder where the barcode location is highlighted.
 */
///@{

/**
 * @brief Shows/hides viewfinder rectangle and highlighted barcode location in the scan screen UI.
 *
 * Note: This feature is only available with the Scandit SDK Enterprise Packages.
 *
 * By default this is enabled.
 *
 * @since 1.0.0
 *
 * @param draw Whether the viewfinder rectangle should be drawn.
 */
- (void)drawViewfinder:(BOOL)draw;

/**
 * @deprecated  Replaced by #setViewfinderHeight:width:landscapeHeight:landscapeWidth:
 *              If you are using a rotating BarcodePicker, migrate to the new function if possible
 *              since it will allow you to properly adjust the viewfinder for each screen dimension
 *              individually.
 *
 * @brief Deprecated: Sets the size of the viewfinder relative to the size of the screen size.
 *
 * Changing this value does not(!) affect the area in which barcodes are successfully recognized.
 * It only changes the size of the box drawn onto the scan screen.
 *
 * By default the width is 0.6 and the height is 0.25
 *
 * @param h Height of the viewfinder rectangle.
 * @param w Width of the viewfinder rectangle.
 */
- (void)setViewfinderHeight:(float)h width:(float)w;

/**
 * @brief Sets the size of the viewfinder relative to the size of the screen size.
 *
 * Changing this value does not(!) affect the area in which barcodes are successfully recognized.
 * It only changes the size of the box drawn onto the scan screen. To restrict the active scanning area,
 * use the methods listed below.
 *
 * @see ScanditSDKBarcodePicker#restrictActiveScanningArea:
 * @see ScanditSDKBarcodePicker#setScanningHotSpotToX:andY:
 * @see ScanditSDKBarcodePicker#setScanningHotSpotHeight:
 *
 * By default the width is 0.8, height is 0.4, landscapeWidth is 0.6, landscapeHeight is 0.4
 *
 * @since 3.0.0
 *
 * @param h Height of the viewfinder rectangle in portrait orientation.
 * @param w Width of the viewfinder rectangle in portrait orientation.
 * @param lH Height of the viewfinder rectangle in landscape orientation.
 * @param lW Width of the viewfinder rectangle in landscape orientation.
 */
- (void)setViewfinderHeight:(float)h
                      width:(float)w
            landscapeHeight:(float)lH
             landscapeWidth:(float)lW;

/**
 * @brief Sets the color of the viewfinder before a bar code has been recognized
 *
 * Note: This feature is only available with the Scandit SDK Enterprise Packages.
 *
 * By default this is: white (1.0, 1.0, 1.0)
 *
 * @since 1.0.0
 *
 * @param r Red component (between 0.0 and 1.0).
 * @param g Green component (between 0.0 and 1.0).
 * @param b Blue component (between 0.0 and 1.0).
 */
- (void)setViewfinderColor:(float)r green:(float)g blue:(float)b;

/**
 * @brief Sets the color of the viewfinder once the bar code has been recognized.
 *
 * Note: This feature is only available with the Scandit SDK Enterprise Packages.
 *
 * By default this is: light blue (0.222, 0.753, 0.8)
 *
 * @since 1.0.0
 *
 * @param r Red component (between 0.0 and 1.0).
 * @param g Green component (between 0.0 and 1.0).
 * @param b Blue component (between 0.0 and 1.0).
 */
- (void)setViewfinderDecodedColor:(float)r green:(float)g blue:(float)b;

/**
 * @brief Sets the text that will be displayed on ipod4 when camera is initialized.
 *
 * By default this is: "Initializing camera..."
 *
 * @since 1.0.0
 *
 * @param text string shown when camera is initialized on an ipod4
 */
- (void)setTextForInitializingCamera:(NSString *)text;

/**
 * @brief Resets the scan screen user interface to its initial state.
 *
 * This resets any information in the search bar and resets the animation showing the barcode
 * locations to its initial state.
 *
 * @since 1.0.0
 */
- (void)resetUI;
///@}


/** @name Logo Configuration
 *  Customize the scanning by Scandit logo - Note that including the logo in the UI is mandatory.
 */
///@{

/**
 * @brief Sets the x and y offset at which the scanning by Scandit logo is drawn for both portrait and landscape
 * orientation.
 *
 * Please note that the standard Scandit SDK license do not allow you to hide the logo.
 *
 * By default this is set to xOffset = 0, yOffset = 0, landscapeXOffset = 0, landscapeYOffset = 0.
 *
 * @since 2.0.0
 *
 * @param xOffset x offset in pixels in portrait mode
 * @param yOffset y offset in pixels in portrait mode
 * @param landscapeXOffset x offset in pixels in landscape mode
 * @param landscapeYOffset y offset in pixels in landscape mode
 *
 */
- (void)setLogoXOffset:(int)xOffset
			   yOffset:(int)yOffset
	  landscapeXOffset:(int)landscapeXOffset
	  landscapeYOffset:(int)landscapeYOffset;

/**
 * @deprecated:  This function was replaced by setLogoXOffset:yOffset: in Scandit SDK 3.*
 *
 * @brief Deprecated: Sets the y offset at which the Scandit logo should be drawn.
 *
 * Please note that the standard Scandit SDK licenses do not allow you to hide the logo. Do not
 * use this method to hide the poweredby logo.
 *
 * @since 2.0.0
 *
 * @param offset vertical offset in pixels by which logo should be moved
 *
 * By default this is: 0
 */
- (void)setInfoBannerOffset:(int)offset;

/**
 * @brief Sets the "scanning by Scandit" image which is being drawn at the bottom of the scan screen.
 *
 * Use this method to show an alternative scanning by Scandit logo provided for your application
 * by the Scandit team. Do not use this method without consulting with the Scandit team.
 *
 * Note: This feature is only available with the
 * Scandit SDK Enterprise Packages.
 *
 * By default this is: "poweredby.png"
 *
 * @param fileName of poweredby logo (without suffix)
 * @param extension file type
 * @return boolean indicating whether the change was successful.
 */
- (BOOL)setBannerImageWithResource:(NSString *)fileName ofType:(NSString *)extension;
///@}


/** @name Toolbar Configuration
 *  Customize toolbar appearance
 */
///@{

/**
 * @brief Adds (or removes) a tool bar to/from the bottom of the scan screen.
 *
 * @since 1.0.0
 *
 * @param show boolean indicating whether toolbar should be shown.
 */
- (void)showToolBar:(BOOL)show;

/**
 * @brief Sets the caption of the toolbar button.
 *
 * By default this is: "Cancel"
 *
 * @since 1.0.0
 *
 * @param caption string used for cancel button caption
 */
- (void)setToolBarButtonCaption:(NSString *)caption;
///@}


/** @name Searchbar Configuration
 *  Customize searchbar appearance
 */
///@{

/**
 * @brief Shows (or hides) a search bar at the top of the scan screen.
 *
 * @since 1.0.0
 *
 * @param show Whether the search bar should be visible.
 */
- (void)showSearchBar:(BOOL)show;

/**
 * @brief Sets the caption of the search button at the top of the numerical keyboard.
 *
 * By default this is: "Go"
 *
 * @since 1.0.0
 *
 * @param caption Caption of the search button.
 */
- (void)setSearchBarActionButtonCaption:(NSString *)caption;

/**
 * @deprecated This method serves no purpose any more under iOS 7+ and is deprecated.
 *
 * @brief Sets the caption of the manual entry at the top.
 *
 * By default this is: "Cancel"
 *
 * @since 1.0.0
 *
 * @param caption Caption of the cancel button.
 */
- (void)setSearchBarCancelButtonCaption:(NSString *)caption;

/**
 * @brief Sets the text shown in the manual entry field when nothing has been entered yet.
 *
 * By default this is: "Scan barcode or enter it here"
 *
 * @since 1.0.0
 *
 * @param text A placeholder text shown when the search bar is empty.
 */
- (void)setSearchBarPlaceholderText:(NSString *)text;

/**
 * @brief Sets the type of keyboard that is shown to enter characters into the search bar.
 *
 * By default this is: UIKeyboardTypeNumberPad
 *
 * @since 1.0.0
 *
 * @param keyboardType Type of keyboard that is shown when user uses search bar.
 */
- (void)setSearchBarKeyboardType:(UIKeyboardType)keyboardType;

/**
 * @brief Sets the minimum size that a barcode entered in the manual searchbar has to have to possibly be valid.
 *
 * By default this is set to 8.
 *
 * @since 1.0.0
 *
 * @param length Minimum number of input characters.
 */
- (void)setMinSearchBarBarcodeLength:(NSInteger)length;

/**
 * @brief Sets the maximum size that a barcode entered in the manual searchbar can have to possibly be valid.
 *
 * By default this is set to 100.
 *
 * @since 1.0.0
 *
 * @param length Maximum number of input characters.
 */
- (void)setMaxSearchBarBarcodeLength:(NSInteger)length;
///@}


/** @name Deprecated
 *  Deprecated methods.
 */
///@{

/**
 * @deprecated This method serves no purpose any more in Scandit SDK 3.* and is deprecated.
 *
 * @brief Deprecated: Add the 'most likely barcode' UI element.
 *
 * This element is displayed
 * below the viewfinder when the barcode engine is not 100% confident
 * in its result and asks for user confirmation. This element is
 * seldom displayed - typically only when decoding challenging barcodes
 * with fixed focus cameras.
 *
 * By default this is disabled (see comment above).
 */
- (void)showMostLikelyBarcodeUIElement:(BOOL)show;

/**
 * @deprecated This method serves no purpose any more in Scandit SDK 3.* and is deprecated.
 *
 * @brief Deprecated: Sets the text that will be displayed above the viewfinder to tell the user to align it with the
 * barcode that should be recognized.
 *
 * By default this is: "Align code with box"
 */
- (void)setTextForInitialScanScreenState:(NSString *)text;

/**
 * @deprecated This method serves no purpose any more in Scandit SDK 3.* and is deprecated.
 *
 * @brief Deprecated: Sets the text that will be displayed above the viewfinder to tell the user to align it with the
 * barcode and hold still because a potential code seems to be on the screen.
 *
 * By default this is: "Align code and hold still"
 */
- (void)setTextForBarcodePresenceDetected:(NSString *)text;

/**
 * @deprecated This method serves no purpose any more in Scandit SDK 3.* and is deprecated.
 *
 * @brief Deprecated: Sets the text that will be displayed above the viewfinder when decoding is in progress
 *
 * By default this is: "Decoding ..."
 */
- (void)setTextForBarcodeDecodingInProgress:(NSString *)text;

/**
 * @deprecated This method serves no purpose any more in Scandit SDK 3.* and is deprecated.
 *
 * @brief Deprecated: Sets the text that will be displayed if the engine was unable to recognize the barcode.
 *
 * By default this is: "No barcode recognized"
 */
- (void)setTextWhenNoBarcodeWasRecognized:(NSString *)text;

/**
 * @deprecated - This method serves no purpose any more in Scandit SDK 3.* and is deprecated.
 *
 * @brief Deprecated: Sets the text that will be displayed if the engine was unable to recognize the barcode and it is
 * suggested to enter the barcode manually.
 *
 * By default this is: "Touch to enter"
 */
- (void)setTextToSuggestManualEntry:(NSString *)text;

/**
 * @deprecated This method serves no purpose any more in Scandit SDK 3.* and is deprecated.
 *
 * @brief Deprecated: Sets the text that is displayed alongside the 'most likely barcode' UI element that
 * is displayed when the barcode engine is not 100% confident in its result and asks for user
 * confirmation.
 *
 * By default this is: "Tap to use"
 */
- (void)setTextForMostLikelyBarcodeUIElement:(NSString *)text;

/**
 * @deprecated This method serves no purpose any more in Scandit SDK 3.* and is deprecated.
 *
 * @brief Sets the font size of the text in the view finder.
 *
 * Note: This feature is only available with the
 * Scandit SDK Enterprise Packages.
 *
 * By default this is font size 16
 *
 * @since 1.0.0
 *
 */
- (void)setViewfinderFontSize:(float)fontSize;

/**
 * @deprecated This method serves no purpose any more in Scandit SDK 3.* and is deprecated.
 *
 * @brief Sets the font of all text displayed in the UI.
 *
 * Note: This feature is only available with the
 * Scandit SDK Enterprise Packages.
 *
 * By default this is: "Helvetica"
 *
 * @since 1.0.0
 *
 */
- (void)setUIFont:(NSString *)font;

/**
 * @deprecated This method serves no purpose any more in Scandit SDK 3.* and is deprecated.
 * Use method drawViewfinder instead.
 *
 * @brief Deprecated: Sets whether the overlay controller draws the static viewfinder (i.e. white rectangle)
 * when no code was detected yet.
 *
 * Note: This feature is only available with the
 * Scandit SDK Enterprise Packages.
 *
 * By default this is YES.
 */
- (void)drawStaticViewfinder:(BOOL)draw;

/**
 * @deprecated This method serves no purpose any more in Scandit SDK 3.* and is deprecated.
 *
 * @brief Deprecated: Sets whether to draw the hook at the top of the viewfinder that displays text.
 *
 *
 * By default this is enabled.
 */
- (void)drawViewfinderTextHook:(BOOL)draw;

/**
 * @deprecated This method serves no purpose any more in Scandit SDK 3.* and is deprecated.
 *
 * @brief Deprecated: Enables (or disables) the "flash" when a barcode is successfully scanned.
 *
 *
 */
- (void)setScanFlashEnabled:(BOOL)enabled;

///@}

@end
