import Foundation
import NaturalLanguage
import SwiftUI
import SwiftData

struct MainMenu2: View {
    
    @State private var inputText: String = ""
    @State private var tokens: String = ""
    @State private var showDocumentPicker = false
    @State private var isShowingSheet = false
    @State private var webView = WebView(url: URL(string: "https://google.com")!)
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var isSheetPresented = true
    @State private var selectedDetent: PresentationDetent = .fraction(0.1)
    @State private var shouldNavigate : Bool = false
    @State private var cutNavigate : Bool = false
    @FocusState private var isFocused: Bool
    @State private var isMenuVisible = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var animateColors = false
    
    @Environment(\.modelContext) var modelContext
    @Query var destination: [Destination]
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                //headerview
                HStack(spacing: 0){
                    Button(action: {
                        isShowingSheet = true
                    }) {
                        Image(systemName: "list.bullet")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color(UIColor.label), Color(UIColor.systemGray3))
                            .font(.system(size: 24, weight: .thin))
                    }
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isMenuVisible.toggle()
                        }
                    }) {
                        Image(systemName: "gear.circle")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color(UIColor.label), Color(UIColor.systemGray3))
                            .font(.system(size: 24, weight: .thin))
                    }
                }
                .padding()
                
                //webview
                webView
                    .cornerRadius(24)
                
                //webview Control
                HStack (spacing: 0){
                    
                    Button(action: {
                        webView.webView.goBack()
                    }) {
                        Image(systemName: "arrow.backward.circle")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color(UIColor.systemBlue), Color.clear)
                            .font(.system(size: 36, weight: .thin))
                    }
                    .disabled(!canGoBack)
                    
                    Button(action: {
                        webView.webView.goForward()
                    }) {
                        Image(systemName: "arrow.forward.circle")
                            .foregroundStyle(Color(UIColor.systemBlue), Color.clear)
                            .font(.system(size: 36, weight: .thin))
                    }
                    .disabled(!canGoForward)
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        webView.webView.reload()
                    }) {
                        Image( "custom.arrow.trianglehead.clockwise.rotate.90.circle")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color(UIColor.systemBlue), Color.clear)
                            .font(.system(size: 36, weight: .thin))
                    }
                }
                .padding()
                
                //textfield & tools
                VStack(spacing: 0){
                    
                    //textfield
                    HStack(spacing: 0){
                        TextField("テキストを入力してください", text: $inputText, axis: .vertical)
                        Button(action: {
                            inputText = ""
                        }) {
                            Image(systemName: inputText.isEmpty ? "xmark.circle" : "xmark.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(inputText.isEmpty ? Color(UIColor.systemGray2) : .red)
                                .font(.system(size: 36, weight: .thin))
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .disabled(inputText.isEmpty)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .focused($isFocused)
                    
                    //tools
                    HStack(spacing: 0){
                        
                        // txt file input button
                        Button(action: {
                            showDocumentPicker = true
                        }) {
                            Image(systemName: "plus.circle")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color(UIColor.label), Color(UIColor.systemGray3))
                                .font(.system(size: 36, weight: .thin))
                        }
                        
                        
                        //web text get button
                        Button {
                            webView.getWebPageText{ text in
                                if let content = text {
                                    inputText = content
                                    tokens = inputText
                                    shouldNavigate = true
                                }
                            }
                        } label: {
                            Image("custom.globe.circle.2")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color(UIColor.label), Color(UIColor.systemGray3))
                                .font(.system(size: 36, weight: .thin))
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        // words cut button
                        NavigationStack {
                            VStack {
                                Button {
                                    tokens = inputText
                                    cutNavigate = true
                                } label: {
                                    Image(systemName: inputText.isEmpty ? "scissors.circle" : "scissors.circle.fill")
                                }
                                .disabled(inputText.isEmpty)
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 36, weight: .thin))
                                .contentTransition(.symbolEffect(.replace))
                            }
                            .navigationDestination(isPresented: $cutNavigate) {
                                RSVPView(inputString: tokens)
                            }
                        }
                    }
                    .padding()
                }
                .background(Color(UIColor.systemGray6))
                .clipShape(
                    .rect(
                        topLeadingRadius: 24,
                        topTrailingRadius: 24
                    )
                )
                // End VStack textfield & button
            }
            .onReceive(webView.webView.publisher(for: \.canGoBack)) { canGoBack in
                self.canGoBack = canGoBack
            }
            .onReceive(webView.webView.publisher(for: \.canGoForward)) { canGoForward in
                self.canGoForward = canGoForward
            }
            .ignoresSafeArea(edges: isFocused ? .horizontal : .bottom)
            .background(Color(UIColor.systemBackground))
            .sheet(isPresented: $showDocumentPicker) {
                DocumentPicker { url in
                    importTextFile(from: url)
                }
            }
            .sheet(isPresented: $isShowingSheet
                   /*,onDismiss: didDismiss*/) {
                NavigationStack{
                    List{
                        ForEach(destination){ re in
                            NavigationLink(value: re){
                                VStack(alignment: .leading){
                                    Text(re.name)
                                        .font(.headline)
                                    Text(re.date.formatted(date: .long, time: .shortened))
                                    Button("Show", action: addSamples)
                                }
                            }
                            
                        }
                        .onDelete(perform: deleteDestinations)
                    }
                    .navigationTitle("履歴")
                    .navigationDestination(for: Destination.self, destination: editDestination.init)
                    .toolbar{
                        Button("Add Samples", action: addSamples)
                    }
                }
            }
        }
    }
    
    func addSamples(){
        let rome = Destination(name: "Rome")
        let florence = Destination(name: "Florence")
        let naples = Destination(name: "Naples")
        modelContext.insert(rome)
        modelContext.insert(florence)
        modelContext.insert(naples)
    }
    
    func deleteDestinations(_ indexSet: IndexSet) {
        for index in indexSet {
            let destination = destination[index]
            modelContext.delete(destination)
        }
    }
    
    func didDismiss() {
        // Handle the dismissing action.
    }
    
    private func importTextFile(from url: URL) {
        let isAccessing = url.startAccessingSecurityScopedResource() //SandBox外ファイルへのアクセスをシステムに通知
        defer { //deferはスコープを抜ける時に実行される
            if isAccessing {//Trueだったらstopさせ、リソースリークを防ぐ
                url.stopAccessingSecurityScopedResource()
            }
        }
        do {
            let text = try String(contentsOf: url, encoding: .shiftJIS)
            inputText = text
        } catch {
            print("ファイルの読み込みに失敗しました: \(error.localizedDescription)")
        }
    }
}
