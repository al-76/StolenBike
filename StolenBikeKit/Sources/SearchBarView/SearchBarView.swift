//
//  SwiftUIView.swift
//  
//
//  Created by Vyacheslav Konopkin on 16.03.2023.
//

import SwiftUI
import UIKit

public struct SearchBarView: UIViewRepresentable {
    private let placeholder: String
    fileprivate var text: Binding<String>

    public init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self.text = text
    }

    public func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = placeholder
        searchBar.delegate = context.coordinator
        searchBar.text = text.wrappedValue
        return searchBar
    }

    public func updateUIView(_ uiView: UISearchBar, context: Context) {
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(searchBarView: self)
    }
}

final public class Coordinator: NSObject, UISearchBarDelegate {
    private var searchBarView: SearchBarView

    init(searchBarView: SearchBarView) {
        self.searchBarView = searchBarView
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarView.text.wrappedValue = searchText
    }
}


struct SearchBarViewTest: View {
    @State private var text = "test"

    var body: some View {
        VStack {
            SearchBarView("Type something...", text: $text)
            Text(text)
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    @State private var text = ""

    static var previews: some View {
        SearchBarViewTest()
    }
}
