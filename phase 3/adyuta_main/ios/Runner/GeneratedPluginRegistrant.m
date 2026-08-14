//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<app_links/AppLinksPlugin.h>)
#import <app_links/AppLinksPlugin.h>
#else
@import app_links;
#endif

#if __has_include(<background_sms/BackgroundSmsPlugin.h>)
#import <background_sms/BackgroundSmsPlugin.h>
#else
@import background_sms;
#endif

#if __has_include(<connectivity_plus/ConnectivityPlusPlugin.h>)
#import <connectivity_plus/ConnectivityPlusPlugin.h>
#else
@import connectivity_plus;
#endif

#if __has_include(<flutter_background_service_ios/FlutterBackgroundServicePlugin.h>)
#import <flutter_background_service_ios/FlutterBackgroundServicePlugin.h>
#else
@import flutter_background_service_ios;
#endif

#if __has_include(<flutter_local_notifications/FlutterLocalNotificationsPlugin.h>)
#import <flutter_local_notifications/FlutterLocalNotificationsPlugin.h>
#else
@import flutter_local_notifications;
#endif

#if __has_include(<flutter_phone_direct_caller/FlutterPhoneDirectCallerPlugin.h>)
#import <flutter_phone_direct_caller/FlutterPhoneDirectCallerPlugin.h>
#else
@import flutter_phone_direct_caller;
#endif

#if __has_include(<flutter_secure_storage/FlutterSecureStoragePlugin.h>)
#import <flutter_secure_storage/FlutterSecureStoragePlugin.h>
#else
@import flutter_secure_storage;
#endif

#if __has_include(<flutter_tts/FlutterTtsPlugin.h>)
#import <flutter_tts/FlutterTtsPlugin.h>
#else
@import flutter_tts;
#endif

#if __has_include(<geolocator_apple/GeolocatorPlugin.h>)
#import <geolocator_apple/GeolocatorPlugin.h>
#else
@import geolocator_apple;
#endif

#if __has_include(<google_sign_in_ios/FLTGoogleSignInPlugin.h>)
#import <google_sign_in_ios/FLTGoogleSignInPlugin.h>
#else
@import google_sign_in_ios;
#endif

#if __has_include(<image_picker_ios/FLTImagePickerPlugin.h>)
#import <image_picker_ios/FLTImagePickerPlugin.h>
#else
@import image_picker_ios;
#endif

#if __has_include(<local_auth_ios/FLTLocalAuthPlugin.h>)
#import <local_auth_ios/FLTLocalAuthPlugin.h>
#else
@import local_auth_ios;
#endif

#if __has_include(<passkeys_ios/PasskeysPlugin.h>)
#import <passkeys_ios/PasskeysPlugin.h>
#else
@import passkeys_ios;
#endif

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

#if __has_include(<permission_handler_apple/PermissionHandlerPlugin.h>)
#import <permission_handler_apple/PermissionHandlerPlugin.h>
#else
@import permission_handler_apple;
#endif

#if __has_include(<printing/PrintingPlugin.h>)
#import <printing/PrintingPlugin.h>
#else
@import printing;
#endif

#if __has_include(<sensors_plus/FPPSensorsPlusPlugin.h>)
#import <sensors_plus/FPPSensorsPlusPlugin.h>
#else
@import sensors_plus;
#endif

#if __has_include(<shared_preferences_foundation/SharedPreferencesPlugin.h>)
#import <shared_preferences_foundation/SharedPreferencesPlugin.h>
#else
@import shared_preferences_foundation;
#endif

#if __has_include(<sqflite/SqflitePlugin.h>)
#import <sqflite/SqflitePlugin.h>
#else
@import sqflite;
#endif

#if __has_include(<sqlite3_flutter_libs/Sqlite3FlutterLibsPlugin.h>)
#import <sqlite3_flutter_libs/Sqlite3FlutterLibsPlugin.h>
#else
@import sqlite3_flutter_libs;
#endif

#if __has_include(<ua_client_hints/UAClientHintsPlugin.h>)
#import <ua_client_hints/UAClientHintsPlugin.h>
#else
@import ua_client_hints;
#endif

#if __has_include(<url_launcher_ios/URLLauncherPlugin.h>)
#import <url_launcher_ios/URLLauncherPlugin.h>
#else
@import url_launcher_ios;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AppLinksPlugin registerWithRegistrar:[registry registrarForPlugin:@"AppLinksPlugin"]];
  [BackgroundSmsPlugin registerWithRegistrar:[registry registrarForPlugin:@"BackgroundSmsPlugin"]];
  [ConnectivityPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"ConnectivityPlusPlugin"]];
  [FlutterBackgroundServicePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterBackgroundServicePlugin"]];
  [FlutterLocalNotificationsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterLocalNotificationsPlugin"]];
  [FlutterPhoneDirectCallerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterPhoneDirectCallerPlugin"]];
  [FlutterSecureStoragePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterSecureStoragePlugin"]];
  [FlutterTtsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterTtsPlugin"]];
  [GeolocatorPlugin registerWithRegistrar:[registry registrarForPlugin:@"GeolocatorPlugin"]];
  [FLTGoogleSignInPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTGoogleSignInPlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
  [FLTLocalAuthPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTLocalAuthPlugin"]];
  [PasskeysPlugin registerWithRegistrar:[registry registrarForPlugin:@"PasskeysPlugin"]];
  [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [PrintingPlugin registerWithRegistrar:[registry registrarForPlugin:@"PrintingPlugin"]];
  [FPPSensorsPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FPPSensorsPlusPlugin"]];
  [SharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferencesPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
  [Sqlite3FlutterLibsPlugin registerWithRegistrar:[registry registrarForPlugin:@"Sqlite3FlutterLibsPlugin"]];
  [UAClientHintsPlugin registerWithRegistrar:[registry registrarForPlugin:@"UAClientHintsPlugin"]];
  [URLLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"URLLauncherPlugin"]];
}

@end
