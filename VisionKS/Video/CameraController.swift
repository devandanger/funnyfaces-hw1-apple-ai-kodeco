import AVFoundation
import Combine
import CoreImage
//import MLKit
import UIKit

enum CameraIdentification {
    case found(identifier: String)
    case notFound
}


class CameraController: ObservableObject {
    @Published var error: Error?
    @Published var frame: CGImage?
    @Published var labelingResults: String = ""
    @Published var found: CameraIdentification = .notFound

    var comicFilter = false
    var monoFilter = false
    var crystalFilter = false
    var visionModelSelected = true
  var detectFaces: Bool = false {
    didSet {
      ModelProvider.shared.toggleFaceDetection(detectFaces)
    }
  }

    private let context = CIContext()

    private let cameraManager = CameraManager.shared
    private let frameManager = FrameManager.shared
    private let modelInferenceManager = ModelInferenceManager.shared
    private let modelProvider = ModelProvider.shared
    private var subscriptions = Set<AnyCancellable>()

    init() {
        setupSubscriptions()
    }

    func setupSubscriptions() {
        cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)
        
        frameManager.$currentSample
            .compactMap { $0 }
            .sink { buffer in
                self.modelInferenceManager.buffer.send(buffer)
            }
            .store(in: &subscriptions)

        frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { buffer in
                guard let image = CGImage.create(from: buffer) else {
                    return nil
                }
                var ciImage = CIImage(cgImage: image)
                if self.comicFilter {
                    ciImage = ciImage.applyingFilter("CIComicEffect")
                }

                if self.monoFilter {
                    ciImage = ciImage.applyingFilter("CIPhotoEffectNoir")
                }

                if self.crystalFilter {
                    ciImage = ciImage.applyingFilter("CICrystallize")
                }
                return self.context.createCGImage(ciImage, from: ciImage.extent)
              }
              .assign(to: &$frame)
        
        modelInferenceManager.currentPrediction
            .sink { prediction in
                
                self.found = .found(identifier: prediction.classification)
            }
            .store(in: &subscriptions)
    }
}
