//
//  FilePicker.swift
// NewBase
//
//  Created by Mohamed Hadwa on 20/02/2024.
//

import UIKit
import UniformTypeIdentifiers

class DocumentPicker: NSObject, UIDocumentPickerDelegate {
    
    typealias FilePickerCallback = (String, Data) -> Void
    private var callback: FilePickerCallback?
    
    private var documentPicker: UIDocumentPickerViewController?
    
    func pickFile(with callback: @escaping FilePickerCallback) {
        self.callback = callback
        
        // إنشاء الـ picker وتعيين delegate
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        picker.delegate = self
        picker.allowsMultipleSelection = false
        self.documentPicker = picker

        // عرض الـ picker من أعلى شاشة
        if let topVC = SceneDelegate.current?.window?.topViewController() {
            topVC.present(picker, animated: true, completion: nil)
        }
    }

    // MARK: - Delegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first,
              url.startAccessingSecurityScopedResource() else { return }

        defer {
            url.stopAccessingSecurityScopedResource()
        }

        let filename = url.lastPathComponent
        
        do {
            let data = try Data(contentsOf: url)
            callback?(filename, data)
        } catch {
            print("❌ Error reading file: \(error)")
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("❌ Document picker was cancelled.")
    }
}
