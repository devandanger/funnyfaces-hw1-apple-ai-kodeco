import SwiftUI

struct RealtimeCameraView: View {
  @StateObject private var model = CameraController()
  @State private var showDebugPanel: Bool = false
  @StateObject private var modelProvider: ModelProvider = ModelProvider.shared

  var body: some View {
      ZStack {
          FrameView(image: model.frame)
              .edgesIgnoringSafeArea(.all)
          if case .found(_) = model.found {
              VStack {
                  ObjectFoundView()
                  Spacer()
              }
          } else {
              
          }
        if modelProvider.faceObservations.count > 0 {
          ForEach(modelProvider.faceObservations, id: \.uuid) { observation in
            Circle()
              .stroke(style: StrokeStyle(lineWidth: 2))
              .frame(width: 10, height: 10)
              .position(x: observation.boundingBox.midX, y: observation.boundingBox.midY)
          }
        }
        ErrorView(error: model.error)
      }

  }
}

#Preview {
    CameraView()
}
