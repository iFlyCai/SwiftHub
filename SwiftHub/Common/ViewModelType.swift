//
//  ViewModelType.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper

/// 统一的 ViewModelType 协议，适用于 RxSwift
protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    /// 负责将输入转换成输出
    func transform(input: Input) -> Output
}

class ViewModel: NSObject {

    /// 网络请求提供者（SwiftHubAPI 是假设的网络请求管理类）
    let provider: SwiftHubAPI

    /// 记录当前分页
    var page = 1

    /// 追踪全局加载状态
    let loading = ActivityIndicator()

    /// 追踪头部刷新状态
    let headerLoading = ActivityIndicator()

    /// 追踪分页加载状态
    let footerLoading = ActivityIndicator()

    /// 追踪错误信息
    let error = ErrorTracker()

    /// 服务器错误信息（未解析）
    let serverError = PublishSubject<Error>()

    /// 解析后的 API 错误信息
    let parsedError = PublishSubject<ApiError>()

    /// 初始化 ViewModel，注入网络请求提供者
    init(provider: SwiftHubAPI) {
        self.provider = provider
        super.init()

        // 监听 serverError 事件，尝试解析 API 返回的错误信息
        serverError.asObservable()
            .map { (error) -> ApiError? in
                do {
                    // 检查是否是 MoyaError（Moya 是 RxSwift 里常用的网络请求库）
                    let errorResponse = error as? MoyaError
                    if let body = try errorResponse?.response?.mapJSON() as? [String: Any],
                        let errorResponse = Mapper<ErrorResponse>().map(JSON: body) {
                        return ApiError.serverError(response: errorResponse) // 解析错误
                    }
                } catch {
                    print(error) // 解析失败时输出错误
                }
                return nil
            }
            .filterNil() // 过滤掉 nil 值
            .bind(to: parsedError) // 绑定到解析后的错误流
            .disposed(by: rx.disposeBag)

        // 监听解析后的错误并打印日志
        parsedError.subscribe(onNext: { (error) in
            logError("\(error)")
        }).disposed(by: rx.disposeBag)
    }

    /// 释放资源时打印日志（防止内存泄漏）
    deinit {
        logDebug("\(type(of: self)): Deinited")
        logResourcesCount()
    }
}
