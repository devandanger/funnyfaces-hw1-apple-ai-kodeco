import Combine
import Vision

class ModelProvider: NSObject, ObservableObject {
  static let shared = ModelProvider()
  
  var requests: [VNRequest] = []
}
