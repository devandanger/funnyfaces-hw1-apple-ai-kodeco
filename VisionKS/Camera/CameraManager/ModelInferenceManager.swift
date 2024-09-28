//
//  ModelManager.swift
//  Camera
//
//  Created by Evan Anger on 9/27/22.
//

import AVFoundation
import Combine
import CoreML
import Foundation
import Vision
//import MLKit

struct Prediction {
    /// The name of the object or scene the image classifier recognizes in an image.
    let classification: String

    /// The image classifier's confidence as a percentage string.
    ///
    /// The prediction string doesn't include the % symbol in the string.
    let confidence: Float
}
typealias ImagePredictionHandler = (_ predictions: [Prediction]?) -> Void

class ModelInferenceManager: NSObject, ObservableObject {
//    @Published var visionImage: VisionImage?
    private var predictionHandlers: [VNRequest: ImagePredictionHandler] = [:]
    let currentPrediction: PassthroughSubject<Prediction, Never> = PassthroughSubject()

    var buffer: PassthroughSubject<CMSampleBuffer, Never> = PassthroughSubject()
    static let shared = ModelInferenceManager()
  let modelProvider = ModelProvider.shared

    
//    lazy var coreModel: VNCoreMLModel = {
//        return try! VNCoreMLModel(for: model)
//    }()
    
//    lazy var model: MLModel = {
//        return imageClassifier.model
//    }()
//  
//    lazy var imageClassifier: AnimalClassifier1 = {
//        return try! AnimalClassifier1(configuration: MLModelConfiguration())
//    }()
    
    private var subscriptions = Set<AnyCancellable>()
//    private func createRequest() -> VNImageBasedRequest {
//        let imageClassificationRequest = VNCoreMLRequest(
//            model: coreModel,
//            completionHandler: visionRequestHandler
//        )
//
//        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
//        return imageClassificationRequest
//    }
    
    private override init() {
        super.init()
    
        
        buffer
            .receive(on: RunLoop.current)
            .sink { buffer in
                let handler = VNImageRequestHandler(cmSampleBuffer: buffer)

                do {
                  try handler.perform(self.modelProvider.requests)
                } catch {
                    print("Unable to process: \(error.localizedDescription)")
                }
            }
            .store(in: &subscriptions)
    }
    
    private func visionRequestHandler(_ request: VNRequest, error: Error?) {
        // Remove the caller's handler from the dictionary and keep a reference to it.
//        guard let predictionHandler = predictionHandlers.removeValue(forKey: request) else {
//            fatalError("Every request must have a prediction handler.")
//        }

        // Start with a `nil` value in case there's a problem.
        var predictions: [Prediction]? = nil

        // Call the client's completion handler after the method returns.
//        defer {
//            // Send the predictions back to the client.
//            predictionHandler(predictions)
//        }

        // Check for an error first.
        if let error = error {
            print("Vision image classification error...\n\n\(error.localizedDescription)")
            return
        }

        // Check that the results aren't `nil`.
        if request.results == nil {
            print("Vision request had no results.")
            return
        }

        // Cast the request's results as an `VNClassificationObservation` array.
        guard let observations = request.results as? [VNClassificationObservation] else {
            // Image classifiers, like MobileNet, only produce classification observations.
            // However, other Core ML model types can produce other observations.
            // For example, a style transfer model produces `VNPixelBufferObservation` instances.
            print("VNRequest produced the wrong result type: \(type(of: request.results)).")
            return
        }

        // Create a prediction array from the observations.
        predictions = observations.map { observation in
            // Convert each observation into an `ImagePredictor.Prediction` instance.
            Prediction(classification: observation.identifier,
                       confidence: observation.confidence)
        }
        
        observations.forEach { observation in
            if observation.confidence > 0.99 {
                let prediction = Prediction(classification: observation.identifier, confidence: observation.confidence)
                currentPrediction.send(prediction)
            }
        }
    }
}
