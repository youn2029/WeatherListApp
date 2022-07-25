//
//  WeatherTableViewCell.swift
//  WeatherList
//
//  Created by 윤성호 on 2022/07/24.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    // MARK: - 초기값 설정
    var lbldate = UILabel().then {
        $0.text = "날짜"
        $0.font = .systemFont(ofSize: 15)
    }
    
    var imgWeather = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "01d")
//        $0.backgroundColor = .blue
    }
    
    var lblWeather = UILabel().then {
        $0.text = "날씨 정보"
        $0.font = .systemFont(ofSize: 15)
    }
    
    lazy var tempView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 8
        
        $0.addArrangedSubview(lblMax)
        $0.addArrangedSubview(lblMaxTemp)
        $0.addArrangedSubview(lblMin)
        $0.addArrangedSubview(lblMinTemp)
    }
    
    var lblMax = UILabel().then {
        $0.text = "Max"
        $0.font = .systemFont(ofSize: 15)
    }
    
    var lblMaxTemp = UILabel().then {
        $0.text = "0℃"
        $0.font = .systemFont(ofSize: 15)
    }
    
    var lblMin = UILabel().then {
        $0.text = "Min"
        $0.font = .systemFont(ofSize: 15)
    }
    
    var lblMinTemp = UILabel().then {
        $0.text = "0℃"
        $0.font = .systemFont(ofSize: 15)
    }
    
    // MARK: - setting init & autoLayout
    private func setInitView() {
        self.addSubview(lbldate)
        self.addSubview(imgWeather)
        self.addSubview(lblWeather)
        self.addSubview(tempView)
    }
    
    private func setAutoLayout(){
        
        lbldate.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).inset(7)
            $0.leading.equalTo(self.snp.leading).inset(20)
            $0.height.equalTo(15)
            $0.width.equalTo(200)
        }
        
        imgWeather.snp.makeConstraints{
            $0.top.equalTo(lbldate.snp.bottom).inset(-5)
            $0.leading.equalTo(self.snp.leading).inset(20)
            $0.height.width.equalTo(40)
        }

        lblWeather.snp.makeConstraints{
            $0.leading.equalTo(imgWeather.snp.trailing).inset(-3)
            $0.bottom.equalTo(imgWeather.snp.bottom).inset(7)
        }
        
        tempView.snp.makeConstraints{
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.bottom.equalTo(imgWeather.snp.bottom).inset(7)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setInitView()
        self.setAutoLayout()
    }

}
