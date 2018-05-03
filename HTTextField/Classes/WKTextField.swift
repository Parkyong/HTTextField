 //
//  WKTextFieldA.swift
//  TYYCache
//
//  Created by Hunta_Developer on 2018/4/26.
//  Copyright © 2018年 Hunta. All rights reserved.
//

import UIKit
import SnapKit

public protocol WKTextFieldDelegate {
    func wkTextFieldDidBeginEditing(_ textField: UITextField)
    func wkTextFieldDidEndEditing(_ textField: UITextField)
    func wkTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)
    func wkTextFieldShouldReturn(_ textField: UITextField) -> Bool
    func wkTextFieldShouldClear(_ textField: UITextField) -> Bool
}

public extension WKTextFieldDelegate{
    func wkTextFieldDidBeginEditing(_ textField: UITextField){}
    func wkTextFieldDidEndEditing(_ textField: UITextField){}
    func wkTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String){}
    func wkTextFieldShouldReturn(_ textField: UITextField) -> Bool{
        return true
    }
    func wkTextFieldShouldClear(_ textField: UITextField) -> Bool{
        return true
    }
}

//共同
public struct WKTextFieldCommonConfig{
    //输入框内边距
    public var TextPadding = 0.0
    //出错时是否需要抖动
    public var needShake:Bool = true
    //限制字数 normal时 有效
    public var limitCharacterCount = 100
}

//电话
public struct WKTextFieldPhoneConfig{
    //下划线正常颜色
    public var NormalLineColor:UIColor = WKColor.kRGBColorFromHex(rgbValue:0xEBEBEB)
    //下划线出错颜色
    public var ErrorLineColor:UIColor = WKColor.kRGBColorFromHex(rgbValue:0xFE664F)
    //限制字数 normal时 有效
    fileprivate var limitCharacterCount = 13
    //下划线离输入框距离
    public var TextWithUnderLineGap = 1.0
    //下划线高度
    public var UnderLineHeight = 1.0
}

//codeVerify
public struct WKTextFieldCodeVerifyConfig{
    //一个输入框定宽
    public var fixWidth = 50.0
    //需要几个输入
    public var inputNum = 6
    //聚焦颜色
    public var focusColor = UIColor.red
    //聚焦正常颜色
    public var focusNormalColor = UIColor.clear
    //聚焦borderWidth
    public var focusBoderWidth:CGFloat = 2.0
}

//config
public struct WKTextFieldConfig{
    //输入框类型
    public var type:WKTextFieldType = .kNormal
    public var commonConfig:WKTextFieldCommonConfig = WKTextFieldCommonConfig()
    public var phoneConfig:WKTextFieldPhoneConfig = WKTextFieldPhoneConfig()
    public var codeVerifyConfig:WKTextFieldCodeVerifyConfig = WKTextFieldCodeVerifyConfig()
    public init() {
    
    }
}

public enum WKTextFieldType:Int {
    case kNormal = 0            //正常输入框
    case kPhone                 //手机输入框
    case kCodeVerify            //手机验证码输入框
}

public class WKTextField: UIView, UITextFieldDelegate {
    fileprivate var isConstraints:Bool = false
    fileprivate var underLine:UIView!
    fileprivate var baseView:UIView!
    fileprivate var container:Array<UILabel> = Array<UILabel>()
    
    public var textField:UITextField!
    //请继承BaseCodeLabel  重写属性 并且赋值给codeLabel
    public var codeTemplateLabel:BaseCodeLabel = BaseCodeLabel()
    //代理
    public var delegate:WKTextFieldDelegate?
    
    //出错条件
    public var errorFilter:((String)->(Bool))?
    //出错标示
    public var isError:Bool = false{
        didSet{
            if !isError{
                self.underLine.backgroundColor = self.config.phoneConfig.NormalLineColor
                if self.config.type == .kCodeVerify{
                    var iterator = self.baseView.subviews.makeIterator()
                    while let label = iterator.next(){
                        (label as! BaseCodeLabel).setNormalColor()
                    }
                }
            }else{
                self.underLine.backgroundColor = self.config.phoneConfig.ErrorLineColor
                if self.config.type == .kCodeVerify{
                    var iterator = self.baseView.subviews.makeIterator()
                    while let label = iterator.next(){
                        (label as! BaseCodeLabel).setErrorColor()
                    }
                }
                self.shakeStart()
            }
        }
    }

    func setUpCodeVerifyTextFieldUI(){
        if self.config.type != .kCodeVerify {
            return
        }
        let count = config.codeVerifyConfig.inputNum
        self.removeSubviewsFromBaseView()
        var temp:UILabel?
        let width = self.frame.size.width
        let inputCount = self.config.codeVerifyConfig.inputNum
        let fixWidth = self.config.codeVerifyConfig.fixWidth
        var spacing:CGFloat = 0.0
        if inputCount < 1 {
            config.type = .kNormal
            return
        }
        if inputCount == 1  {
            spacing = (width   - CGFloat(fixWidth)  * CGFloat(inputCount))/2.0
        } else if inputCount > 1 {
            spacing = (width - CGFloat(fixWidth) * CGFloat(inputCount))/CGFloat((inputCount-1))
        }
        assert(spacing > 0, "请更改fixWidth 或则 inputNum")

        for index in 0..<count {
            let label =  codeTemplateLabel.createLabel()
            
            self.baseView.addSubview(label)
            if index == 0{
                if inputCount == 1{
                    label.snp.makeConstraints({ (make) in
                        make.top.equalTo(self.baseView)
                        make.left.equalTo(spacing)
                        make.bottom.equalToSuperview()
                        make.right.equalTo(-spacing)
                        make.width.equalTo(fixWidth)
                    })
                }else{
                    label.snp.makeConstraints({ (make) in
                        make.top.equalTo(self.baseView)
                        make.left.equalTo(0)
                        make.bottom.equalToSuperview()
                        make.width.equalTo(fixWidth)
                    })
                }
            }else if index == count - 1{
                label.snp.makeConstraints({ (make) in
                    make.top.equalTo(self.baseView)
                    make.left.equalTo((temp?.snp.right)!).offset(spacing)
                    make.bottom.equalToSuperview()
                    make.width.equalTo(config.codeVerifyConfig.fixWidth)
                    make.right.equalTo(0)
                })
            }else{
                label.snp.makeConstraints({ (make) in
                    make.top.equalTo(self.baseView)
                    make.left.equalTo((temp?.snp.right)!).offset(spacing)
                    make.bottom.equalToSuperview()
                    make.width.equalTo(fixWidth)
                })
            }
            temp = label
        }
    }
    
    //删除子试图
    func removeSubviewsFromBaseView(){
        var iterator = self.baseView.subviews.makeIterator()
        while let label = iterator.next()  {
            (label as! UILabel).removeFromSuperview()
        }
    }
    
    //配置
    public var config:WKTextFieldConfig = WKTextFieldConfig(){
        didSet{
            switch config.type {
                case .kNormal:
                    self.textField.keyboardType = .default
                    self.underLine.isHidden = true
                    self.baseView.isHidden = true
                case .kPhone:
                    self.textField.keyboardType = .numberPad
                    self.underLine.isHidden = false
                    self.baseView.isHidden = true
                case .kCodeVerify:
                    self.textField.keyboardType = .numberPad
                    self.underLine.isHidden = true
                    self.baseView.isHidden = false
                    self.textField.placeholder = ""
            }
        }
    }
    
    public func updateViews(){
        self.setUpCodeVerifyTextFieldUI()
        self.isConstraints = false
        self.setNeedsUpdateConstraints()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        setUpCodeVerifyTextFieldUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//布局
    func setUpUI(){
        self.textField = UITextField()
        self.textField.leftView = UIView(frame:CGRect(x: 0, y: 0, width: self.config.commonConfig.TextPadding, height: 0))
        self.textField.leftViewMode = UITextFieldViewMode.always
        self.textField.delegate = self
        self.textField.backgroundColor = UIColor.clear
        
        self.underLine = UIView()
        self.underLine.backgroundColor = self.config.phoneConfig.NormalLineColor
        
        self.baseView = UIView()
        self.baseView.backgroundColor = .white
        
        self.addSubview(self.textField)
        self.addSubview( self.underLine)
        self.addSubview(self.baseView)
        self.setNeedsUpdateConstraints()
    }
    
    override public func updateConstraints() {
        if !isConstraints {
            self.baseView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            
            self.textField.snp.remakeConstraints({ (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                if config.type == .kNormal || config.type == .kCodeVerify{
                    make.bottom.equalToSuperview()
                }else{
                    make.bottom.equalTo(self).offset(self.config.phoneConfig.TextWithUnderLineGap)
                }
            })
            
            self.underLine.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(self.config.phoneConfig.UnderLineHeight)
            })
            isConstraints = true
        }
        super.updateConstraints()
    }
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.textField
    }
    
//shack 开始
    func shakeStart() {
        if !config.commonConfig.needShake {
            return
        }
        let animation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.duration = 0.2
        animation.repeatCount = 2
        let delta = 20;
        animation.values = [0,-delta,delta,0]
        self.layer.add(animation, forKey: "shakeAnimation")
    }
    
//shack 结束
    func shakeEnd() {
        self.layer.removeAllAnimations()
    }
    
//更新验证码
    func updateCodeVerifyView(str:String){
        if str.count > config.codeVerifyConfig.inputNum{
            return
        }
        
        for index in 0..<config.codeVerifyConfig.inputNum{
            let label = self.baseView.subviews[index]
            let range:NSRange = NSRange.init(location: index, length: 1)
            if str.count-1 >= index{
                (label as! UILabel).text = (str as NSString).substring(with: range)
            }else{
                (label as! UILabel).text = nil
            }
            label.layer.borderWidth = config.codeVerifyConfig.focusBoderWidth
            label.layer.borderColor = config.codeVerifyConfig.focusNormalColor.cgColor
            if str.count < config.codeVerifyConfig.inputNum{
                if index == str.count{
                    label.layer.borderWidth = config.codeVerifyConfig.focusBoderWidth
                    label.layer.borderColor = config.codeVerifyConfig.focusColor.cgColor
                }
            }
        }
    }
    
//代理
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.shakeEnd()
        if self.config.type == .kCodeVerify {
            let currentIndex = textField.text?.count
            for (index, label) in self.baseView.subviews.enumerated(){
                if currentIndex == index {
                    label.layer.borderWidth = config.codeVerifyConfig.focusBoderWidth
                    label.layer.borderColor = config.codeVerifyConfig.focusColor.cgColor
                    }else{
                    label.layer.borderWidth = config.codeVerifyConfig.focusBoderWidth
                    label.layer.borderColor = config.codeVerifyConfig.focusNormalColor.cgColor
                }
                (label as! BaseCodeLabel).setNormalColor()
            }
        }
        self.delegate?.wkTextFieldDidBeginEditing(textField)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if self.errorFilter != nil {
            self.isError = self.errorFilter!(textField.text!)
        }
        if self.config.type == .kCodeVerify {
            var iterator = self.baseView.subviews.makeIterator()
            while let label = iterator.next()  {
                if label.isKind(of: BaseCodeLabel.self){
                    label.layer.borderWidth = config.codeVerifyConfig.focusBoderWidth
                    label.layer.borderColor = config.codeVerifyConfig.focusNormalColor.cgColor
                }
            }
        }
        
        self.delegate?.wkTextFieldDidEndEditing(textField)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        self.delegate?.wkTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
        let oldStr = textField.text! as NSString
        let newFStr = oldStr.replacingCharacters(in: range, with: string)
        
        if self.config.type == .kNormal {
            return newFStr.count <= self.config.commonConfig.limitCharacterCount
        } else if self.config.type == .kPhone {
            if (range.location == 3 && range.length == 0) ||
                (range.location == 8 && range.length == 0){
                textField.text = oldStr.replacingCharacters(in: range, with:" ")
                return true
            }
            if (range.location == 3 && range.length == 1) ||
                (range.location == 8 && range.length == 1){
                textField.text = oldStr.replacingCharacters(in: range, with:"")
            }
            return newFStr.count <= self.config.phoneConfig.limitCharacterCount
        }else if self.config.type == .kCodeVerify{
            self.updateCodeVerifyView(str:newFStr)
            return newFStr.count <= self.config.codeVerifyConfig.inputNum
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return (self.delegate?.wkTextFieldShouldReturn(textField))!
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return (self.delegate?.wkTextFieldShouldClear(textField))!
    }
}

