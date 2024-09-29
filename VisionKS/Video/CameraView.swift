import SwiftUI

struct RealtimeCameraView: View {
  @StateObject private var model = CameraController()
  @State private var showDebugPanel: Bool = false

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
          ErrorView(error: model.error)
          ControlView(
            showDebugPanel: $showDebugPanel,
            visionModelSelected: $model.visionModelSelected,
            detectFaces: $model.detectFaces
          )
      }

  }
}

#Preview {
    CameraView()
}
