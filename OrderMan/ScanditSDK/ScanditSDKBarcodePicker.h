/**
 * ScanditSDKBarcodePicker acquires camera frames, decodes barcodes in the
 * camera frames and updates the ScanditSDKOverlayController.
 *
 * Copyright Mirasense AG
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>


@class ScanditSDKBarcodePicker;
@class ScanditSDKOverlayController;

/**
 * @brief protocol to receive individual frame from barcode picker
 * @ingroup scanditsdk-ios-api
 * @since 2.0.0
 */
@protocol ScanditSDKNextFrameDelegate
/**
 * @brief Returns a jpg encoded camera image of the given height and width.
 *
 * To receive this callback with the barcode picker, the #sendNextFrameToDelegate:
 * method needs to be called beforehand. We recommend to not call this method repeatedly
 * while the barcode scanner is running, since the JPG conversion of the camera frame is very slow.
 *
 * @since 2.0.0
 */
- (void)scanditSDKBarcodePicker:(ScanditSDKBarcodePicker*)scanditSDKBarcodePicker
				didCaptureImage:(NSData*) image
					 withHeight:(int)height
					  withWidth:(int)width;
@end


/**
 * Enumeration of different camera orientations.
 *
 * @since 2.1.7
 */
typedef enum {
    CAMERA_FACING_BACK, /**< Default camera orientation - facing away from user */
    CAMERA_FACING_FRONT /**< Facetime camera orientation - facing the user */
} CameraFacingDirection;

/**
 * @brief Enumeration of different MSI Checksums
 *
 * @since 3.0.0
 */
typedef enum {
	NONE,
	CHECKSUM_MOD_10,  /**< Default MSI Plessey Checksum */
	CHECKSUM_MOD_1010,
	CHECKSUM_MOD_11,
	CHECKSUM_MOD_1110
} MsiPlesseyChecksumType;

/**
 * Enumerates the possible working ranges for the barcode picker
 *
 * @since 4.1.0
 */
typedef enum {
	/**
	 * The camera tries to focus on barcodes which are close to the camera. To scan far-
	 * away codes (30-40cm+), user must tap the screen. This is the default working range 
	 * and works best for most use-cases. Only change the default value if you expect the 
	 * users to often scan codes which are far away.
	 */
    STANDARD_RANGE,
	/**
	 * The camera tries to focus on barcodes which are far from the camera. This will make
	 * it easier to scan codes that are far away but degrade performance for very close 
	 * codes.
	 */
    LONG_RANGE,
	
	/**
	 * @deprecated This value has been deprecated in Scandit SDK 4.2+. Setting it 
	 * has no effect
	 */
    HIGH_DENSITY
} WorkingRange;

/**
 * @brief Acquires camera frames, decodes barcodes in those camera frames and updates the
 * ScanditSDKOverlayController.
 *
 * @ingroup scanditsdk-ios-api
 *
 * Example (minimal) usage:
 *
 * Set up the barcode picker in one of your view controllers:
 *
 * @code
 *
 * // Instantiate the barcode picker.
 * scanditSDKBarcodePicker = [[ScanditSDKBarcodePicker alloc] initWithAppKey:kScanditSDKAppKey];
 *
 * // Set a class as the delegate for the overlay controller to handle events when
 * // a barcode is successfully scanned or manually entered or the cancel button is pressed.
 * scanditSDKBarcodePicker.overlayController.delegate = self;
 *
 * // Present the barcode picker modally
 * [self presentModalViewController:scanditSDKBarcodePicker animated:YES];
 *
 * // Start the scanning
 * [scanditSDKBarcodePicker startScanning];
 *
 * @endcode
 *
 * @since 1.0.0
 *
 * \nosubgrouping
 * Copyright Mirasense AG
 */
@interface ScanditSDKBarcodePicker : UIViewController {
    
	ScanditSDKOverlayController *overlayController;
    CGSize size;
    AVCaptureVideoOrientation cameraPreviewOrientation;
    CameraFacingDirection cameraFacingDirection;
}

/**
 * @brief The overlay controller controls the scan user interface.
 *
 * The Scandit SDK contains a default implementation that developers can inherit
 * from to define their own scan UI (enterprise licensees only).
 *
 * @since 1.0.0
 *
 */
@property (nonatomic, retain) ScanditSDKOverlayController *overlayController;

/**
 * @brief The size of the scan user interface.
 *
 * Change the size if you want to scale the picker (see example in the demo project).
 * By default it is set to full screen.
 *
 * @since 2.1.9
 *
 */
@property (nonatomic, assign) CGSize size;

/**
 * @brief The orientation of the camera preview.
 *
 * Use this property to set the (camera) orientation
 * to a specific orientation. The preferred way of adjusting the camera preview orientation
 * is however to implement a AutoRotatingViewController (see example).
 * Possible values are:
 * AVCaptureVideoOrientationPortrait, AVCaptureVideoOrientationPortraitUpsideDown,
 * AVCaptureVideoOrientationLandscapeLeft, AVCaptureVideoOrientationLandscapeRight
 *
 * @since 2.0.0
 */
@property (nonatomic, assign) AVCaptureVideoOrientation cameraPreviewOrientation;

/**
 * @brief The camera used for barcode scanning.
 *
 * This property is read-only.
 *
 * @since 2.1.7
 */
@property (readonly, nonatomic, assign) CameraFacingDirection cameraFacingDirection;

/**
 * @brief Sets the focus working range for the barcode picker
 *
 * The working range tells the engine at which distance barcodes are to be expected.
 * When set to STANDARD_RANGE (the default), the focus is optimized for barcodes close
 * to the camera. When set to LONG_RANGE, the focus is optimized for far-away codes.
 *
 * When using non-standard working range, it is better to directly pass the working
 * range when constructing the barcode picker, because the camera can already start
 * to adjust the focus at an earlier point in time.
 *
 * See ::WorkingRange for a list of possible values
 *
 * The working range hint is ignored on cameras with fixed-focus.
 *
 * @since 4.1.0
 */
@property (nonatomic, assign) WorkingRange workingRange;

/** @name Barcode Picker Setup
 *  Initialize and prepare the barcode picker, control standby state and set overlay
 */
///@{
/**
 * @brief Prepares a ScanditSDKBarcodePicker which accelerates the camera start.
 *
 * We recommend calling this method in applicationDidFinishLaunching prior to calling #initWithAppKey:.
 * Preparing the picker with this method accelerates the camera start significantly.
 * The additional resources required for this speed up are minimal.
 *
 * The method prepares the default backwards facing camera.
 * \nosubgrouping
 * @since 3.0.0
 *
 * @param scanditSDKAppKey your Scandit SDK App Key (available from your Scandit account)
 */
+ (void)prepareWithAppKey:(NSString *)scanditSDKAppKey;

/**
 * @brief Prepares a ScanditSDKBarcodePicker which accelerates the camera start with the
 * desired camera orientation.
 *
 * We recommend calling this method in applicationDidFinishLaunching prior to calling #initWithAppKey:.
 * Preparing the picker with this method accelerates the camera start significantly.
 * The additional resources required for this speed up are minimal.
 *
 * @since 3.0.0
 *
 * @param scanditSDKAppKey your Scandit SDK App Key (available from your Scandit account)
 * @param facing the desired camera direction
 */
+ (void)prepareWithAppKey:(NSString *)scanditSDKAppKey
   cameraFacingPreference:(CameraFacingDirection)facing;

/**
 * @brief Initiate the barcode picker with the desired camera orientation and working range
 *
 * Consider using #prepareWithAppKey:cameraFacingPreference: in applicationDidFinishLaunching
 * prior to calling this method in your view controller to accelerate the camera start.
 *
 * @see ScanditSDKBarcodePicker#prepareWithAppKey:cameraFacingPreference:
 *
 * @since 4.2.0
 *
 * @param scanditSDKAppKey your Scandit SDK App Key (available from your Scandit account)
 * @param facing the desired camera direction
 * @param range the desired working range
 */
- (id)initWithAppKey:(NSString *)scanditSDKAppKey
cameraFacingPreference:(CameraFacingDirection)facing workingRange:(WorkingRange)range;

/**
 * @brief Initiate the barcode picker with the default camera orientation (CAMERA_FACING_BACK).
 *
 * Consider using #prepareWithAppKey: in applicationDidFinishLaunching prior to calling this method 
 * in your view controller to accelerate the camera start.
 *
 * @see ScanditSDKBarcodePicker#prepareWithAppKey:
 *
 * @since 2.0.0
 *
 * @param scanditSDKAppKey your Scandit SDK App Key (available from your Scandit account)
 */
- (id)initWithAppKey:(NSString *)scanditSDKAppKey;

/**
 * @brief Initiate the barcode picker with the desired camera orientation.
 *
 * Consider using #prepareWithAppKey:cameraFacingPreference: in applicationDidFinishLaunching prior to calling this method
 * in your view controller to accelerate the camera start.
 *
 * @see ScanditSDKBarcodePicker#prepareWithAppKey:cameraFacingPreference:
 *
 * @since 2.1.7
 *
 * @param scanditSDKAppKey your Scandit SDK App Key (available from your Scandit account)
 * @param facing the desired camera direction
 */
- (id)initWithAppKey:(NSString *)scanditSDKAppKey
cameraFacingPreference:(CameraFacingDirection)facing;

/**
 * @brief Prepares a ScanditSDKBarcodePicker which accelerates the camera start with the
 * desired camera orientation and working range
 *
 * We recommend calling this method in applicationDidFinishLaunching prior to calling #initWithAppKey:.
 * Preparing the picker with this method accelerates the camera start significantly.
 * The additional resources required for this speed up are minimal.
 *
 * @since 4.2.0
 *
 * @param scanditSDKAppKey your Scandit SDK App Key (available from your Scandit account)
 * @param facing the desired camera direction
 * @param range the desired working range for the auto-focus
 */
+ (void)prepareWithAppKey:(NSString *)scanditSDKAppKey
   cameraFacingPreference:(CameraFacingDirection)facing workingRange:(WorkingRange)range;

/**
 * @brief Sets a custom overlay controller that received updates from the barcode picker.
 *
 * Use this method to specify your own custom overlay that customizes the scan view.
 *
 * Note: This feature is only available with the Scandit SDK Enterprise Packages.
 *
 * @since 1.0.0
 *
 * @param overlay custom overlay controller
 */
- (void)setOverlayController:(ScanditSDKOverlayController *)overlay;

/**
 * @brief Forces the release of the barcode picker and all attached objects.
 *
 * By default the camera is being held in a standby mode when the barcode picker object is released.
 * Forcing a release will lead to the deallocation of all resources and shut down the camera completely.
 * This frees up resources (memory, power), but also increases the startup time and time to a successful
 * scan for subsequent scanning attempts.
 *
 * @see ScanditSDKBarcodePicker#disableStandbyState:
 *
 * @since 3.0.3
 */
- (void)forceRelease;

/**
 * @brief Prevents the camera from entering a standby state after the barcode picker object is deallocated.
 *
 * This will free up resources (power, memory) after each scan that are used by the camera in standby mode,
 * but also increases the startup time and time to successful scan for subsequent scans. We recommend disabling
 * the standby state only when your app is typically in the foreground for a long time and barcodes are
 * scanned very infrequently.
 *
 * @since 3.0.0
 */
- (void)disableStandbyState;
///@}


/** @name Camera Selection
 *  Select, choose or determine camera orientation
 */
///@{

/**
 * @brief Returns whether the specified camera facing direction is supported by the current device.
 *
 * @since 3.0.0
 *
 * @param facing The camera facing direction in question.
 * @return Whether the camera facing direction is supported
 */
- (BOOL)supportsCameraFacing:(CameraFacingDirection)facing;

/**
 * @brief Changes to the specified camera facing direction if it is supported.
 *
 * @since 3.0.0
 *
 * @param facing The new camera facing direction
 * @return Whether the change was successful
 */
- (BOOL)changeToCameraFacing:(CameraFacingDirection)facing;

/**
 * @brief Changes to the opposite camera facing if it is supported.
 *
 * @since 3.0.0
 *
 * @return Whether the change was successful
 */
- (BOOL)switchCameraFacing;
///@}


/** @name Barcode Decoder Operation
 *  Start and stop barcode decoder
 */
///@{

/**
 * @brief Returns YES if scanning is in progress.
 *
 * @since 1.0.0
 *
 * @return boolean indicating whether scanning is in progress.
 */
- (BOOL)isScanning;

/**
 * @brief Starts the scanning process.
 *
 * @since 1.0.0
 */
- (void)startScanning;

/**
 * @brief Stops the scanning process.
 *
 * @see ScanditSDKBarcodePicker#stopScanningAndKeepTorchState:
 *
 * @since 1.0.0
 */
- (void)stopScanning;

/**
 * @brief Stops the scanning process but keeps the torch on if it is already turned on.
 *
 * This is useful when the scan user interface remains visible after a successful barcode scan. To prevent
 * additional scans of the same barcode, the scanner needs to be stopped at least temporarily. To avoid making
 * the user switch on the torch again for the next scan, we recommend using this method instead of :stopScanning:
 *
 * @since 3.0.0
 */
- (void)stopScanningAndKeepTorchState;

/**
 * @brief Stops the scanning process and stops the camera feed, freezing it. This will result in a
 * reset of the focus and take longer to focus on a new code when started again.
 *
 * @since 3.2.4
 */
- (void)stopScanningAndFreeze;

/**
 * @deprecated This method serves no purpose any more in Scandit SDK 3.0+ and is deprecated.
 *
 * @brief Resets the state of the barcode picker.
 *
 * @since 1.0.0
 *
 */
- (void)reset;
///@}


/** @name Barcode Decoder Configuration
 *  Adjust the decoding process and area.
 */
///@{

/**
 * @brief Reduces the area in which barcodes are detected and decoded.
 *
 * When activated, the active scanning area is defined by #setScanningHotSpotHeight:
 * and #setScanningHotSpotToX:andY:. If this method is not enabled, barcodes in the full camera
 * image are detected and decoded.
 *
 * @see ScanditSDKBarcodePicker#setScanningHotSpotToX:andY:
 * @see ScanditSDKBarcodePicker#setScanningHotSpotHeight:
 *
 * By default this is not enabled.
 *
 * @since 3.0.0
 
 * @param enabled Whether the scanning area should be restricted.
 */
- (void)restrictActiveScanningArea:(BOOL)enabled;

/**
 * @brief Sets the location in the image where barcodes are decoded with the highest priority.
 *
 * This method shows a slightly different behavior depending on whether the full screen scanning is
 * active or not. In Full screen scanning mode:
 *
 * Sets the location in the image which is decoded with the highest priority when multiple barcodes
 * are present in the image.
 *
 * In restrictActiveScanningArea mode (activated with #restrictActiveScanningArea:):
 *
 * Changes the location of the spot where the barcode decoder actively scans for barcodes.
 *
 * X and Y can be between 0 and 1, where 0/0 corresponds to the top left corner and 1/1 to the bottom right
 * corner.
 *
 * The default hotspot is set to 0.5/0.5
 *
 * @see ScanditSDKBarcodePicker#restrictActiveScanningArea:
 * @see ScanditSDKBarcodePicker#setScanningHotSpotHeight:
 *
 * @since 1.0.0
 *
 * @param x The hotspot's relative x coordinate.
 * @param y The hotspot's relative y coordinate.
 */
- (void)setScanningHotSpotToX:(float)x andY:(float)y;

/**
 * @brief Changes the height of the area where barcodes are decoded in the camera image
 * when restrictActiveScanningArea is activated.
 *
 * The height of the active scanning area is relative to the height of the screen and has to be
 * between 0.0 and 0.5.
 *
 * This only applies if the active scanning area is restricted.
 *
 * The default is 0.25
 *
 * @see ScanditSDKBarcodePicker#restrictActiveScanningArea:
 * @see ScanditSDKBarcodePicker#setScanningHotSpotToX:andY:
 *
 * @since 1.0.0
 *
 * @param height The relative height of the active scanning area.
 */
- (void)setScanningHotSpotHeight:(float)height;

/**
 * @brief Enable the detection/decoding of tiny Data Matrix codes.
 *
 * When this mode is enabled, a dedicated localization algorithm is activated that searches
 * for small Datamatrix codes in the central part of the camera image.
 * This algorithm requires additional resources and slows down the
 * recognition of other barcode symbologies. We recommend using the method
 * only when your application requires the decoding of tiny Datamatrix codes.
 *
 * By default this mode is disabled.
 *
 * @since 2.0.0
 *
 * @param enabled Whether this mode should be enabled.
 */
- (void)setMicroDataMatrixEnabled:(BOOL)enabled;

/**
 * @brief Enables the detection of white on black codes. This option currently only
 * works for Data Matrix codes.
 *
 * By default this mode is disabled.
 *
 * @since 2.0.0
 *
 * @param enabled Whether this mode should be enabled.
 */
- (void)setInverseDetectionEnabled:(BOOL)enabled;

/**
 * @brief Forces the barcode scanner to always run the 2D decoders (QR,Datamatrix, etc.),
 * even when the 2D detector did not detect the presence of a 2D code.
 *
 * This slows down the overall scanning speed, but can be useful when your application only tries
 * to read QR codes. It is by default enabled when the micro Datamatrix mode is enabled.
 *
 * By default, this is disabled.
 *
 * @param force boolean indicating whether this mode should be enabled.
 *
 * @since 2.0.0
 */
- (void)force2dRecognition:(BOOL)force;
///@}


/** @name Barcode Symbology Selection
 *  Configure which symbologies are decoded.
 */
///@{

/**
 * @deprecated Individually enable/disable symbologies instead of using this catch all. Turning
 *             on too many irrelevant symbologies will slow down the recognition unnecessarily.
 *
 * @brief Enables or disables the recognition of all 1D barcode symbologies supported by the
 * particular Scandit SDK edition you are using.
 *
 * By default all 1D symbologies except for MSI Plessey and GS1 DataBar are enabled.
 *
 * @since 1.0.0
 *
 * @param enabled Whether all 1D symbologies should be enabled.
 */
- (void)set1DScanningEnabled:(BOOL)enabled;

/**
 * @deprecated Individually enable/disable symbologies instead of using this catch all. Turning
 *             on too many irrelevant symbologies will slow down the recognition unnecessarily.
 *
 * @brief Enables or disables the recognition of 2D barcode symbologies supported by the
 * particular Scandit SDK edition you are using.
 *
 * By default only QR is enabled.
 *
 * @since 1.0.0
 *
 * @param enabled boolean indicating whether all 2D symbologies are enabled
 */
- (void)set2DScanningEnabled:(BOOL)enabled;

/**
 * @brief Enables or disables the barcode decoder for EAN13 and UPC12/UPCA codes.
 *
 * By default scanning of EAN13 and UPC barcodes is enabled.
 *
 * @since 1.0.0
 *
 * @param enabled Whether this symbology should be enabled.
 */
- (void)setEan13AndUpc12Enabled:(BOOL)enabled;

/**
 * @brief Enables or disables the barcode decoder for EAN8 codes.
 *
 * By default scanning of EAN8 barcodes is enabled.
 *
 * @since 1.0.0
 *
 * @param enabled Whether this symbology should be enabled.
 */
- (void)setEan8Enabled:(BOOL)enabled;

/**
 * @brief Enables or disables the barcode decoder for UPCE codes.
 *
 * By default scanning of UPCE barcodes is enabled.
 *
 * @since 1.0.0
 *
 * @param enabled Whether this symbology should be enabled.
 */
- (void)setUpceEnabled:(BOOL)enabled;

/**
 * @brief Enables or disables the barcode decoder for Code39 codes.
 *
 * By default scanning of Code39 barcodes is enabled. Note:
 * CODE39 scanning is only available with the
 * Scandit SDK Enterprise Basic or Enterprise Premium Package.
 *
 * @since 1.0.0
 *
 * @param enabled Whether this symbology should be enabled.
 */
- (void)setCode39Enabled:(BOOL)enabled;

/**
 * @brief Enables or disables the barcode decoder for Code93 codes.
 *
 * By default scanning of Code93 barcodes is enabled. Note:
 * CODE93 scanning is only available with the
 * Scandit SDK Enterprise Basic or Enterprise Premium Package.
 *
 * @since 4.0.1
 *
 * @param enabled Whether this symbology should be enabled.
 */
- (void)setCode93Enabled:(BOOL)enabled;

/**
 * @brief Enables or disables the barcode decoder for Code128 codes.
 *
 * By default scanning of Code128 barcodes is enabled. Note:
 * CODE128 scanning is only available with the
 * Scandit SDK Enterprise Basic or Enterprise Premium Package.
 *
 * @since 1.0.0
 *
 * @param enabled Whether this symbology should be enabled.
 */
- (void)setCode128Enabled:(BOOL)enabled;

/**
 * @brief Enables or disables the barcode decoder for ITF (2 out of 5) codes.
 *
 * By default scanning of ITF barcodes is enabled. Note:
 * ITF scanning is only available with the
 * Scandit SDK Enterprise Basic or Enterprise Premium Package.
 *
 * @since 1.0.0
 *
 * @param enabled Whether this symbology should be enabled.
 */
- (void)setItfEnabled:(BOOL)enabled;

/**
 * @brief Enables or disables the barcode decoder for MSI Plessey codes.
 *
 * By default scanning of MSI Plessey barcodes is disabled. Note:
 * MSI Plessey scanning is only available with the
 * Scandit SDK Enterprise Basic or Enterprise Premium Package.
 *
 * @since 3.0.0
 *
 * @param enabled Whether this symbology should be enabled.
 */
- (void)setMsiPlesseyEnabled:(BOOL)enabled;

/**
 * @brief Sets the type of checksum that is expected of the MSI Plessey codes.
 *
 * MSI Plessey is used with different checksums. Set the checksum your application uses
 * with this method.
 *
 * By default it is set to CHECKSUM_MOD_10.
 *
 * @since 3.0.0
 *
 * @param type The MSIPlesseyChecksumType your application uses.
 */
- (void)setMsiPlesseyChecksumType:(MsiPlesseyChecksumType)type;

/**
 * @brief Enables or disables the barcode decoder for GS1 DataBar codes.
 *
 * By default scanning of GS1 DataBar barcodes is disabled. Note:
 * GS1 DataBar scanning is only available with the
 * Scandit SDK Enterprise Basic or Enterprise Premium Package.
 *
 * @since 4.0.0
 *
 * @param enabled Whether this symbology should be enabled.
 */
- (void)setGS1DataBarEnabled:(BOOL)enabled;

/**
 * @brief Enables or disables the barcode decoder for GS1 DataBar Expanded codes.
 *
 * By default scanning of GS1 DataBar Expanded barcodes is disabled. Note:
 * GS1 DataBar scanning is only available with the
 * Scandit SDK Enterprise Basic or Enterprise Premium Package.
 *
 * @since 4.0.0
 *
 * @param enabled Whether this symbology should be enabled.
 */
- (void)setGS1DataBarExpandedEnabled:(BOOL)enabled;

/**
 * @brief Enables or disables the barcode decoder for Codabar codes.
 *
 * By default scanning of Codabar barcodes is disabled. Note: Codabar scanning is only available 
 * with the Scandit SDK Enterprise Basic or Enterprise Premium Package.
 *
 * @since 4.0.0
 *
 * @param enabled boolean indicating whether this symbology should be enabled.
 */
- (void)setCodabarEnabled:(BOOL)enabled;

/**
 * @brief Enables or disables the barcode decoder for QR codes.
 *
 * By default scanning of QR barcodes is enabled.
 *
 * @since 2.0.0
 *
 * @param enabled Whether this symbology should be enabled.
 */
- (void)setQrEnabled:(BOOL)enabled;

/**
 * @brief Enables or disables the barcode decoder for Datamatrix codes.
 *
 * By default scanning of Datamatrix codes is enabled.
 *
 * Note: Datamatrix scanning is only available with the
 * Scandit SDK Enterprise Premium Package.
 *
 * @since 2.0.0
 *
 * @param enabled Whether this symbology should be enabled.
 */
- (void)setDataMatrixEnabled:(BOOL)enabled;

/**
 * @brief Enables or disables the barcode decoder for PDF417 codes.
 *
 * By default scanning of PDF417 codes is disabled (since 3.2.0).
 *
 * Note: PDF417 scanning is only available with the
 * Scandit SDK Enterprise Premium Package.
 *
 * @since 3.0.0
 *
 * @param enabled Whether this symbology should be enabled.
 */
- (void)setPdf417Enabled:(BOOL)enabled;
///@}


/** @name Torch Control
 *  Switch torch programmatically
 */
///@{
/**
 * @brief Switches the torch (if available) on or off programmatically.
 *
 * There is also a method in the ScanditSDKOverlayController to add a torch icon that the user can
 * click to activate the torch.
 *
 * By default the torch switch is off.
 *
 * @since 2.0.0
 */
- (void)switchTorchOn:(BOOL)on;
///@}

/** @name Camera Frame Access
 *
 */
///@{
/**
 * @brief Sets the delegate to which the next frame should be sent.
 *
 * The next frame from the camera is
 * then converted to a JPEG image and the ScanditSDKBarcodePicker will pass the jpg image, width and height
 * to the delegate. We recommend to not call this method repeatedly while the barcode scanner is running,
 * since the JPG conversion of the camera frame is very slow.
 *
 * @since 2.0.0
 *
 * @param delegate implementing the ScanditSDKNextFrameDelegate protocol
 */
- (void)sendNextFrameToDelegate:(id<ScanditSDKNextFrameDelegate>)delegate;
///@}


@end

