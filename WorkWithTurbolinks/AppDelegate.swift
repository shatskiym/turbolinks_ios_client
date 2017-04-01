import UIKit
import WebKit
import Turbolinks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController = UINavigationController()
    lazy var session: Session = {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "Turbolinks on IOS"
        return Session(webViewConfiguration: configuration)
    }()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window?.rootViewController = navigationController
        startApplication()
        return true
    }

    func startApplication() {
        session.delegate = self
        visit(URL: NSURL(string: "https://turbolinks-server.herokuapp.com/")!)
    }
    
    func visit(URL: NSURL) {
        let visitableViewController = VisitableViewController(URL: URL)
        navigationController.pushViewController(visitableViewController, animated: true)
        session.visit(visitableViewController)
    }
}

extension AppDelegate: SessionDelegate {
    func session(_ session: Session, didProposeVisitToURL URL: URL, withAction action: Action) {
        visit(URL: URL as NSURL)
    }
    
    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        navigationController.present(alert, animated: true, completion: nil)
    }
}
