import SwiftUI

struct ParentView: View {
    @State private var isToggled: Bool = false
    
    var body: some View {
        VStack {
            Text("親ビューのスイッチ状態: \(isToggled ? "ON" : "OFF")")
            ChildView(isToggled: $isToggled) // @Binding を使用して親の状態を渡す
        }
    }
}



struct ParentViewPreview: PreviewProvider {
    static var previews: some View{
        ParentView()
    }
}
