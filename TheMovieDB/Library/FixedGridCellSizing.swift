//
//  FixedGridCellSizing.swift
//  TheMovieDB
//
//  Created by Dimitris C. on 29/05/2018.
//  Copyright © 2018 Dimitris C. All rights reserved.
//

import UIKit

final class FixedGridCellSizing {

    private let rows: Int
    private let cols: Int

    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
    }

    final func size(withContainerSize container: CGSize, spacing: CGFloat, insets: UIEdgeInsets) -> CGSize {
        let widthSpacing = insets.left + insets.right + (spacing * CGFloat(self.cols - 1))
        let heightSpacing = insets.top + insets.bottom + (spacing * CGFloat(self.rows - 1))
        let width = Int((container.width - widthSpacing) / CGFloat(self.cols))
        let height = Int((container.height - heightSpacing) / CGFloat(self.rows))
        return CGSize(width: width, height: height)
    }

}

