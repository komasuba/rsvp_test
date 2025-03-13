import SwiftUI

struct ChildView: View {
    @Binding var isToggled: Bool // 親ビューから状態のバインディングを受け取る
    
    var body: some View {
        Toggle("スイッチ", isOn: $isToggled) // 状態を変更する
    }
}
