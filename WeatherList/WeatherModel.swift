//
//  WeartherModel.swift
//  WeatherList
//
//  Created by 윤성호 on 2022/07/24.
//

import Foundation
import Alamofire

// MARK: - 날씨 정보 VO
class weatherVO {
    var date: String        // 날짜
    var weather: String     // 날씨
    var icon: String        // 날씨 이미지
    var tempMax: Int        // 최고 온도
    var tempMin: Int        // 최저 온도
    
    init() {
        self.date = ""
        self.weather = ""
        self.icon = ""
        self.tempMax = 0
        self.tempMin = 0
    }
}

// MARK: - 날씨 Model
class WeatherModel {
    
    // 날씨 API KEY
    let WEATHER_API_KEY: String = Bundle.main.apiKey
    
    // MARK: - facth
    // 현재 시간의 날씨 가져오기
    public func facthNowWeather(country : String, completion completionHandler: ((weatherVO) -> Void)?) {
        
        // url과 parameter 설정
        // https://api.openweathermap.org/data/2.5/weather?q=London&units=metric&cnt=6&appid=f35bb64b2f372f89127bb9760d4d20b9
        let weatherNowUrl = "https://api.openweathermap.org/data/2.5/weather"
        
        guard let url = URL(string: weatherNowUrl) else { return }
        let param = ["q":country, "units":"metric", "appid":WEATHER_API_KEY] as Dictionary
        
        // api 통신
        AF.request(url,
                   method: .get,
                   parameters: param,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
          .validate(statusCode: 200..<300)
          .responseJSON { (response) in
              
              switch response.result
              {
              //통신성공
              case .success(let value):
                  
                  DispatchQueue.main.async {
                                    
                      let results = value as! NSDictionary
                      
                      // 날씨 정보 VO
                      let weatherVo = weatherVO()
                      let dt = results["dt"] as! Double
                      weatherVo.date =  Date(timeIntervalSince1970: dt).toString(dateFormat: "EEE d MMM")
                      
                      let weatherArr = results["weather"] as! NSArray
                      let weather = weatherArr[0] as! NSDictionary
                      weatherVo.weather = weather["main"] as! String    // 날씨
                      weatherVo.icon = weather["icon"] as! String   //아이콘
                      
                      let main = results["main"] as! NSDictionary
                      weatherVo.tempMax = Int(main["temp_max"] as! NSNumber)    // 최고 온도
                      weatherVo.tempMin = Int(main["temp_min"] as! NSNumber)    // 최저 온도
                          
                      if let completion = completionHandler {
                          completion(weatherVo)
                      }
                  }
                  
              //통신실패
              case .failure(let error):
                  print("error: \(String(describing: error.errorDescription))")
              }
        }
    }
    
    // 하루단위로 날씨 가져오기
    public func facthWeatherList(country : String, completion completionHandler: (([weatherVO]) -> Void)?) {
        
        // url과 parameter 설정
        // https://api.openweathermap.org/data/2.5/forecast?q=London&units=metric&cnt=6&appid=f35bb64b2f372f89127bb9760d4d20b9
        let weatherListUrl = "https://api.openweathermap.org/data/2.5/forecast"
        
        guard let url = URL(string: weatherListUrl) else { return }
        let param = ["q":country, "units":"metric", "appid":WEATHER_API_KEY] as Dictionary
        
        // api 통신
        AF.request(url,
                   method: .get,
                   parameters: param,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
          .validate(statusCode: 200..<300)
          .responseJSON { (response) in
              
              switch response.result
              {
              //통신성공
              case .success(let value):
                  
                  DispatchQueue.main.async {
                                    
                      let results = value as! NSDictionary
                      
                      let list = results["list"] as! NSArray
                      
                      // 날씨 정보 VO List
                      var resultList = [weatherVO]()
                      
                      for info in list {
                          
                          let infoDic = info as! NSDictionary
                          let dt = infoDic["dt"] as! Double
                          
                          // 하루 단위로 날짜 체크
                          if self.isDayWeather(dt, dayValue: resultList.count+1) {
                              
                              let weatherVo = weatherVO()
                              weatherVo.date = Date(timeIntervalSince1970: dt).toString(dateFormat: "EEE d MMM")    // 날짜
                              
                              let weatherArr = infoDic["weather"] as! NSArray
                              let weather = weatherArr[0] as! NSDictionary
                              weatherVo.weather = weather["main"] as! String    // 날씨
                              weatherVo.icon = weather["icon"] as! String   //아이콘
                              
                              let main = infoDic["main"] as! NSDictionary
                              weatherVo.tempMax = Int(main["temp_max"] as! NSNumber)    // 최고 온도
                              weatherVo.tempMin = Int(main["temp_min"] as! NSNumber)    // 최저 온도
                              
                              resultList.append(weatherVo)
                          }
                      }
                      
                      if let completion = completionHandler {
                          completion(resultList)
                      }
                  }
                  
              //통신실패
              case .failure(let error):
                  print("error: \(String(describing: error.errorDescription))")
              }
        }
    }
    
    // MARK: - method
    // 하루 단위로 날짜를 가져오기 위해 날짜를 체크
    func isDayWeather(_ dt: Double, dayValue value: Int) -> Bool{
        let date = Date(timeIntervalSince1970: dt)
        let dateFormat = date.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        
        let nowDate = Date()
        let nextDay = Calendar.current.date(byAdding: .day, value: value, to: nowDate)! // 1, 2, 3  +Day 한 날짜
        let befor3hNextDay = Calendar.current.date(byAdding: .hour, value: -3, to: nextDay)!    // Day - 3H를 한 날짜
        
        // 분, 초를 짜를 DayFormat
        let nextDayFormat = nextDay.toString(dateFormat: "yyyy-MM-dd HH:00:00")
        let befor3hNextDayFormat = befor3hNextDay.toString(dateFormat: "yyyy-MM-dd HH:00:00")
        
        // +Day -3H의 날짜보다 크거나 같고 AND +Day 보다 작거나 같은 날짜 체크
        return befor3hNextDayFormat <= dateFormat && dateFormat <= nextDayFormat
    }
}

// MARK: - DataFormat 변환
extension Date {
    
    // dataFormat - EG
    func toString( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale(identifier: "eg")
        return dateFormatter.string(from: self)
    }
}
