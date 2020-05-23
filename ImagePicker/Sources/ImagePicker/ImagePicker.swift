import SwiftUI
import Photos
import CoreLocation

struct ImagePickerViewController: UIViewControllerRepresentable {
    @Binding var presentationMode: PresentationMode

    var imagePicked: ((UIImage, CLLocation?, Date?) -> Void)?

    //swiftlint:disable line_length
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerViewController>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = context.coordinator

        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { _ in

            }
        }

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePickerViewController>) {
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePickerViewController

        init(_ parent: ImagePickerViewController) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            guard let asset = info[.phAsset] as? PHAsset else {
                return
            }

            let image = asset.image

            parent.imagePicked?(image, asset.location, asset.creationDate)
            parent.presentationMode.dismiss()
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.dismiss()
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
