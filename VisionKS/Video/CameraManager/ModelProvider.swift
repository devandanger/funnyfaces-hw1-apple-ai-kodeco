import Combine
import Vision

class ModelProvider: NSObject, ObservableObject {
  static let shared = ModelProvider()
  
  var requests: [VNRequest] = []
  
  @Published var faceObservations: [VNFaceObservation] = []
  
  lazy var faceDetectionRequest: VNDetectFaceLandmarksRequest = VNDetectFaceLandmarksRequest { request, error in
    if let error = error {
      print("Error with face detection: \(error.localizedDescription)")
      return
    } else {
      guard let results = request.results else { return }
      self.faceObservations = results.compactMap { observation in
        guard let faceObservation = observation as? VNFaceObservation else { return nil }
        return faceObservation
      }
    }
  }
  
  private override init() {
    super.init()
    self.requests = [self.faceDetectionRequest]
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
