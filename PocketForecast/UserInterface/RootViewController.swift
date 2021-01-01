/*
 The MIT License (MIT)

 Copyright (c) 2016-2020 The Contributors

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
import UIKit

private enum SideViewState {
    case hidden
    case showing
}

class RootViewController: UIViewController {

    let SIDE_CONTROLLER_WIDTH: CGFloat = 245.0

    private var navigator: UINavigationController!
    private var mainContentViewContainer: UIView!
    private var sideViewState: SideViewState!
    private var assembly: ApplicationAssembly!

    private var citiesListController: UIViewController?
    private var addCitiesController: UIViewController?


    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------

    init(mainContentViewController: UIViewController, assembly: ApplicationAssembly) {
        super.init(nibName: nil, bundle: nil)

        self.assembly = assembly
        sideViewState = .hidden
        self.pushViewController(controller: mainContentViewController, replaceRoot: true)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    //-------------------------------------------------------------------------------------------
    // MARK: - Public Methods
    //-------------------------------------------------------------------------------------------

    func pushViewController(controller: UIViewController) {
        self.pushViewController(controller: controller, replaceRoot: false)
    }

    func pushViewController(controller: UIViewController, replaceRoot: Bool) {
        objc_sync_enter(self)
        if navigator == nil {
            makeNavigationControllerWithRoot(root: controller)
        } else if replaceRoot {
            navigator.setViewControllers([controller], animated: true)
        } else {
            navigator.pushViewController(controller, animated: true)
        }
        objc_sync_exit(self)
    }

    func popViewControllerAnimated(animated: Bool) {
        objc_sync_enter(self)
        navigator.popViewController(animated: animated)
        objc_sync_exit(self)
    }

    func showCitiesListController() {
        if sideViewState != .showing {
            sideViewState = .showing
            citiesListController = UINavigationController(rootViewController: assembly.citiesListController())
            let frame = CGRect(x: -SIDE_CONTROLLER_WIDTH, y: 0, width: SIDE_CONTROLLER_WIDTH, height: mainContentViewContainer.frame.size.height)
            citiesListController!.view.frame = frame
            view.addSubview(citiesListController!.view)
            addChild(citiesListController!)
            citiesListController?.willMove(toParent: self)

            citiesListController?.viewWillAppear(true)
            UIView.transition(with: view, duration: 0.25, options: .curveEaseInOut, animations: { [self] in
                let citiesListFrame = CGRect(x: 0, y: 0, width: SIDE_CONTROLLER_WIDTH, height: view.frame.size.height)
                citiesListController!.view.frame = citiesListFrame
                let mainContentFrame = CGRect(x: SIDE_CONTROLLER_WIDTH, y: 0, width: view.bounds.width, height: view.bounds.height)
                mainContentViewContainer.frame = mainContentFrame
            }) { [self] (b: Bool) -> () in
                citiesListController?.viewDidAppear(true)
            }
        }
    }

    func dismissCitiesListController() {
        if sideViewState != .hidden {
            sideViewState = .hidden
            navigator.topViewController?.viewWillAppear(true)
            UIView.transition(with: view, duration: 0.25, options: .curveEaseInOut, animations: { [self] in
                let citiesListFrame = CGRect(x: -SIDE_CONTROLLER_WIDTH, y: 0, width: SIDE_CONTROLLER_WIDTH, height: view.frame.size.height)
                citiesListController!.view.frame = citiesListFrame
                let mainContentFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
                mainContentViewContainer.frame = mainContentFrame
            }) { [self] (b: Bool) -> () in
                citiesListController?.removeFromParent()
                citiesListController?.view.removeFromSuperview()
                citiesListController = nil
                navigator.topViewController?.viewDidAppear(true)
            }
        }
    }

    func toggleSideViewController() {
        switch sideViewState {
        case .hidden:
            showCitiesListController()
        case .showing:
            dismissCitiesListController()
        default:
            break
        }
    }

    func showAddCitiesController() {
        if addCitiesController == nil {
            navigator.topViewController!.view.isUserInteractionEnabled = false
            addCitiesController = UINavigationController(rootViewController: assembly.addCityViewController())
            addCitiesController!.view.frame = CGRect(x: 0, y: view.frame.origin.y + view.frame.size.height, width: SIDE_CONTROLLER_WIDTH, height: view.frame.size.height)
            view.addSubview(addCitiesController!.view)

            UIView.transition(with: view, duration: 0.25, options: .curveEaseInOut, animations: { [self] in
                let frame = CGRect(x: 0, y: 0, width: SIDE_CONTROLLER_WIDTH, height: view.frame.size.height)
                addCitiesController!.view.frame = frame
            })
        }
    }

    func dismissAddCitiesController() {
        if let addCitiesController = addCitiesController {
            citiesListController?.viewWillAppear(true)
            UIView.transition(with: view, duration: 0.25, options: .curveEaseInOut, animations: {
                let frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.SIDE_CONTROLLER_WIDTH, height: self.view.frame.size.height)
                addCitiesController.view.frame = frame
            }) { [self]
                completed in
                addCitiesController.view.removeFromSuperview()
                self.addCitiesController = nil
                citiesListController?.viewDidAppear(true)
                navigator.topViewController!.view.isUserInteractionEnabled = true
            }
        }
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Overridden Methods
    //-------------------------------------------------------------------------------------------

    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        mainContentViewContainer = UIView(frame: view.bounds)
        view.addSubview(mainContentViewContainer)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigator.view.frame = view.bounds
    }

    override var shouldAutorotate: Bool {
        navigator.topViewController?.shouldAutorotate ?? false
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        navigator.topViewController?.viewWillTransition(to: size, with: coordinator)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        navigator.topViewController?.preferredStatusBarStyle ?? .lightContent
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Private Methods
    //-------------------------------------------------------------------------------------------

    private func makeNavigationControllerWithRoot(root: UIViewController) {
        navigator = UINavigationController(rootViewController: root)
        navigator.view.frame = view.bounds
        mainContentViewContainer.addSubview(navigator.view)
    }
}
