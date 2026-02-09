//
//  ExpandableTextView.swift
//  TransactionList
//
//  Created by Maysam Shahsavari on 2026-02-05.
//

import SwiftUI

struct ExpandableTextView: View {
    @State private var isExpanded = false
    private let expandableLinkURL = URL(string: "expandable://toggle")!
    let texts: [String]
    let onLinkTap: () -> Void
    
    init(texts: [String], onLinkTap: @escaping () -> Void = {}) {
        self.texts = texts
        self.onLinkTap = onLinkTap
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(attributedContent)
                .environment(\.openURL, OpenURLAction { url in
                    if url == expandableLinkURL {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            isExpanded.toggle()
                        }
                        onLinkTap()
                        return .handled
                    }
                    return .systemAction(url)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
    private var visibleText: String {
        guard !texts.isEmpty else { return "" }
        if isExpanded {
            return texts.joined(separator: " ")
        } else {
            return texts[0]
        }
    }
    
    private var canExpand: Bool {
        texts.count > 1
    }
    
    private var attributedContent: AttributedString {
        if canExpand {
            let linkText = isExpanded ? "Show less" : "Show more"
            var attributed = AttributedString("\(visibleText) \(linkText)")
            if let range = attributed.range(of: linkText) {
                attributed[range].link = expandableLinkURL
                attributed[range].font = .body.bold()
                attributed[range].foregroundColor = .blue
            }
            return attributed
        } else {
            return AttributedString(visibleText)
        }
    }
}

#Preview {
    ExpandableTextView(
        texts: [
            "Transactions are processed Monday to Friday (excluding holidays).",
            "\nPlease allow 1-2 business days for processing."
        ]
    )
}
