//
//  ViewController.swift
//  WeatherList
//
//  Created by 윤성호 on 2022/07/21.
//

import UIKit
import Then
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - 초기값 세팅
    // 날씨 정보 관련 Model
    let weatherModel = WeatherModel()
    
    // 지역 정보
    var weatherListForCountry:[(country:String, weather:[weatherVO])] = [("Seoul", [weatherVO]()),
                                                             ("London", [weatherVO]()),
                                                             ("Chicago", [weatherVO]())]
    
    // 날씨 Table
    private lazy var weatherTable = UITableView(frame: .zero, style: .plain).then {
//        $0.backgroundColor = .white
        $0.separatorInset.left = 0
        $0.separatorInset.right = 0
        $0.tableFooterView = UIView()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        // 날씨 정보 가져오기
        for row in weatherListForCountry.enumerated() {
            var facthList = [weatherVO]()
            weatherModel.facthNowWeather(country: row.element.country) { vo in
                facthList.append(vo)
            }
            
            weatherModel.facthWeatherList(country: row.element.country) { list in
                facthList.append(contentsOf: list)
                self.weatherListForCountry[row.offset].weather = facthList
                self.weatherTable.reloadData()
            }
        }
        
        setInitView()
        setAutoLayout()
    }
    
    // MARK: - setting init & autoLayout
    func setInitView() {
        
        weatherTable.delegate = self
        weatherTable.dataSource = self
        self.view.addSubview(weatherTable)
    }
    
    // setting autoLayout
    func setAutoLayout(){
        
        weatherTable.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - TableView Delegate & DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 세션 갯수 설정
    func numberOfSections(in tableView: UITableView) -> Int {
        return weatherListForCountry.count
    }
    
    // 테이블 row 갯수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherListForCountry[section].weather.count
    }
    
    // 세션 View 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let topLineView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 1.5))
        topLineView.backgroundColor = .black
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        titleView.layer.borderColor = UIColor.black.cgColor
        titleView.backgroundColor = .white

        let lblTitle = UILabel(frame: CGRect(x: 20, y: 1.5, width: self.view.bounds.width-10, height: 27))
        lblTitle.font = .systemFont(ofSize: 20)
        lblTitle.text = weatherListForCountry[section].country
        
        let bottomLineView = UIView(frame: CGRect(x: 0, y: 28.5, width: self.view.bounds.width, height: 1.5))
        bottomLineView.backgroundColor = .black
        
        titleView.addSubview(topLineView)
        titleView.addSubview(lblTitle)
        titleView.addSubview(bottomLineView)

        return titleView
    }
    
    // 테이블 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vo = weatherListForCountry[indexPath.section].weather[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCall") as? WeatherTableViewCell else {
            let cell = WeatherTableViewCell(style: .default, reuseIdentifier: "weatherCell")
            cell.lbldate.text = indexPath.row >= 2 ? vo.date : (indexPath.row == 0 ? "Today" : "Tomorrow")
            cell.lblWeather.text = vo.weather
            cell.imgWeather.image = UIImage(named: "\(vo.icon)")
            cell.lblMaxTemp.text = "\(vo.tempMax)℃"
            cell.lblMinTemp.text = "\(vo.tempMin)℃"
            
            return cell
        }
        
        cell.lbldate.text = indexPath.row >= 2 ? vo.date : (indexPath.row == 0 ? "Today" : "Tomorrow")
        cell.lblWeather.text = vo.weather
        cell.imgWeather.image = UIImage(named: "\(vo.icon)")
        cell.lblMaxTemp.text = "\(vo.tempMax)℃"
        cell.lblMinTemp.text = "\(vo.tempMin)℃"
        
        return cell
    }
    
    // 테이블 cell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // cell 선택 시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
}
