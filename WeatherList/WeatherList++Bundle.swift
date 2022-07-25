//
//  WeatherList++Bundle.swift
//  WeatherList
//
//  Created by 윤성호 on 2022/07/26.
//

import Foundation

extension Bundle {
    var apiKey: String {
        // appInfo.plist 찾기
        guard let file = self.path(forResource: "AppInfo", ofType: "plist") else { return "" }
        
        // 해당 딕셔너리 찾기
        guard let resouce = NSDictionary(contentsOfFile: file) else { return "" }
        
        // API_KEY 찾기
        guard let key = resouce["API_KEY"] as? String else { fatalError("AppInfo.plist에서 API_KEY를 설정해주세요.") }
        
        return key
    }
}
