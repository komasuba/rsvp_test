import SwiftUI
import AsyncAlgorithms
import Combine

struct RSVPView: View {
    @State private var currentIndex: Int = 0
    @State private var isPlaying: Bool = false
    @State private var speed: Double = 0.5 // 初期速度
    @State private var fontSize: Double = 75 // 初期フォントサイズ
    let inputString: String
    
    var words: [String] {
        tokenizeText(inputString)
    }
    
    var onCompletion: (() -> Void)? = nil
    
    var body: some View {
        VStack {
            // 文字表示領域
            VStack {
                // 上の文字
                if currentIndex > 0 {
                    Text(words[currentIndex - 1])
                        .font(.system(size: fontSize))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                } else {
                    Text("")
                        .font(.system(size: fontSize))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .multilineTextAlignment(.center)
                }
                
                // 真ん中の文字
                Text(currentIndex < words.count ? words[currentIndex] : "")
                    .font(.system(size: fontSize))
                    .bold()
                    .multilineTextAlignment(.center)
                
                // 下の文字
                if currentIndex < words.count - 1 {
                    Text(words[currentIndex + 1])
                        .font(.system(size: fontSize))
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .multilineTextAlignment(.center)
                } else {
                    Text("")
                        .font(.system(size: fontSize))
                        .foregroundColor(.clear)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxHeight: .infinity)
            
            // スライダーとボタンを下部に固定
            VStack {
                HStack {
                    withAnimation{
                        if isPlaying == false {
                            Button(action: {
                                isPlaying = true
                                //                                playRSVP()
                                RSVPmove()
                            }) {
                                HStack {
                                    Image(systemName: "play")
                                        .foregroundColor(Color(UIColor.secondaryLabel))
                                    Spacer()
                                    Text("開始")
                                    Spacer()
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.systemBackground))
                                .foregroundColor(Color(UIColor.label))
                                .cornerRadius(24)
                            }
                        } else {
                            Button(action: {
                                isPlaying = false
                            }) {
                                HStack {
                                    Image(systemName: "stop")
                                        .foregroundColor(Color(UIColor.secondaryLabel))
                                    Spacer()
                                    Text("停止")
                                    Spacer()
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.systemBackground))
                                .foregroundColor(Color(UIColor.label))
                                .cornerRadius(24)
                            }
                        }
                    }
                }
                .padding()
                
                // スピード調整スライダー
                VStack {
                    Text("速度: \(String(format: "%.3f", speed)) 秒/単語")
                    Slider(value: $speed, in: 0.001...0.100, step: 0.001)
                        .padding()
                }
                
                // フォントサイズ調整スライダー
                VStack {
                    Text("フォントサイズ: \(Int(fontSize))")
                    Slider(value: $fontSize, in: 1...150, step: 1)
                        .padding()
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
        }
        .onAppear {
            currentIndex = 0
        }
    }
    
    func RSVPmove() {
        Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
            guard isPlaying else {
                timer.invalidate()
                return
            }
            if currentIndex < words.count - 1 {
                currentIndex += 1
            } else {
                timer.invalidate()
                onCompletion?()
            }
        }
    }
}



#Preview {
    RSVPView(inputString: "こちら、下痢便のスープスパゲッティになります。こちら、下痢便のスープスパゲッティになります。こちら、下痢便のスープスパゲッティになります。こちら、下痢便のスープスパゲッティになります。こちら、下痢便のスープスパゲッティになります。こちら、下痢便のスープスパゲッティになります。こちら、下痢便のスープスパゲッティになります。こちら、下痢便のスープスパゲッティになります。こちら、下痢便のスープスパゲッティになります。こちら、下痢便のスープスパゲッティになります。")
}
