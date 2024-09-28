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
              comicSelected: $model.comicFilter,
              monoSelected: $model.monoFilter,
              crystalSelected: $model.crystalFilter, visionModelSelected: $model.visionModelSelected
          )
      }
//        .sheet(isPresented: $showDebugPanel) {
//            DebugPanelView(labels: $model.labels)
//        }
  }
}

#Preview {
    CameraView()
}
