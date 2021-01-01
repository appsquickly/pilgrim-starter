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

class ForecastTableViewCell : UITableViewCell {
    
    private var overlayView : UIImageView!
    public private(set) var dayLabel : UILabel!
    public private(set) var descriptionLabel : UILabel!
    public private(set) var highTempLabel : UILabel!
    public private(set) var lowTempLabel : UILabel!
    public private(set) var conditionsIcon : UIImageView!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initBackgroundView()
        initOverlay()
        initConditionsIcon()
        initDayLabel()
        initDescriptionLabel()
        initHighTempLabel()
        initLowTempLabel()
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Initialization & Destruction
    //-------------------------------------------------------------------------------------------

    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Overridden Methods
    //-------------------------------------------------------------------------------------------
    override func layoutSubviews() {
        super.layoutSubviews()
        overlayView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 50)
        conditionsIcon.frame = CGRect(x: 6, y: 7, width: 60 - 12, height: 50 - 12)
        let iconContainerWidth: CGFloat = 7.0 / 32.0 * width
        let conditionsContainer = CGRect(x: 0, y: 0, width: iconContainerWidth, height: contentView.height)
        conditionsIcon.frame = conditionsContainer.insetBy(dx: 8, dy: 8)
        dayLabel.x = iconContainerWidth + 10.0
        dayLabel.centerVertically(in: contentView.frame)

        lowTempLabel.centerVertically(in: contentView.frame)
        lowTempLabel.right = contentView.right - 10
        highTempLabel.centerVertically(in: contentView.frame)
        highTempLabel.right = lowTempLabel.x - 5
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Private Methods
    //-------------------------------------------------------------------------------------------
    
    private func initBackgroundView() {
        let backgroundView = UIView(frame: bounds)
        backgroundView.backgroundColor = UIColor(hex: 0x837758)
        self.backgroundView = backgroundView
    }
    
    private func initOverlay() {
        overlayView = UIImageView(frame: .zero)
        overlayView.image = UIImage(named: "cell_fade")
        overlayView.contentMode = .scaleToFill
        addSubview(overlayView)
    }
    
    private func initConditionsIcon() {
        conditionsIcon = UIImageView(frame:.zero)
        conditionsIcon.clipsToBounds = true
        conditionsIcon.contentMode = .scaleAspectFit
        conditionsIcon.image = UIImage(named: "icon_cloudy")
        addSubview(conditionsIcon)
    }
    
    private func initDayLabel() {
        dayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 18))
        dayLabel.font = UIFont.applicationFontOfSize(size: 16)
        dayLabel.textColor = .white
        dayLabel.backgroundColor = .clear
        addSubview(dayLabel)
    }
    
    private func initDescriptionLabel() {
        descriptionLabel = UILabel(frame:CGRect(x: 70, y: 28, width: 150, height: 16))
        descriptionLabel.font = UIFont.applicationFontOfSize(size: 13)
        descriptionLabel.textColor = UIColor(hex: 0xe9e1cd)
        descriptionLabel.backgroundColor = .clear
        addSubview(descriptionLabel)
    }
    
    private func initHighTempLabel() {
        highTempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 55, height: 30))
        highTempLabel.font = UIFont.temperatureFontOfSize(size: 27)
        highTempLabel.textColor = .white
        highTempLabel.backgroundColor = .clear
        highTempLabel.textAlignment = .right
        addSubview(highTempLabel)
    }
    
    private func initLowTempLabel() {
        lowTempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        lowTempLabel.font = UIFont.temperatureFontOfSize(size: 20)
        lowTempLabel.textColor = UIColor(hex: 0xd9d1bd)
        lowTempLabel.backgroundColor = .clear
        lowTempLabel.textAlignment = .right
        addSubview(lowTempLabel)
    }    
    
}
