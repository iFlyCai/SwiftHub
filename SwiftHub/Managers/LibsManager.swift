//
//  LibsManager.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import IQKeyboardManagerSwift
import CocoaLumberjack
import Kingfisher
#if DEBUG
import FLEX
#endif
import FirebaseCrashlytics
import NSObject_Rx
import RxViewController
import RxOptional
import RxGesture
import SwifterSwift
import SwiftDate
import Hero
import KafkaRefresh
import FirebaseCore
import DropDown
import Toast_Swift

typealias DropDownView = DropDown

/// 管理所有库的配置类
class LibsManager: NSObject {

    /// 默认的单例实例
    static let shared = LibsManager()

    // 用户默认设置中是否启用广告横幅
    let bannersEnabled = BehaviorRelay(value: UserDefaults.standard.bool(forKey: Configs.UserDefaultsKeys.bannersEnabled))

    private override init() {
        super.init()

        // 如果用户默认设置中没有广告设置项，则默认启用广告横幅
        if UserDefaults.standard.object(forKey: Configs.UserDefaultsKeys.bannersEnabled) == nil {
            bannersEnabled.accept(true)
        }

        // 当广告设置发生变化时，保存至UserDefaults，并更新Analytics
        bannersEnabled.skip(1).subscribe(onNext: { (enabled) in
            UserDefaults.standard.set(enabled, forKey: Configs.UserDefaultsKeys.bannersEnabled)
            analytics.set(.adsEnabled(value: enabled))  // 更新广告是否启用的分析数据
        }).disposed(by: rx.disposeBag)
    }

    /// 配置所有库的方法
    @MainActor func setupLibs() {
        let libsManager = LibsManager.shared
        libsManager.setupCocoaLumberjack()  // 配置CocoaLumberjack日志
        libsManager.setupAnalytics()        // 配置分析库
        libsManager.setupTheme()            // 配置主题
        libsManager.setupKafkaRefresh()     // 配置Kafka刷新控件
        libsManager.setupFLEX()             // 配置FLEX调试工具
        libsManager.setupKeyboardManager()  // 配置IQKeyboardManager
        libsManager.setupDropDown()         // 配置DropDown组件
        libsManager.setupToast()            // 配置Toast提示框
    }

    /// 配置主题
    func setupTheme() {
        UIApplication.shared.theme.statusBarStyle = themeService.attribute { $0.statusBarStyle }
    }

    /// 配置DropDown组件的样式
    func setupDropDown() {
        themeService.typeStream.subscribe(onNext: { (themeType) in
            let theme = themeType.associatedObject
            DropDown.appearance().backgroundColor = theme.primary
            DropDown.appearance().selectionBackgroundColor = theme.primaryDark
            DropDown.appearance().textColor = theme.text
            DropDown.appearance().selectedTextColor = theme.text
            DropDown.appearance().separatorColor = theme.separator
        }).disposed(by: rx.disposeBag)
    }

    /// 配置Toast提示框样式
    func setupToast() {
        ToastManager.shared.isTapToDismissEnabled = true  // 启用点击后关闭
        ToastManager.shared.position = .top  // Toast显示在顶部
        var style = ToastStyle()
        style.backgroundColor = UIColor.Material.red  // 设置背景色
        style.messageColor = UIColor.Material.white    // 设置消息文字颜色
        style.imageSize = CGSize(width: 20, height: 20)  // 设置图标大小
        ToastManager.shared.style = style
    }

    /// 配置Kafka刷新控件
    func setupKafkaRefresh() {
        if let defaults = KafkaRefreshDefaults.standard() {
            defaults.headDefaultStyle = .replicatorAllen  // 设置头部刷新样式
            defaults.footDefaultStyle = .replicatorDot    // 设置底部刷新样式
            defaults.theme.themeColor = themeService.attribute { $0.secondary }  // 设置主题色
        }
    }

    /// 配置IQKeyboardManager
    @MainActor func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true  // 启用键盘管理
    }

    /// 配置Kingfisher
    func setupKingfisher() {
        // 设置最大磁盘缓存大小，默认值为0表示不限制
        ImageCache.default.diskStorage.config.sizeLimit = UInt(500 * 1024 * 1024) // 500 MB

        // 设置磁盘缓存过期时间，默认值为1周
        ImageCache.default.diskStorage.config.expiration = .days(7) // 1周

        // 设置图片下载的超时时间，默认是15秒
        ImageDownloader.default.downloadTimeout = 15.0 // 15秒
    }

    /// 配置CocoaLumberjack日志
    func setupCocoaLumberjack() {
        DDLog.add(DDOSLogger.sharedInstance)  // OS层级日志
        let fileLogger: DDFileLogger = DDFileLogger() // 文件日志
        fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24小时滚动一次
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7  // 最多保存7个日志文件
        DDLog.add(fileLogger)  // 添加文件日志
    }

    /// 配置FLEX调试工具（仅限调试环境）
    func setupFLEX() {
        #if DEBUG
        FLEXManager.shared.isNetworkDebuggingEnabled = true  // 启用网络调试
        #endif
    }

    /// 配置Firebase分析库，并初始化Mixpanel（如果需要）
    func setupAnalytics() {
        FirebaseApp.configure()  // 配置Firebase
//        Mixpanel.initialize(token: Keys.mixpanel.apiKey, trackAutomaticEvents: true)  // 初始化Mixpanel（需要API密钥）
        FirebaseConfiguration.shared.setLoggerLevel(.min)  // 设置Firebase的日志级别
    }
}

extension LibsManager {

    /// 显示FLEX调试工具
    func showFlex() {
        #if DEBUG
        FLEXManager.shared.showExplorer()  // 显示FLEX的调试界面
        analytics.log(.flexOpened)  // 记录调试界面的打开事件
        #endif
    }

    /// 清除Kingfisher的缓存
    func removeKingfisherCache() -> Observable<Void> {
        return ImageCache.default.rx.clearCache()  // 清除缓存
    }

    /// 获取Kingfisher缓存的大小
    func kingfisherCacheSize() -> Observable<Int> {
        return ImageCache.default.rx.retrieveCacheSize()  // 获取缓存大小
    }
}
