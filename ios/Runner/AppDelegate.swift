import UIKit
import Photos
import AVFoundation
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestPhotoLibraryPermission()
        requestCameraPermission()
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    

    func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized, .limited:
                print("Photo Library access granted")
            case .denied, .restricted:
                print("Photo Library access denied")
                DispatchQueue.main.async {
                    self.showPhotoLibraryPermissionAlert()
                }
            case .notDetermined:
                print("User has not yet made a choice regarding Photo Library access")
            @unknown default:
                fatalError("Unknown authorization status")
            }
        }
    }

    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print("Camera access granted")
            } else {
                print("Camera access denied")
            }
        }
    }

    func showPhotoLibraryPermissionAlert() {
        let alertController = UIAlertController(
            title: "Photo Library Access Denied",
            message: "To access photos, please allow access to the photo library in Settings.",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true)
    }
}
