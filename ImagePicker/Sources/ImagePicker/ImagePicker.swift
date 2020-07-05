import SwiftUI
import Photos
import PhotosUI
import CoreLocation

struct ImagePickerViewController: UIViewControllerRepresentable {
    @Binding var presentationMode: PresentationMode

    var imagePicked: ((UIImage, CLLocation?, Date?) -> Void)?

    //swiftlint:disable line_length
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerViewController>) -> PHPickerViewController {
        let photoLibrary = PHPhotoLibrary.shared()
        let configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator

        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { _ in

            }
        }

        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController,
                                context: UIViewControllerRepresentableContext<ImagePickerViewController>) {
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerViewController

        init(_ parent: ImagePickerViewController) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            let identifiers = results.compactMap(\.assetIdentifier)
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
            guard let asset = fetchResult.firstObject else {
                picker.dismiss(animated: true, completion: nil)
                return
            }

            let image = asset.image

            parent.imagePicked?(image, asset.location, asset.creationDate)
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

public struct ImagePicker: View {
    var imagePicked: ((UIImage, CLLocation?, Date?) -> Void)

    public init(imagePicked: @escaping ((UIImage, CLLocation?, Date?) -> Void)) {
        self.imagePicked = imagePicked
    }

    @Environment(\.presentationMode) var presentationMode

    public var body: some View {
        ImagePickerViewController(presentationMode: presentationMode,
                                  imagePicked: imagePicked)
    }
}

extension PHAsset {
    var image: UIImage {
        var readImage = UIImage()
        let imageManager = PHCachingImageManager()
        let requestOptions = PHImageRequestOptions()

        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.fast
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = true

        imageManager.requestImage(for: self,
                                  targetSize: PHImageManagerMaximumSize,
                                  contentMode: PHImageContentMode.default,
                                  options: requestOptions,
                                  resultHandler: { image, _ in
                                    guard let image = image else {
                                        return
                                    }
            readImage = image
        })

        return readImage
    }
}
