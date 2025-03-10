//
//  Application.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/5/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

final class Application: NSObject {
    static let shared = Application()  // 单例模式，提供唯一的 Application 实例

    var window: UIWindow?  // 应用的主窗口

    var provider: SwiftHubAPI?  // 用于提供 API 服务的网络层
    let authManager: AuthManager  // 授权管理器
    let navigator: Navigator  // 导航器，用于界面切换

    private override init() {
        authManager = AuthManager.shared  // 获取授权管理器的单例
        navigator = Navigator.default  // 获取导航器的默认实例
        super.init()
        updateProvider()  // 初始化时更新 API 提供者
    }

    // 更新 API 提供者
    private func updateProvider() {
        let staging = Configs.Network.useStaging  // 判断是否使用 Staging 环境
        // 根据环境选择不同的网络提供者
        let githubProvider = staging ? GithubNetworking.stubbingNetworking() : GithubNetworking.defaultNetworking()
        let trendingGithubProvider = staging ? TrendingGithubNetworking.stubbingNetworking() : TrendingGithubNetworking.defaultNetworking()
        let codetabsProvider = staging ? CodetabsNetworking.stubbingNetworking() : CodetabsNetworking.defaultNetworking()
        // 创建 RestApi 实例，结合上述提供者
        let restApi = RestApi(githubProvider: githubProvider, trendingGithubProvider: trendingGithubProvider, codetabsProvider: codetabsProvider)
        provider = restApi  // 更新 provider 为新的 RestApi 实例

        // 如果有授权 token 且不是在 Staging 环境下，使用 GraphApi
        if let token = authManager.token, Configs.Network.useStaging == false {
            switch token.type() {
            case .oAuth(let token), .personal(let token):
                provider = GraphApi(restApi: restApi, token: token)  // 使用 GraphApi 提供 GraphQL 支持
            default: break  // 如果是其他类型的 token，不做处理
            }
        }
    }

    // 展示初始屏幕
    func presentInitialScreen(in window: UIWindow?) {
        updateProvider()  // 更新 provider
        guard let window = window, let provider = provider else { return }  // 如果窗口或 provider 无效，退出

        self.window = window  // 保存窗口引用

        // 延迟 0.5 秒后执行，确保页面有足够时间加载
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if let user = User.currentUser(), let login = user.login {
                // 记录用户信息到分析工具
                analytics.identify(userId: login)
                analytics.set(.name(value: user.name ?? ""))
                analytics.set(.email(value: user.email ?? ""))
            }
            // 检查 token 是否有效
            let authorized = self?.authManager.token?.isValid ?? false
            let viewModel = HomeTabBarViewModel(authorized: authorized, provider: provider)  // 创建 HomeTabBar 视图模型
            // 使用导航器展示 TabBar 页面
            self?.navigator.show(segue: .tabs(viewModel: viewModel), sender: nil, transition: .root(in: window))
        }
    }

    // 展示测试屏幕
    func presentTestScreen(in window: UIWindow?) {
        guard let window = window, let provider = provider else { return }  // 如果窗口或 provider 无效，退出

        // 创建用户详情的视图模型
        let viewModel = UserViewModel(user: User(), provider: provider)
        // 使用导航器展示用户详情页面
        navigator.show(segue: .userDetails(viewModel: viewModel), sender: nil, transition: .root(in: window))
    }
}
