import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    let webView = WKWebView()

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // ページ読み込み完了時の処理
        }
        
        
    }
    
    func getWebPageText(completion: @escaping (String?) -> Void) {
            let js = "document.body.innerText"
            webView.evaluateJavaScript(js) { result, error in
                if let text = result as? String, error == nil {
                    completion(text)
                } else {
                    completion(nil)
                }
            }
        }
}

