import SwiftUI
import UIKit
import Vision

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Binding var recognizedText: String?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                self.parent.selectedImage = image
                if let unwrappedImage = self.parent.selectedImage {
                    extractLargestTextFromImage(unwrappedImage) { largestText in
                        self.parent.recognizedText = largestText  // Explicitly use 'self' here
                    }
                }
            }
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

func extractLargestTextFromImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
    guard let cgImage = image.cgImage else {
        completion(nil)
        return
    }

    let request = VNRecognizeTextRequest { (request, error) in
        guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
            completion(nil)
            return
        }
        
        var largestText: String?
        var largestTextArea: CGFloat = 0
        
        for observation in observations {
            if let topCandidate = observation.topCandidates(1).first {
                let boundingBox = observation.boundingBox
                let area = boundingBox.width * boundingBox.height
                
                if area > largestTextArea {
                    largestText = topCandidate.string
                    largestTextArea = area
                }
            }
        }
        
        // Return the largest recognized text
        DispatchQueue.main.async {
            completion(largestText)
        }
    }

    request.recognitionLevel = .accurate

    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    DispatchQueue.global(qos: .userInitiated).async {
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform text recognition: \(error)")
            completion(nil)
        }
    }
}
