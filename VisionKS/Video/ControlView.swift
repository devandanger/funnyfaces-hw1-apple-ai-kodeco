import SwiftUI

struct ControlView: View {
  @Binding var showDebugPanel: Bool
//    @Binding var comicSelected: Bool
//    @Binding var monoSelected: Bool
//    @Binding var crystalSelected: Bool
  @Binding var visionModelSelected: Bool
  @Binding var detectFaces: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Spacer()
                Button {
                    showDebugPanel.toggle()
                } label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
            .padding(10)
            Spacer()
            HStack(spacing: 12) {
                ToggleButton(selected: $visionModelSelected, label: "Vision Model")
            }
            HStack(spacing: 12) {
              ToggleButton(selected: $detectFaces, label: "Detect Faces")
//                ToggleButton(selected: $monoSelected, label: "Mono")
//                ToggleButton(selected: $crystalSelected, label: "Crystal")
            }
        }
    }
}

struct ControlView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
        Color.black
            .edgesIgnoringSafeArea(.all)

        ControlView(
            showDebugPanel: .constant(false),
            visionModelSelected: .constant(false),
            detectFaces: .constant(false)
        )
    }
  }
}
