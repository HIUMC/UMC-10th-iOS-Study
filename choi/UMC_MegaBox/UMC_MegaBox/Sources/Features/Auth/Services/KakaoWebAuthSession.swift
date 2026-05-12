import UIKit
import WebKit

@MainActor
final class KakaoWebAuthSession: NSObject {
    private var continuation: CheckedContinuation<URL, Error>?
    private var viewController: KakaoLoginWebViewController?

    func start(url: URL, redirectURI: String) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            let viewController = KakaoLoginWebViewController(
                authorizationURL: url,
                redirectURI: redirectURI
            ) { [weak self] result in
                self?.finish(with: result)
            }

            self.viewController = viewController
            topViewController()?.present(viewController, animated: true)
        }
    }

    private func finish(with result: Result<URL, Error>) {
        viewController?.dismiss(animated: true)
        viewController = nil

        guard let continuation else { return }
        self.continuation = nil

        switch result {
        case .success(let url):
            continuation.resume(returning: url)
        case .failure(let error):
            continuation.resume(throwing: error)
        }
    }

    private func topViewController() -> UIViewController? {
        let rootViewController = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }?
            .rootViewController

        var topViewController = rootViewController
        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
}

@MainActor
private final class KakaoLoginWebViewController: UIViewController, WKNavigationDelegate {
    private static let koreanFontFixScript = """
    (function() {
        const fontFamily = "-apple-system, BlinkMacSystemFont, 'Apple SD Gothic Neo', 'Apple SD GothicNeo-Regular', 'Noto Sans KR', sans-serif";

        function applyKoreanFontFix() {
            if (!document.documentElement) { return; }

            if (!document.getElementById('umc-kakao-korean-font-fix')) {
                const style = document.createElement('style');
                style.id = 'umc-kakao-korean-font-fix';
                style.textContent = `
                    html, body, body * {
                        font-family: ${fontFamily} !important;
                        -webkit-font-smoothing: antialiased !important;
                    }
                `;
                document.documentElement.appendChild(style);
            }

            document.querySelectorAll('body, body *').forEach(function(element) {
                element.style.setProperty('font-family', fontFamily, 'important');
                element.style.setProperty('-webkit-font-smoothing', 'antialiased', 'important');
            });
        }

        applyKoreanFontFix();

        if (!window.__umcKakaoKoreanFontObserver && window.MutationObserver) {
            window.__umcKakaoKoreanFontObserver = new MutationObserver(applyKoreanFontFix);
            window.__umcKakaoKoreanFontObserver.observe(document.documentElement, {
                childList: true,
                subtree: true
            });
        }
    })();
    """

    private let authorizationURL: URL
    private let redirectURI: String
    private let onComplete: (Result<URL, Error>) -> Void
    private let webView: WKWebView

    init(
        authorizationURL: URL,
        redirectURI: String,
        onComplete: @escaping (Result<URL, Error>) -> Void
    ) {
        self.authorizationURL = authorizationURL
        self.redirectURI = redirectURI
        self.onComplete = onComplete

        let configuration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        let koreanFontFixScript = WKUserScript(
            source: Self.koreanFontFixScript,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        contentController.addUserScript(koreanFontFixScript)
        configuration.userContentController = contentController
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.websiteDataStore = .nonPersistent()

        self.webView = WKWebView(frame: .zero, configuration: configuration)

        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        webView.load(URLRequest(url: authorizationURL))
    }

    private func configureView() {
        view.backgroundColor = .systemBackground

        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "카카오 로그인"
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("닫기", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        closeButton.addTarget(self, action: #selector(cancelLogin), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        webView.navigationDelegate = self
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        webView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(closeButton)
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 52),

            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            webView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func cancelLogin() {
        onComplete(.failure(APIError.cancelled))
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        if isRedirectURL(url) {
            decisionHandler(.cancel)
            onComplete(.success(url))
            return
        }

        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(Self.koreanFontFixScript)
    }

    private func isRedirectURL(_ url: URL) -> Bool {
        url.absoluteString == redirectURI || url.absoluteString.hasPrefix("\(redirectURI)?")
    }
}
