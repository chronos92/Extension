//
//  Exstension.swift
//  HippoBingo
//
//  Created by Boris Falcinelli on 13/11/15.
//  Copyright © 2015 Laboratorio Informatico. All rights reserved.


// CURRENT VERSION : 1.10
//

import Foundation
import UIKit
import MBProgressHUD
import AFNetworking
import CoreLocation

private var kAssociationKeyNextField : UInt8 = 0

func EXTLocalizedString(_ key:String, comment:String) -> String {
    return NSLocalizedString(key, tableName: "Extension", comment: comment)
}

typealias JSONObject = [String:AnyObject]

public let DocumentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first!

enum InfoEditType { case text,phone,nation,ivaNumber,email }

struct Info {
    
    var variableName : String
    var key : String
    var value : String
    var editType : InfoEditType
    
    init(variableName name : String = "", key k : String, value v : String, editType et : InfoEditType = .text) {
        variableName = name
        key = k
        value = v
        editType = et
    }
    
    func copy() -> Info {
        return Info(variableName: variableName,key: key, value: value, editType: editType)
    }
}

protocol SerializableType {
    var serializableProperties: [String: Any] { get }
    init (serializedProperties: [String: Any])
}

public enum Sex : Int32 {
    case male = 1
    case female = 2
    
    init(value : Int) { self = (value == 2) ? .female : .male }
    init(text : String) { self = (text.lowercased() == "f" || text.lowercased() == "femmina") ? .female : .male }
    
    var string : String {
        switch self {
        case .male : return EXTLocalizedString("Male", comment: "")
        case .female : return EXTLocalizedString("Female", comment: "")
        }
    }
    static var strings : [String] { return [NSLocalizedString("Male", comment: ""),NSLocalizedString("Female", comment: "")] }
    static var values : [Sex] { return [.male, .female] }
}

extension NSCoder {
    func decodeStringForKey(_ key : String) -> String {
        return decodeObject(forKey: key) as! String
    }
    func decodeOptionalStringForKey(_ key:String) -> String? {
        return decodeObject(forKey: key) as? String
    }
    @available(*,deprecated: 1.0,message: "Use decodeOptionalStringForKey instead")
    func decodeOptionStringForKey(_ key:String) -> String? {
        return decodeObject(forKey: key) as? String
    }
}

extension CGRect {
    var string : String { return  String(format:"{{x : %f, y : %f},%@}",origin.x,origin.y,size.string) }
    
    func CGRectWithOrigin(_ point : CGPoint) -> CGRect { return CGRectWithOrigin(x: point.x, y: point.y) }
    func CGRectWithOrigin(x : CGFloat? = nil, y : CGFloat? = nil) -> CGRect { return CGRect(x: x ?? origin.x, y: y ?? origin.y, width: size.width, height: size.height) }
    func CGRectWithSize(width w : CGFloat? = nil, height h : CGFloat? = nil) -> CGRect { return CGRect(x: origin.x, y: origin.y, width: w ?? size.width, height: h ?? size.height) }
    func CGRectWithOriginSum(x : CGFloat, y : CGFloat) -> CGRect { return CGRectWithSum(x: x, y: y, width: 0, height: 0) }
    func CGRectWithSizeSum(width w : CGFloat, height h : CGFloat) -> CGRect { return CGRectWithSum(x: 0, y: 0, width: w, height: h) }
    func CGRectWithSum(x : CGFloat, y : CGFloat, width w : CGFloat, height h : CGFloat) -> CGRect { return CGRect(x: origin.x + x, y: origin.y + y, width: size.width + w, height: size.height + h) }
    @available(*, deprecated: 1.0,message: "Use CGRectWithOrigin instead")
    func rectWithOrigin(_ point : CGPoint) -> CGRect {
        return rectWithOrigin(x: point.x, y: point.y)
    }
    @available(*, deprecated: 1.0,message: "Use CGRectWithOrigin instead")
    func rectWithOrigin(x : CGFloat? = nil, y : CGFloat? = nil) -> CGRect {
        return CGRect(x: x ?? origin.x, y: y ?? origin.y, width: size.width, height: size.height)
    }
    @available(*, deprecated: 1.0,message: "Use CGRectWithSize instead")
    func rectWithSize(width w : CGFloat? = nil, height h : CGFloat? = nil) -> CGRect { return CGRect(x: origin.x, y: origin.y, width: w ?? size.width, height: h ?? size.height) }
    @available(*, deprecated: 1.0,message: "Use CGRectWithSize instead")
    func rectWithOriginSum(x : CGFloat, y : CGFloat) -> CGRect { return rectWithSum(x: x, y: y, width: 0, height: 0) }
    @available(*, deprecated: 1.0,message: "Use CGRectWithSizeSum instead")
    func rectWithSizeSum(width w : CGFloat, height h : CGFloat) -> CGRect { return rectWithSum(x: 0, y: 0, width: w, height: h) }
    @available(*, deprecated: 1.0,message: "Use CGRectWithSum instead")
    func rectWithSum(x : CGFloat, y : CGFloat, width w : CGFloat, height h : CGFloat) -> CGRect { return CGRect(x: origin.x + x, y: origin.y + y, width: size.width + w, height: size.height + h) }
}

extension CGPoint {
    func CGPointWith(x xval : CGFloat? = nil, y yval : CGFloat? = nil) -> CGPoint { return CGPoint(x: xval ?? self.x, y: yval ?? self.y) }
    func CGPointWithSum(x xval : CGFloat? = nil, y yval : CGFloat? = nil) -> CGPoint {
        return CGPointWith(x: (xval ?? 0) + self.x , y: (yval ?? 0) + self.y)
    }
}

extension CGSize {
    var string : String { return String(format: "{width : %f, height : %f}", width,height) }
    func CGSizeWith(width w: CGFloat? = nil, height h : CGFloat? = nil) -> CGSize {
        return CGSize(width: w ?? width, height: h ?? height)
    }
}

extension IndexPath {
    var string : String { return "{ section : \(section), row : \(row) }" }
}

extension CLLocationDistance {
    var kilometers : CLLocationDistance { return self/1000 }
    var miles : CLLocationDistance { return self/0.62137 }
    func descriptionFormattedInRange(_ range : Range<Int>) -> String {
        switch self {
        case 0..<Double(range.lowerBound): return String(format: "< %.0d", range.lowerBound)
        case Double(range.lowerBound)..<Double(range.upperBound): return String(format: "%.0f", self)
        default: return String(format: "> %.0d", range.upperBound)
        }
    }
    
    
}

//MARK: - Date extensions
//MARK: NSDateComponents
extension DateComponents {
    /**
     - returns: (String) Nome del giorno nella settimana per la data impostata
     */
    var weekDayName : String { return DateFormatter().weekdaySymbols[self.weekday!-1] }
    /**
     - returns: (String) Nome del mese per la data impostata
     */
    var monthName : String { return DateFormatter().monthSymbols[self.month!-1] }
}
//MARK: NSDate
extension Date {
    /**
     - Parameters:
     - year: (Int) anno da impostare
     - day: (Int) giorno da impostare
     - hour: (Int) ore da impostare
     - minute: (Int) minuti da impostare
     - second: (Int) secondi da impostare
     - returns: (NSDate) data con i nuovi parametri impostati
     */
    @available(iOS 1.9,*)
    func dateBySetting(_ year : Int? = nil,day : Int? = nil , hour : Int? = nil, minute min : Int? = nil, second sec : Int? = nil) -> Date {
        var comp = currentCalendarDateComponent
        if let val = year { comp.year = val }
        if let val = day { comp.day = val }
        if let val = hour { comp.hour = val }
        if let val = min { comp.minute = val }
        if let val = sec { comp.second = val }
        
        debugPrint(comp)
        let new = Calendar.current.date(from: comp)!.localDate()
        return new
    }
    func localDate() -> Date {
        let tz = TimeZone.autoupdatingCurrent
        let seconds  = TimeInterval(tz.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    var currentCalendarDateComponent : DateComponents {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "GMT")!
        return (cal as NSCalendar).components([
            NSCalendar.Unit.year,
            NSCalendar.Unit.month,
            NSCalendar.Unit.day,
            NSCalendar.Unit.hour,
            NSCalendar.Unit.minute,
            NSCalendar.Unit.second,
            NSCalendar.Unit.weekday], from: self)
    }
    
    func isEqualOrGreaterYearMonthDay(_ date : Date) -> Bool {
        return self.isGreaterYearMonthDay(date) || self.isEqualYearMonthDay(date)
    }
    
    func isGreaterYearMonthDay(_ date : Date) -> Bool {
        let c1 = self.currentCalendarDateComponent
        let c2 = date.currentCalendarDateComponent
        guard c1.year! >= c2.year! else { return false }
        guard c1.year == c2.year else { return true }
        guard c1.month! >= c2.month! else { return false }
        guard c1.month == c2.month else { return true }
        guard c1.day! >= c2.day! else { return false }
        guard c1.day == c2.day else { return true }
        return false
        
    }
    
    func isEqualYearMonthDay(_ date : Date) -> Bool {
        let comp1 = self.currentCalendarDateComponent
        let comp2 = date.currentCalendarDateComponent
        return comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day
    }
    /**
     - parameter second: (Int) numero di secondi da aggiungere
     - returns: (NSDate) data con l'aggiunta di secondi
     */
    func dateByAddingSecond(_ second : Int) -> Date {
        return addingTimeInterval(TimeInterval(second))
    }
    /**
     - parameter second: (Int) numero di giorni da aggiungere
     - returns: (NSDate) data con l'aggiunta di giorni
     */
    func dateByAddingDay(_ day: Int) -> Date {
        return dateByAddingHour(24*day)
    }
    /**
     - parameter second: (Int) numero di ore da aggiungere
     - returns: (NSDate) data con l'aggiunta di ore
     */
    func dateByAddingHour(_ hour : Int) -> Date {
        return dateByAddingMinute(60*hour)
    }
    /**
     - parameter second: (Int) numero di minuti da aggiungere
     - returns: (NSDate) data con l'aggiunta di minuti
     */
    func dateByAddingMinute(_ min : Int) -> Date {
        return dateByAddingSecond(60*min)
    }
    /**
     - Parameters:
     - day: (Int) numero di giorni da aggiungere
     - hour: (Int) numero di ore da aggiungere
     - minute: (Int) numero di minuti da aggiungere
     - second: (Int) numero di secondi da aggiungere
     - returns: (NSDate) data con l'aggiunta di secondi
     */
    func dateByAdding(_ day : Int? = nil , hour : Int? = nil, minute min : Int? = nil, second sec : Int? = nil) -> Date {
        var date = self
        if day != nil { date = date.dateByAddingDay(day!) }
        if hour != nil { date = date.dateByAddingHour(hour!) }
        if min != nil { date = date.dateByAddingMinute(min!) }
        if sec != nil { date = date.dateByAddingSecond(sec!) }
        return date
    }
    
    func timeAgo(numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = (now as NSDate).earlierDate(self)
        let latest = (earliest == now) ? self : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        if (components.year! >= 2) {
            return "\(components.year) " + NSLocalizedString("YearsAgo", comment: "")
        } else if (components.year! >= 1){
            if (numericDates){
                return NSLocalizedString("1YearAgo", comment: "")
            } else {
                return NSLocalizedString("LastYear", comment: "")
            }
        } else if (components.month! >= 2) {
            return "\(components.month) " + NSLocalizedString("MonthsAgo", comment: "")
        } else if (components.month! >= 1){
            if (numericDates){
                return NSLocalizedString("1MonthAgo", comment: "")
            } else {
                return NSLocalizedString("LastMonth", comment: "")
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear) " + NSLocalizedString("WeeksAgo", comment: "")
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return NSLocalizedString("1WeekAgo", comment: "")
            } else {
                return NSLocalizedString("LastWeek", comment: "")
            }
        } else if (components.day! >= 2) {
            return "\(components.day) " + NSLocalizedString("DaysAgo", comment: "")
        } else if (components.day! >= 1){
            if (numericDates){
                return NSLocalizedString("1DayAgo", comment: "")
            } else {
                return NSLocalizedString("LastDay", comment: "")
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour) " + NSLocalizedString("HoursAgo", comment: "")
        } else if (components.hour! >= 1){
            if (numericDates){
                return NSLocalizedString("1HourAgo", comment: "")
            } else {
                return NSLocalizedString("LastHour", comment: "")
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute) " + NSLocalizedString("MinutesAgo", comment: "")
        } else if (components.minute! >= 1){
            if (numericDates){
                return NSLocalizedString("1MinuteAgo", comment: "")
            } else {
                return NSLocalizedString("LastMinute", comment: "")
            }
        } else if (components.second! >= 3) {
            return "\(components.second) " + NSLocalizedString("SecondsAgo", comment: "")
        } else {
            return NSLocalizedString("JustNow", comment: "")
        }
    }
    
    func stringWithFormat(_ format : String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    init?(string : String, dateFormat format : String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let val = formatter.date(from: string)
        if let date = val {
            let s = formatter.timeZone.secondsFromGMT(for: date)
            let interval = TimeInterval(s)
            self.init(timeInterval:interval,since: date)
        } else {
            return nil
        }
    }
}
//MARK: NSDateFormatter
extension DateFormatter {
    @available(*, deprecated: 1.0,message: "Use stringWithFormat: from the NSDate object instead")
    static func stringFromDate(_ date : Date, withFormat format : String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    @available(*, deprecated: 1.5,message: "Use string:dateFormat: from NSDate instead")
    static func dateFromString(_ text : String, withFormat format : String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(secondsFromGMT:0)
        let date = formatter.date(from: text)
        return date
        //        guard let date = formatter.dateFromString(text) else {
        //            assert(false, "No date from string")
        //            return nil
        //        }
        //        return date
    }
}


//MARK: - UIKit extensions
//MARK: UITextField
extension UITextField {
    @IBOutlet var nextField : UITextField? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}//MARK: UIColor
extension UIColor {
    convenience init(hexString: String) {
        // Trim leading '#' if needed
        var cleanedHexString = hexString
        if hexString.hasPrefix("#") {
            cleanedHexString = hexString.replacingOccurrences(of: "#", with: "")
        }
        // String -> UInt32
        var rgbValue: UInt32 = 0
        Scanner(string: cleanedHexString).scanHexInt32(&rgbValue)
        // UInt32 -> R,G,B
        let red = CGFloat((rgbValue >> 16) & 0xff) / 255.0
        let green = CGFloat((rgbValue >> 08) & 0xff) / 255.0
        let blue = CGFloat((rgbValue >> 00) & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /**
     Analizza i componenti del colore e ritorna la stringa esadecimale associata a quel colore
     - parameter includeAlpha: (Bool) nella stringa deve includere anche l'alpha oppure no
     - returns: (String) esadecimale del colore
     */
    public func hexString(_ includeAlpha: Bool) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        if (includeAlpha) {
            return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
}

//MARK: UIApplication
extension UIApplication {
    /**
     Prova ad aprire tutti gli url ricevuti.
     Quando riesce ad aprirne uno il metodo si ferma
     
     - param stringUrls : lista degli url da provare
     */
    @available(iOS 1.7,*)
    class func tryUrl(_ stringUrls: String...) {
        for urlString in stringUrls {
            if let url = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                    return
                }
            }
        }
    }
}

//MARK: UIAlertController
extension UIAlertController {
    
    static func alertControllerWithTryAgainAndAbort(_ title : String, andText text : String, tryAgainHandler : (()->Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: EXTLocalizedString("Abort", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: EXTLocalizedString("TryAgain", comment: ""), style: .default, handler: { (_) in
            tryAgainHandler?()
        }))
        return alert
    }
    
    @available(*,deprecated: 1.10,message: "User withOkButton(andTitle:andText:okHandler:)")
    static func alertControllerWithOkButtonAndTitle(_ title : String, andText text : String, okHandler : (()-> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (_) in
            okHandler?()
        }))
        //        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .Default, handler: nil))
        return alert
    }
    
    @available(iOS 1.10,*)
    static func withOkButton(andTitle title : String, andText text : String, okHandler : (()->Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { (_) in
            okHandler?()
        }))
        return alert
        
    }
    
    static func alertControllerWithYesNoButtonAndTitle(_ title : String, andText text : String, yesHandler : ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: EXTLocalizedString("Yes", comment: ""), style: .default, handler: yesHandler))
        alert.addAction(UIAlertAction(title: EXTLocalizedString("No", comment: ""), style: .cancel, handler: nil))
        return alert
    }
    
    static func alertControllerForChangeSettings(_ title : String? = nil, text : String? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title ?? EXTLocalizedString("Settings", comment: ""), message: text ?? EXTLocalizedString("SetPermission", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: EXTLocalizedString("Abort", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: EXTLocalizedString("Settings", comment: ""), style: .default, handler: { (_) in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }))
        return alert
    }
}

//MARK: UIView
extension UIView {
    @IBInspectable var borderWidth : CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor : UIColor? {
        get { return (self.layer.borderColor != nil) ? UIColor(cgColor: self.layer.borderColor!) : nil }
        set { self.layer.borderColor = (newValue != nil) ? newValue!.cgColor : nil }
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        get { return self.layer.cornerRadius }
        set {
            self.clipsToBounds = newValue > 0
            self.layer.cornerRadius = newValue
        }
    }
    
    @available(*, deprecated: 1.0, message: "Use cornerRadius property instead!")
    func roundCorner(cornerRadiusSize corner : CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = corner
    }
    @available(*, deprecated: 1.0, message: "Use cornerRadius property instead!")
    func circularCorner() {
        self.cornerRadius = max(self.frame.height, self.frame.width)/2
    }
}

//MARK: UIResponder
extension UIResponder {
    @nonobjc static weak var firstResponder : AnyObject?
    
    static func currentFirstResponder() -> AnyObject? {
        UIResponder.firstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return UIResponder.firstResponder
    }
    
    func findFirstResponder(_ sender : AnyObject) {
        UIResponder.firstResponder = self
    }
}

//MARK: UIButton
extension UIButton {
    @IBInspectable var backgroundImageTintColor : UIColor! {
        set {
            let oImg = self.backgroundImage(for: self.state)
            self.setBackgroundImage(oImg?.imageWithColor(newValue), for: self.state)
        }
        get {
            return self.tintColor
        }
    }
    
    @IBInspectable var imageTintColor : UIColor! {
        set {
            let oImg = self.image(for: self.state)
            self.setImage(oImg?.imageWithColor(newValue), for: self.state)
        }
        get {
            return self.tintColor
        }
    }
}
//MARK: UIWebView
extension UIWebView {
    func loadHTMLString(_ string: String, baseURL: URL?,font : UIFont, fontColor:UIColor? = nil) {
        let newString = String(format: "<span style=\"font-family:%@; font-size:%i; color:%@; width:95%%;\">%@</span>", font.fontName,Int(font.pointSize),(fontColor ?? UIColor.black).hexString(false),string)
        self.loadHTMLString(newString, baseURL: baseURL)
    }
}

//MARK: UIImageView
extension UIImageView {
    
    @IBInspectable var imageTintColor : UIColor {
        set {
            self.image = self.image?.imageWithColor(newValue)
            
        }
        get {
            return self.tintColor
        }
    }
    
    func setTintColorImage(_ color : UIColor) {
        self.image = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = color
    }
    
    func setImage(withPossibleURLs urls : [URL?], andPlaceholderImage placeholder : UIImage?) {
        self.image = nil
        guard !urls.isEmpty else {
            self.image = placeholder
            return
        }
        var urlsArray = urls
        if let currentUrl = urlsArray.removeFirst() {
            self.setImageWith(URLRequest(url: currentUrl), placeholderImage: nil, success: { (_, _, image) in
                self.image = image
                }, failure: { (_, _, _) in
                    self.setImage(withPossibleURLs: urlsArray, andPlaceholderImage: placeholder)
            })
        } else {
            self.setImage(withPossibleURLs: urlsArray, andPlaceholderImage: placeholder)
        }
    }
    
    func setImageWithLoadingIndicatorAndUrl(_ url:URL?, placeholderImage placeholder : UIImage?,indicatorColor : UIColor = UIColor.darkGray, success : ((_ image:UIImage)->Void)? = nil) {
        if url != nil {
            let response = AFImageResponseSerializer()
            var set = response.acceptableContentTypes ?? Set()
            set.insert("image/jpg")
            response.acceptableContentTypes = set
            UIImageView.sharedImageDownloader().sessionManager.responseSerializer = response
            let indicator = UIActivityIndicatorView(frame: self.frame)
            indicator.center = self.center
            indicator.tag = 999
            indicator.color = indicatorColor
            indicator.startAnimating()
            indicator.hidesWhenStopped = true
            self.addSubview(indicator)
            
            self.setImageWith(URLRequest(url: url!), placeholderImage: placeholder, success: { (_, _, image) -> Void in
                DispatchQueue.main.async(execute: {
                    let indic = self.viewWithTag(999) as? UIActivityIndicatorView
                    indic?.stopAnimating()
                    indic?.removeFromSuperview()
                    self.image = image
                    success?(image)
                })
                
            }) { (_, _, error) -> Void in
                DispatchQueue.main.async(execute: {
                    let indic = self.viewWithTag(999) as? UIActivityIndicatorView
                    indic?.stopAnimating()
                    indic?.removeFromSuperview()
                })
            }
        } else {
            NSLog("url image is nil")
            self.image = placeholder
        }
    }
}
//MARK: UIImage
extension UIImage {
    func imageWithColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0);
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
//MARK: UILabel
extension UILabel {
    var actualWidth : CGFloat {
        return intrinsicContentSize.width
    }
    
    var actualSize : CGFloat {
        let attributes = [NSFontAttributeName : self.font];
        let attributedString = NSAttributedString(string: self.text!, attributes: attributes)
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = self.minimumScaleFactor
        attributedString.boundingRect(with: self.bounds.size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: context)
        return self.font.pointSize * context.actualScaleFactor
    }
    var heightText : CGFloat { return (text != nil) ? UILabel.heightForView(self.text!, font: self.font, width: self.frame.width) : 0 }
    
    class func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        _ = (font.pointSize * 2)
        let val = label.frame.size.height + ((font.pointSize) * 2)
        return val
    }
    class func heightForView(_ attributedText : NSAttributedString, width : CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}
//MARK: UITableViewCell
extension UITableViewCell {
    open override var tintColor : UIColor! {
        set {
            self.backgroundColor = newValue
            self.subviews.forEach({ $0.backgroundColor = UIColor.clear })
            self.contentView.subviews.forEach({ $0.backgroundColor = UIColor.clear })
        }
        get { return self.backgroundColor }
    }
    public func set(titleText title : String, detailText detail : String? = nil, image : UIImage? = nil) -> UITableViewCell {
        self.textLabel?.text = title
        self.detailTextLabel?.text = detail
        self.imageView?.image = image
        return self
    }
}
//MARK: UITableView
extension UITableView {
    func scrollToBottom(AtScrollPosition position : UITableViewScrollPosition, animated : Bool) {
        if self.numberOfSections > 0 {
            let lastSection = self.numberOfSections-1
            self.scrollToRow(at: IndexPath(row: self.numberOfRows(inSection: lastSection)-1, section: lastSection), at: position, animated: animated)
        }
    }
    func scrollToTop(AtScrollPosition position : UITableViewScrollPosition, animated : Bool) {
        if self.numberOfSections > 0 && self.numberOfRows(inSection: 0) > 0 {
            self.scrollToRow(at: IndexPath(row: 0, section: 0), at: position, animated: animated)
        }
    }
}

extension UIDevice {
    static var isSimulator: Bool { return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil }
    var isIpad : Bool { return userInterfaceIdiom == .pad }
    var isIphone : Bool { return model == "iPhone" }
    var isIpod : Bool { return model == "iPod touch" }
}

//MARK: - Object type extensions

extension Int {
    @available(iOS 1.7,*)
    func next(inRange range : Range<Int>, restartAtLimit restart : Bool) -> Int {
        let newValue = self + 1
        guard !range.contains(newValue) else { return newValue }
        guard range.lowerBound < newValue else { return range.lowerBound }
        guard range.upperBound > newValue else { return restart ? range.lowerBound : range.upperBound }
        return newValue
    }
}

extension Array {
    @available(iOS 1.7,*)
    func random() -> Element? {
        guard !self.isEmpty else { return nil }
        let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
        return self[randomIndex]
    }
    
    /**
     controlla se nell'array è presente il valore e lo ritorna
     - parameter object: l'oggetto da rimuovere dall'array
     - returns : ritorna il valore rimosso
     */
    mutating func removeObject<U: Equatable>(_ object: U) -> Element? {
        for (idx, objectToCompare) in self.enumerated() {  //in old swift use enumerate(self)
            if let to = objectToCompare as? U {
                if object == to {
                    return self.remove(at: idx)
                }
            }
        }
        return nil
    }
    
    func stringWithSeparator(_ separator : String) -> String {
        guard !self.isEmpty else { return "" }
        guard ((self.first! as? String) != nil) else { return "" }
        var text = ""
        for (i,el) in self.enumerated() {
            text += el as! String
            if i != self.count-1 {
                text += separator
            }
        }
        return text
    }
    
}

extension Dictionary {
    /**
     effettua il merge dei due dictionary ritornandone il risultato
     - parameter dict: dictionary da inserire nell'attuale
     - parameter rewrite: (default true) se impostato su false non sovrascrive i valori se già esistenti
     - returns : (Dictionary)
     */
    func merge(_ dict:Dictionary,rewrite:Bool = true) -> Dictionary {
        var new = Dictionary()
        new.mergeInPlace(self,rewrite: rewrite)
        new.mergeInPlace(dict,rewrite: rewrite)
        return new
    }
    /**
     inserisce le coppie chiave -> valore del parametro in quello attuale
     se nel dictionary attuale esiste già la chiave il suo valore viene sostituito con quello del parametro
     - parameter dict: dictionary da inserire nell'attuale
     - parameter rewrite: (default true) se impostato su false non sovrascrive i valori se già esistenti
     */
    mutating func mergeInPlace(_ dict:Dictionary, rewrite:Bool = true) {
        dict.forEach { (object) in
            if self[object.key] == nil || (self[object.key] != nil && rewrite) {
                self.updateValue(object.value, forKey: object.key)
            }
        }
    }
}

extension Float {
    func roundToPlace(_ places : Int) -> Float {
        let divisor = Float(pow(10.0,Double(places)))
        let val = (self * divisor).rounded() / divisor
        return val
    }
    func stringWithComma(_ precision : Int,hideDecimalsIfZero hide : Bool = false) -> String {
        var newPrecision : Int = 2
        if hide {
            let decimal = self.truncatingRemainder(dividingBy: 1)
            if decimal.roundToPlace(2) > 0 {
                newPrecision = 2
            } else {
                newPrecision = 0
            }
        }
        return String(format: "%.\(newPrecision)f", self).replacingOccurrences(of: ".", with: ",")
    }
}

extension String {
    
    /**
     restituisce la stringa in formato HTML
     
     - returns: (NSAttributedString) stringa HTML
     */
    @available(iOS 1.7,*)
    func attributedHTMLText(WithFont font : UIFont) -> NSAttributedString {
        let newString = String(format: "<span style=\"font-family:%@; font-size:%i; width:95%%;\">%@</span>", font.fontName,Int(font.pointSize),self)
        let attributedOptions : [String: AnyObject] = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject,NSCharacterEncodingDocumentAttribute: String.Encoding.utf8 as AnyObject]
        let data = newString.data(using: String.Encoding.utf8)!
        do {
            return try NSAttributedString(data: data, options: attributedOptions, documentAttributes: nil)
        } catch {
            return NSAttributedString(string: self)
        }
    }
    
    func matchForRegex(_ regex : String!) -> Bool {
        do {
            let reg = try NSRegularExpression(pattern: regex, options: .dotMatchesLineSeparators)
            let val = reg.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSMakeRange(0, self.length))
            return val > 0
        } catch {
            return false
        }
    }
    
    /**
     converte la stringa in una stringa criptata in SHA1
     
     Inserire nel bridge: #import <CommonCrypto/CommonCrypto.h>
     
     - returns: (String) SHA1 string
     */
    @available(iOS 1.6,*)
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1((data as NSData).bytes, CC_LONG(data.count), &digest)
        let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        for byte in digest {
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
    
    /**
     converte la stringa in una stringa criptata in SHA256
     
     Inserire nel bridge: #import <CommonCrypto/CommonCrypto.h>
     
     - returns: (String) SHA256 string
     */
    @available(iOS 1.6,*)
    func sha256() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256((data as NSData).bytes, CC_LONG(data.count), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        
        return hexBytes.joined(separator: "")
    }
    
    /**
     stringa MD5 dell'oggetto
     
     Inserire nel bridge: #import <CommonCrypto/CommonCrypto.h>
     
     - returns: (String) MD5 string
     */
    var md5String: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate(capacity: digestLen)
        
        return String(format: hash as String)
    }
    /**
     controlla che la stringa è una email valida tramite le espressioni regolari
     - returns : (Bool)
     */
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    /**
     - returns : (String) ritorna la stringa con la prima lettera maiuscola
     */
    var capitalizeFirst:String {
        var result = self
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
        return result
    }
    /**
     - returns : (Int) numero di caratteri presenti nella stringa
     */
    var length : Int { return characters.count }
    subscript (i: Int) -> Character { return self[self.characters.index(self.startIndex, offsetBy: i)]}
    subscript (i: Int) -> String { return String(self[i] as Character)}
    subscript (r: Range<Int>) -> String { return substring(with: characters.index(startIndex, offsetBy: max(r.lowerBound,0)) ..< characters.index(startIndex, offsetBy: min(r.upperBound,length)))}
    /**
     rimuove i tag html dalla stringa
     
     - returns : (String) string without html tag
     */
    var stringWithoutTagHTML : String {
        get {
            let encodedData = self.data(using: String.Encoding.utf8)!
            let attributedOptions : [String: Any] = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue]
            do {
                let attributed = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                return attributed.string
            } catch let error {
                debugPrint(error)
                return ""
            }
        }
    }
    func decodeHTMLEntities() -> String{
        let encodedData = self.data(using: String.Encoding.utf8)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8 as AnyObject
        ]
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            return attributedString.string
        } catch {
            return ""
        }
    }
}

//MARK: - Custom object extensions

extension MBProgressHUD {
    convenience init(view : UIView, title : String?, detailText : String? = nil, mode : MBProgressHUDMode = MBProgressHUDMode.text, removePreviousHUD remove : Bool = true ) {
        self.init(frame:view.bounds)
        
        self.removeFromSuperViewOnHide = true
        self.mode = mode
        self.label.text = title ?? ""
        self.detailsLabel.text = detailText ?? ""
        //        self.center = view.center
        self.bezelView.color = UIColor.black
        self.contentColor = UIColor.white
        DispatchQueue.main.async { 
            if remove {
                if let hud = MBProgressHUD(for: view) {
                    hud.hide(animated: true)
                }
            }
            view.addSubview(self)
        }
    }
    
    func showWithImage(_ image : UIImage?, text : String? = nil, detailText detail : String? = nil, animated : Bool = true, hideAfterDelay delay : TimeInterval, handler : (() -> Void)? = nil) {
        self.removeFromSuperViewOnHide = true
        self.customView = UIImageView(image: image!)
        self.mode = MBProgressHUDMode.customView
        self.label.text = text ?? ""
        if detail != nil && detail != "" {
            self.detailsLabel.text = detail!
        }
        self.showAnimated(animated, hideAfterDelay: delay,handler: handler)
    }
    
    func showAnimated(_ animated : Bool, hideAfterDelay delay : TimeInterval, handler : (()->Void)? = nil) {
        self.removeFromSuperViewOnHide = true
        self.show(animated: animated)
        self.hide(animated: animated, afterDelay: delay)
        if handler != nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                handler!()
            })
        }
    }
    
    @available(iOS 1.4,*)
    func showCorrectAnimated(_ animated : Bool, hideAfterDelay delay : TimeInterval, handler : (()->Void)? = nil) {
        show(UIImage(named: "check_white_big")?.imageWithColor(UIColor.white), animated: animated, hideAfterDelay: delay, handler: handler)
    }
    @available(iOS 1.4,*)
    func showErrorAnimated(_ animated : Bool, hideAfterDelay delay : TimeInterval, handler : (()->Void)? = nil) {
        show(UIImage(named: "clear_white_big")?.imageWithColor(UIColor.white), animated: animated, hideAfterDelay: delay, handler: handler)
    }
    @available(iOS 1.4, *)
    func showInfoAnimated(_ animated : Bool, hideAfterDelay delay : TimeInterval, handler : (()->Void)? = nil) {
        show(UIImage(named: "info_outline_white_big")?.imageWithColor(UIColor.white), animated: animated, hideAfterDelay: delay, handler: handler)
    }
    internal func show(_ image : UIImage?, animated : Bool, hideAfterDelay delay : TimeInterval, handler : (() -> Void)? = nil) {
        self.mode = MBProgressHUDMode.customView
        self.customView = UIImageView(image: image)
        showAnimated(animated, hideAfterDelay: delay, handler: handler)
    }
    
    
    @available(*,deprecated: 1.3,message: "Use showCorrectAnimated(_:hideAfterDelay:handler:) instead")
    func showWithImageCorrect(_ animated : Bool = true, hideAfterDelay delay : TimeInterval, handler : (() -> Void)? = nil) {
        show(UIImage(named: "check_white_big")?.imageWithColor(UIColor.white), animated: animated, hideAfterDelay: delay, handler: handler)
    }
    @available(*,deprecated: 1.3,message: "Use showErrorAnimated(_:hideAfterDelay:handler:) instead")
    func showWithImageError(_ animated : Bool = true, hideAfterDelay delay : TimeInterval, handler : (() -> Void)? = nil) {
        show(UIImage(named: "clear_white_big")?.imageWithColor(UIColor.white), animated: animated, hideAfterDelay: delay, handler: handler)
    }
    @available(*,deprecated: 1.3,message: "Use showInfoAnimated(_:hideAfterDelay:handler:) instead")
    func showWithImageInfo(_ animated : Bool = true, hideAfterDelay delay : TimeInterval, handler : (() -> Void)? = nil) {
        show(UIImage(named: "info_outline_white_big")?.imageWithColor(UIColor.white), animated: animated, hideAfterDelay: delay, handler: handler)
    }
    @available(*, deprecated: 1.2, message: "Use showAnimated(_:,hideAfterDelay : , handler:)")
    func show(_ animated : Bool, hideAfterDelay delay : TimeInterval, handler : (() -> Void)? = nil) {
        //        MBProgressHUD.hideHUDForView(self.superview, animated: true)
        self.removeFromSuperViewOnHide = true
        self.show(animated)
        self.hide(animated, afterDelay: delay)
        if handler != nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                handler!()
            })
        }
    }
}


//func > (d1 : Date, d2 : Date) -> Bool { return d1.compare(d2) == ComparisonResult.orderedDescending}
//func < (d1 : Date, d2 : Date) -> Bool { return d1.compare(d2) == ComparisonResult.orderedAscending }
//func == (d1 : Date, d2 : Date) -> Bool { return d1.compare(d2) == ComparisonResult.orderedSame }
func >= (d1 : Date, d2 : Date) -> Bool { return d1 > d2 || d1 == d2 }
func <= (d1 : Date, d2 : Date) -> Bool { return d1 < d2 || d1 == d2 }

func >> (s1 : CGSize, s2 : CGSize) -> Bool {
    return s1.width > s2.width && s1.height > s2.height
}

func >  (s1 : CGSize, s2 : CGSize) -> Bool {
    return s1.width > s2.width || s1.height > s2.height
}
