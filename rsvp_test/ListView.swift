//import SwiftUI
//import SwiftData
//
//struct ListsView: View {
//    @State private var currentIndex: Int = 0
//    @State private var isPlaying: Bool = false
//    @State private var speed: Double = 0.5 // 初期速度
//    @State private var fontSize: Double = 75 // 初期フォントサイズ
//    //    let words: [String]
//    //    var onCompletion: (() -> Void)? = nil
//    @Environment(\.modelContext) var modelContext
//    @Query var recipes: [Recipe]
//    
//    var body: some View {
//        List{
//            ForEach(recipes){ recipe in
//                VStack(alignment: .leading){
//                    Text(recipe.name)
//                }
//            }
//        }
//        Button("add", action: addSamples)
//    }
//    func addSamples(){
//        let rome = Recipe(name: "Rome")
//        modelContext.insert(rome)
//    }
//}
