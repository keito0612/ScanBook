//
//  PageViewController.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/18.
//

import Foundation
import SwiftUI
import WithPrevious

struct PageViewController<Page: View>: UIViewControllerRepresentable {
    private var pages: [Page]
    @Binding @WithPrevious var currentPage: Int
    @Binding var slidePageCount:Int
    let onChange: (Int) -> Void

    init(pages: [Page], slidePageCount: Binding<Int> ,currentPage: Binding<WithPrevious<Int>>, onChange: @escaping (Int) -> Void ) {
        self.pages = pages
        self._slidePageCount = slidePageCount
        self._currentPage = currentPage
        self.onChange = onChange
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator

        return pageViewController
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        let direction: UIPageViewController.NavigationDirection
        if let previousPage = $currentPage.wrappedValue.projectedValue {
            direction = currentPage > previousPage ? .forward : .reverse
        } else {
            direction = .forward
        }

        for (i, page) in pages.enumerated() {
            if i < context.coordinator.controllers.endIndex {
                (context.coordinator.controllers[i] as? UIHostingController<Page>)?.rootView = page
            } else {
                let newController = UIHostingController<Page>(rootView: page)
                context.coordinator.controllers.append(newController)
            }
        }

        context.coordinator.controllers.removeLast(max(context.coordinator.controllers.count - pages.count, 0))

        pageViewController.setViewControllers(
            [context.coordinator.controllers[currentPage]], direction: direction, animated: true
        )
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        var controllers = [UIViewController]()

        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
            self.controllers = parent.pages.map { UIHostingController(rootView: $0) }
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return controllers.last
            }
            return controllers[index - 1]
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController
        ) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == controllers.count {
                return controllers.first
            }
            if index == controllers.endIndex {
                return controllers.last
            }
            return controllers[index + 1]
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool
        ) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: visibleViewController)
            {
                parent.currentPage = index
                parent.slidePageCount = index
                parent.onChange(index)
            }
        }
    }
}
