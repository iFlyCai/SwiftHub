# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

use_frameworks!
inhibit_all_warnings!

target 'SwiftHub' do
    # Pods for SwiftHub
    
    # 网络请求
    pod 'Moya/RxSwift', '~> 15.0'  # Moya 是一个网络请求库，RxSwift 使它与响应式编程（Rx）兼容
    pod 'Apollo', '0.53.0'  # Apollo 是一个 GraphQL 客户端，用于和 GitHub API 交互

    # Rx 扩展库
    pod 'RxDataSources', '~> 5.0'  # 用于支持 RxSwift 数据源（TableView/CollectionView）的响应式编程
    pod 'RxSwiftExt', '~> 6.0'  # 扩展 RxSwift 的功能，提供额外的操作符和工具
    pod 'NSObject+Rx', '~> 5.0'  # 为 NSObject 类添加 RxSwift 支持
    pod 'RxViewController', '~> 2.0'  # 为 ViewController 添加 RxSwift 支持，简化视图与模型的绑定
    pod 'RxGesture', '~> 4.0'  # 用 RxSwift 封装手势识别
    pod 'RxOptional', '~> 5.0'  # RxSwift 的可选项扩展，提供更好的可选类型操作
    pod 'RxTheme', '~> 6.0'  # RxSwift 的主题管理库，用于动态切换主题

    # JSON 映射
    pod 'Moya-ObjectMapper/RxSwift', :git => 'https://github.com/p-rob/Moya-ObjectMapper.git', :branch => 'master'  # Moya + ObjectMapper 结合的扩展，用于将 JSON 数据映射到对象模型

    # 图片处理
    pod 'Kingfisher', '~> 7.0'  # 强大的图片下载和缓存库

    # 日期工具
    pod 'DateToolsSwift', '~> 5.0'  # 提供一系列日期处理功能，简化日期计算和格式化
    pod 'SwiftDate', '~> 7.0'  # Swift 的日期处理库，提供更简洁的 API

    # 工具库
    pod 'R.swift', '~> 7.0'  # 用于自动化生成资源文件的 Swift 工具，避免手动管理资源路径
    pod 'SwiftLint', '0.55.1'  # Swift 代码风格检查工具，帮助强制执行代码规范

    # 密钥链存储
    pod 'KeychainAccess', '~> 4.0'  # 一个简单的密钥链存储库，方便保存敏感数据如 Token

    # UI 组件
    pod 'SVProgressHUD', '~> 2.0'  # 提供简洁的进度条 HUD，用于显示加载进度
    pod 'ImageSlideshow/Kingfisher', :git => 'https://github.com/khoren93/ImageSlideshow.git', :branch => 'master'  # 一个图片幻灯片（Slideshow）控件，支持 Kingfisher 用于图片加载
    pod 'DZNEmptyDataSet', '~> 1.0'  # 用于在 TableView 或 CollectionView 中显示空数据占位图
    pod 'Hero', '~> 1.6'  # 强大的视图动画库，用于实现视图的过渡动画
    pod 'Localize-Swift', '~> 3.0'  # 用于简化 iOS 应用的多语言支持
    pod 'RAMAnimatedTabBarController', '~> 5.0'  # 动画化的 TabBar 控件
    pod 'AcknowList', '~> 3.0'  # 用于生成一个开源协议列表的工具，自动列出项目中使用的开源库
    pod 'KafkaRefresh', '~> 1.0'  # 下拉刷新动画效果库
    pod 'WhatsNewKit', '~> 1.0'  # 用于显示新版本功能的提示框
    pod 'Highlightr', '~> 2.0'  # 代码高亮显示库
    pod 'DropDown', '~> 2.0'  # 下拉菜单组件，支持各种自定义样式
    pod 'Toast-Swift', '~> 5.0'  # 提示框库，支持简洁的 Toast 消息弹出
    pod 'HMSegmentedControl', '~> 1.0'  # 分段控件库，类似 iOS 系统的 SegmentedControl
    pod 'FloatingPanel', '~> 2.0'  # 浮动面板控件，常用于实现弹出的视图面板
    pod 'MessageKit', '~> 3.0'  # 消息输入框和聊天界面库，用于构建聊天界面
    pod 'MultiProgressView', '~> 1.0'  # 多进度条组件
    pod 'DGCharts', '~> 5.0'  # 图表库，支持展示各种图表如饼图、柱状图等
    
    # 键盘管理
    pod 'IQKeyboardManagerSwift', '~> 7.0'  # 键盘管理库，解决键盘弹出遮挡问题

    # Auto Layout
    pod 'SnapKit', '~> 5.0'  # 提供简洁的约束布局 API，简化 Auto Layout 使用

    # 代码质量
    pod 'FLEX', '~> 5.0', :configurations => ['Debug']  # 灵活的调试工具，能动态查看和调试应用内的所有内容
    pod 'SwifterSwift', '~> 6.0'  # Swift 工具集，提供大量常用扩展
    pod 'BonMot', '~> 6.0'  # 用于简化文本样式（比如字体、颜色等）的设置

    # 日志记录
    pod 'CocoaLumberjack/Swift', '~> 3.0'  # 高效的日志记录库

    # 分析工具
#    pod 'Mixpanel-swift', '~> 4.0'  # Mixpanel 的 iOS SDK，用于分析用户行为

    # Firebase 服务
    pod 'FirebaseAnalytics', '~> 10.0'  # Firebase Analytics，用于收集应用内的使用数据
    pod 'FirebaseCrashlytics', '~> 10.0'  # Firebase Crashlytics，用于应用崩溃日志收集和分析

    target 'SwiftHubTests' do
        inherit! :search_paths
        # Pods for testing
        pod 'Quick', '~> 7.0'  # 用于编写行为驱动测试（BDD）的库
        pod 'Nimble', '~> 13.0'  # 与 Quick 配合使用的断言库
        pod 'RxAtomic', :modular_headers => true  # 用于 RxSwift 的原子操作库
        pod 'RxBlocking'  # 用于测试 RxSwift 流的库
    end
end

target 'SwiftHubUITests' do
    inherit! :search_paths
    # Pods for testing
end


post_install do |installer|
    # Cocoapods 优化，更新 pod 后总是需要清理项目
    Dir.glob(installer.sandbox.target_support_files_root + "Pods-*/*.sh").each do |script|
        flag_name = File.basename(script, ".sh") + "-Installation-Flag"
        folder = "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
        file = File.join(folder, flag_name)
        content = File.read(script)
        content.gsub!(/set -e/, "set -e\nKG_FILE=\"#{file}\"\nif [ -f \"$KG_FILE\" ]; then exit 0; fi\nmkdir -p \"#{folder}\"\ntouch \"$KG_FILE\"")
        File.write(script, content)
    end
    
    # 启用资源跟踪
    installer.pods_project.targets.each do |target|
      if target.name == 'RxSwift'
        target.build_configurations.each do |config|
          if config.name == 'Debug'
            config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
          end
        end
      end
    end
    
    # 隐藏部署目标警告
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
end
