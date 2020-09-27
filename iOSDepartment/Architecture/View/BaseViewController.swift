//
//  BaseViewController.swift
//  iOSDepartment
//
//  Created by Александр Строев on 26.09.2020.
//  Copyright © 2020 Stroev. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, BaseViewInput, NavigationProtocol, LoaderProtocol, ToastProtocol {
    internal var loader: LoaderViewProtocol = ExampleLoader()
}
