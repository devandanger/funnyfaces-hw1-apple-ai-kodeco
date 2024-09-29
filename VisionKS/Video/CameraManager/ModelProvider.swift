import Combine
import Vision

class ModelProvider: NSObject, ObservableObject {
  static let shared = ModelProvider()
  
  var requests: [VNRequest] = []
  
  let faceDetectionRequest: VNDetectFaceRectanglesRequest = VNDetectFaceRectanglesRequest { request, error in
    if let error = error {
      print("Error with face detection: \(error.localizedDescription)")
      return
    } else {
      print("Able to find it faces")
    }
  }
  
  func toggleFaceDetection(_ toggle: Bool) {
    if toggle {
      if !requests.contains(faceDetectionRequest) {
        requests.append(faceDetectionRequest)
      } else {
        requests.removeAll(where: { $0 === faceDetectionRequest })
      }
    }
  }
}
