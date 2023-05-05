//
//  Type.swift
//  Pods
//
//  Created by Anatoliy Voropay on 6/8/16.
//  Copyright © 2016 Anatoliy Voropay. All rights reserved.
//

import UIKit

/// Device types
///
/// - Parameter phone:
/// - Parameter pad:
/// - Parameter pod:
/// - Parameter simulator:
/// - Parameter unknown
public enum Type: String {
    case phone
    case pad
    case pod
    case simulator
    case unknown
}

/// Exact device version
public enum Version: String {
    case phone4
    case phone4S
    case phone5
    case phone5C
    case phone5S
    case phone6
    case phone6Plus
    case phone6S
    case phone6SPlus
    case phoneSE
    case phone7
    case phone7Plus
    case phone8
    case phone8Plus
    case phoneX
    case phoneXS
    case phoneXSMax
    case phoneXR
    case phone11
    case phone11Pro
    case phone11ProMax
    case phoneSE2
    case phone12Mini
    case phone12
    case phone12Pro
    case phone12ProMax
    
    case pad1
    case pad2
    case padMini
    case pad3
    case pad4
    case pad5
    case pad6
    case pad7
    case padAir
    case padMini2
    case padAir2
    case padMini3
    case padMini4
    case padMini5
    case padAir3
    case padPro9_7
    case padPro12_9
    case padPro12_9_2th
    case padPro10_5
    case padPro11
    case padPro12_9_3th
    case padPro11_2th
    case padPro12_9_4th
    
    case podTouch1
    case podTouch2
    case podTouch3
    case podTouch4
    case podTouch5
    case podTouch6
    case podTouch7
    
    case simulator
    
    case unknown
    
    /// Return device screen
    ///
    /// - seealso: Screen
    public var screen: Screen {
        switch self {
        case .podTouch1,
             .podTouch2,
             .podTouch3,
             .podTouch4,
             .phone4,
             .phone4S:
            return .inches_3_5
            
        case .podTouch5,
             .podTouch6,
             .podTouch7,
             .phone5,
             .phone5C,
             .phone5S,
             .phoneSE:
            return .inches_4_0
            
        case .phone6,
             .phone6S,
             .phone7,
             .phone8,
             .phoneSE2:
            return .inches_4_7
            
        case .phone12Mini:
            return .inches_5_4
            
        case .phone6Plus,
             .phone6SPlus,
             .phone7Plus,
             .phone8Plus:
            return .inches_5_5
            
        case .phoneX,
             .phoneXS,
             .phone11Pro:
            return .inches_5_8
            
        case .phoneXR,
             .phone11,
             .phone12,
             .phone12Pro:
            return .inches_6_1
            
        case .phoneXSMax,
             .phone11ProMax:
            return .inches_6_5
            
        case .phone12ProMax:
            return .inches_6_7
            
        case .padMini,
             .padMini2,
             .padMini3,
             .padMini4,
             .padMini5:
            return .inches_7_9
            
        case .pad1,
             .pad2,
             .pad3,
             .pad4,
             .pad5,
             .pad6,
             .padAir,
             .padAir2,
             .padPro9_7:
            return .inches_9_7
        case .pad7:
            return .inches_4_7
            
        case .padPro12_9,
             .padPro12_9_2th,
             .padPro12_9_3th,
             .padPro12_9_4th:
            return .inches_12_9
            
        case .padPro10_5,
             .padAir3:
            return .inches_10_5;
            
        case .padPro11, .padPro11_2th:
            return .inches_11
        case .unknown, .simulator:
            return .unknown
        }
    }
}

/// Used to determinate device type
extension Device {
    
    /// Return raw device version code string or empty string if any problem appears.
    static public var versionCode: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        if  let info = NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue),
            let code = String(validatingUTF8: info.utf8String!) {
            return code
        }
        
        return ""
    }
    
    /// Return device type
    ///
    /// - seealso: Type
    static public var type: Type {
        let versionCode = Device.versionCode
        if versionCode.starts(with: "iPhone") {
            return .phone
        } else if versionCode.starts(with: "iPad") {
            return .pad
        } else if versionCode.starts(with: "iPod") {
            return .pod
        } else if versionCode == "i386" || versionCode == "x86_64" {
            return .simulator
        }
        return .unknown
    }
    
    /// Return `true` for iPad-s
    static public var isPad: Bool {
        return ( UIDevice.current.userInterfaceIdiom == .pad )
    }
    
    /// Return `true` for iPhone-s
    static public var isPhone: Bool {
        return !isPad
    }
    
    /// Return `true` for iPhoneX
    @available(*, deprecated, message: ".isPhoneX deprecated. Use .isNotched instead")
    static public var isPhoneX: Bool {
        return isPhone && screen == .inches_5_8
    }

    /// Return `true` for iPadPro
    static public var isPadPro: Bool {
        return isPad && screen == .inches_12_9
    }
    
    /// Return `true` for Simulator
    static public var isSimulator: Bool {
        return type == .simulator
    }
    
    /// Return `true` if device has a notch
    @available(*, deprecated, message: ".isNotched deprecated for iPhone 14 Pro. Use .isSafeAreaDevice instead")
    static public var isNotched: Bool {
        return isPhone && (screen == .inches_5_8 || screen == .inches_6_1 || screen == .inches_6_5 || screen == .inches_5_4 || screen == .inches_6_7)
    }

    static public var isSafeAreaPhone: Bool {
        return Device.isPhone && isSafeAreaDevice
    }

    static public var isSafeAreaPad: Bool {
        return Device.isPad && isSafeAreaDevice
    }

    static public var isSafeAreaDevice: Bool {
        // above iOS11 dont have safe area
        guard #available(iOS 11.0, *) else { return false }

        guard let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets else {
            return false
        }

        // iOS11 top value is 0,but iOS12 top is 20.
        let hasSafeArea = (safeAreaInsets.top != 0 && safeAreaInsets.top != 20) || safeAreaInsets.bottom != 0 || safeAreaInsets.left != 0 || safeAreaInsets.right != 0
        return  hasSafeArea
    }
    
    // MARK: Version
    static public var version: Version {
        let versionCode = Device.versionCode
        
        switch versionCode {
        // Phones
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            return .phone4
            
        case "iPhone4,1", "iPhone4,2", "iPhone4,3":
            return .phone4S
            
        case "iPhone5,1", "iPhone5,2":
            return .phone5
            
        case "iPhone5,3", "iPhone5,4":
            return .phone5C
            
        case "iPhone6,1", "iPhone6,2":
            return .phone5S
            
        case "iPhone7,2":
            return .phone6
            
        case "iPhone7,1":
            return .phone6Plus
            
        case "iPhone8,1":
            return .phone6S
            
        case "iPhone8,2":
            return .phone6SPlus
            
        case "iPhone8,4":
            return .phoneSE
            
        case "iPhone9,1", "iPhone9,3":
            return .phone7
            
        case "iPhone9,2", "iPhone9,4":
            return .phone7Plus
            
        case "iPhone10,1", "iPhone10,4":
            return .phone8
            
        case "iPhone10,2", "iPhone10,5":
            return .phone8Plus
            
        case "iPhone10,3", "iPhone10,6":
            return .phoneX
            
        case "iPhone11,2":
            return .phoneXS
            
        case "iPhone11,4", "iPhone11,6":
            return .phoneXSMax
            
        case "iPhone11,8":
            return .phoneXR
            
        case "iPhone12,1":
            return .phone11
        case "iPhone12,3":
            return .phone11Pro
        case "iPhone12,5":
            return .phone11ProMax
        case "iPhone12,8":
            return .phoneSE2
            
        case "iPhone13,1":
            return .phone12Mini
        case "iPhone13,2":
            return .phone12
        case "iPhone13,3":
            return .phone12Pro
        case "iPhone13,4":
            return .phone12ProMax
            
        // Pads
        case "iPad1,1":
            return .pad1
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return .pad2
            
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return .pad3
            
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return .pad4
            
        case "iPad6,11", "iPad6,12":
            return .pad5
            
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return .padAir
            
        case "iPad5,3", "iPad5,4":
            return .padAir2
            
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return .padMini
            
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return .padMini2
            
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return .padMini3
            
        case "iPad5,1", "iPad5,2":
            return .padMini4
            
        case "iPad6,3", "iPad6,4":
            return .padPro9_7
            
        case "iPad6,7", "iPad6,8":
            return .padPro12_9
            
        case "iPad7,1", "iPad7,2":
            return .padPro12_9_2th
            
        case "iPad7,3", "iPad7,4":
            return .padPro10_5
            
        case "iPad7,5", "iPad7,6":
            return .pad6
            
        case "iPad7,11", "iPad7,12":
            return .pad7
            
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":
            return .padPro11
            
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":
            return .padPro12_9_3th
            
        case "iPad8,9", "iPad8,10":
            return .padPro11_2th
            
        case "iPad8,11", "iPad8,12":
            return .padPro12_9_4th
            
        case "iPad11,1", "iPad11,2":
            return .padMini5
            
        case "iPad11,3", "iPad11,4":
            return  .padAir3
            
        // Pods
        case "iPod1,1":
            return .podTouch1
            
        case "iPod2,1":
            return .podTouch2
            
        case "iPod3,1":
            return .podTouch3
            
        case "iPod4,1":
            return .podTouch4
            
        case "iPod5,1":
            return .podTouch5
            
        case "iPod7,1":
            return .podTouch6
        case "iPod9,1":
            return .podTouch7
            
        // Simulator
        case "i386", "x86_64":
            return .simulator
            
        // Unknown
        default:
            return .unknown
        }
    }
}
