//
//  ThemeSettings.swift
//  Todo App
//
//  Created by Stanly Shiyanovskiy on 22.04.2021.
//

import SwiftUI

final public class ThemeSettings: ObservableObject {
    
    @Published
    public var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet {
            UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
        }
    }
    
    private init() {}
    public static let shared = ThemeSettings()
}
