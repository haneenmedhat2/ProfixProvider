//
//  PaymentWebViewController.swift
// NewBase
//
//  Created by Mohamed Hadwa on 10/07/2025.
//
import UIKit
import WebKit

class PaymentWebViewController: UIViewController, WKNavigationDelegate {
    
//    var url: URL!
//    private var webView: WKWebView!
//    
//    var onPaymentAccepted: VoidCompletion?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        title = "Payment".localized
//      
//        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            title: "Cancel".localized,
//            style: .plain,
//            target: self,
//            action: #selector(cancelTapped)
//        )
//        
//        webView = WKWebView(frame: view.bounds)
//        webView.navigationDelegate = self
//        view.addSubview(webView)
//        
//        let request = URLRequest(url: url)
//        webView.load(request)
//    }
//    
//    @objc private func cancelTapped() {
//        dismiss(animated: true)
//    }
//    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
//                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        
//        if let urlStr = navigationAction.request.url?.absoluteString {
//            
//            if urlStr.contains("orders/accepted-form") {
//                print("✅ Payment Accepted! URL: \(urlStr)")
//                
//                dismiss(animated: true) {
//                    self.onPaymentAccepted?()
//                }
//                
//                decisionHandler(.cancel)
//                return
//            }
//            else if urlStr.contains("/payment/get-payment-status") {
//                print("✅ Navigated to Payment Status URL: \(urlStr)")
//                
//                dismiss(animated: true) {
//                    print("🚀 Executing another action because user navigated to payment status URL")
//                    
//                    self.onPaymentAccepted?()
//                }
//                
//                decisionHandler(.cancel)
//                return
//            }
//        }
//        
//        decisionHandler(.allow)
//    }
}

class WebViewController: UIViewController, WKNavigationDelegate {

    private var webView: WKWebView!
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupWebView()
        setupNavigationBar()
        loadURL()
    }

    private func setupWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupNavigationBar() {
        title = "invoice".localized

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                barButtonSystemItem: .action,
                target: self,
                action: #selector(shareTapped)
            )
        ]
    }

    private func loadURL() {
        guard let urlString,
              let url = URL(string: urlString) else { return }

        webView.load(URLRequest(url: url))
    }

    // MARK: - Share / Download

    @objc private func shareTapped() {
        generatePDFfromWebView()
    }
    
    private func generatePDFfromWebView() {
        let config = WKPDFConfiguration()
        
        webView.createPDF(configuration: config) { [weak self] result in
            switch result {
            case .success(let data):
                let fileURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent("invoice.pdf")

                do {
                    try data.write(to: fileURL)
                    self?.showShareSheet(fileURL: fileURL)
                } catch {
                    print("PDF save error:", error)
                }

            case .failure(let error):
                print("PDF generation error:", error)
            }
        }
    }
    
    
    private func showShareSheet(fileURL: URL) {
        let activityVC = UIActivityViewController(
            activityItems: [fileURL],
            applicationActivities: nil
        )

        present(activityVC, animated: true)
    }
}
