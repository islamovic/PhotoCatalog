//
//  UITableView+Utils.swift
//  PhotoCatalog
//
//  Created by Islam on 01/02/2022.
//

import UIKit

public extension UITableView {
    func dequeueReusableCell<T>(indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T
            else { fatalError("not able to dequeue cell") }
        return cell
    }

    func register(_ klass: AnyClass, identifier: String? = nil) {
        let nibName = String(describing: klass.self)
        let identifier = identifier ?? nibName
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }

    func update(row: Int = 0, section: Int = 0) {
        let indexPath = IndexPath(row: row, section: section)
        self.beginUpdates()
        self.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        self.endUpdates()
    }
}

