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
    var visionModelSelected = false

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
    // swiftlint:disable:next array_init
        cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)
        
        frameManager.$currentSample
            .filter({ _ in
                return self.visionModelSelected
            })
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
        
//        modelManager.$visionImage
//            .compactMap { $0 }
//            .sink { visionImage in
//                let options: CommonImageLabelerOptions = ImageLabelerOptions()
//                options.confidenceThreshold = NSNumber(floatLiteral: 0.7)
//                let onDeviceLabeler = ImageLabeler.imageLabeler(options: options)
//
//                do {
//                    let labels = try onDeviceLabeler.results(in: visionImage)
//
//                    let results = labels.map { label -> String in
//                        return "Label: \(label.text), Confidence: \(label.confidence), Index: \(label.index)"
//                    }.joined(separator: "\n")
//                    print("Results: \(results)")
//
//                    DispatchQueue.main.async {
//                        self.labelingResults = results
//                        self.labels.append(contentsOf: labels)
//                    }
//
//                } catch let error {
//                    self.labelingResults = ""
//                    print("Error analyzing image: \(error.localizedDescription)")
//                }
//            }
//            .store(in: &subscriptions)
    }
}
