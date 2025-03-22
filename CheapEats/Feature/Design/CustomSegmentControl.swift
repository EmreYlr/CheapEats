import UIKit
class CustomSegmentedControl: UISegmentedControl {
    
    private var labels = [UILabel]()
    private var secondaryLabels = [UILabel]()
    private var selectionIndicators = [UIView]()
    private var segmentTitles = [String]()
    private var secondaryTexts = [String]()
    private var segmentBackgrounds = [UIView]()
    private let segmentGap: CGFloat = 10
    private var enabledSegments = [Bool]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupControl()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupControl()
    }
    
    private func setupControl() {
        segmentTitles.removeAll()
        secondaryTexts.removeAll()
        enabledSegments.removeAll()
        
        for i in 0..<numberOfSegments {
            segmentTitles.append(super.titleForSegment(at: i) ?? "Segment \(i+1)")
            secondaryTexts.append("(...)")
            enabledSegments.append(true) 
            super.setTitle("", forSegmentAt: i)
        }
        
        backgroundColor = .BG
        tintColor = .clear
        
        let emptyImage = UIImage()
        setBackgroundImage(emptyImage, for: .normal, barMetrics: .default)
        setBackgroundImage(emptyImage, for: .selected, barMetrics: .default)
        setDividerImage(emptyImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        updateSegments()
        
        addTarget(self, action: #selector(segmentSelected), for: .valueChanged)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSegments()
    }
    
    override func setTitle(_ title: String?, forSegmentAt segment: Int) {
        super.setTitle("", forSegmentAt: segment)
        
        let newTitle = title ?? "Segment \(segment+1)"
        if segment < segmentTitles.count {
            segmentTitles[segment] = newTitle
        } else {
            while segmentTitles.count <= segment {
                segmentTitles.append("")
                secondaryTexts.append("Detail")
                enabledSegments.append(true)
            }
            segmentTitles[segment] = newTitle
        }
        
        updateSegments()
    }
    
    override func titleForSegment(at segment: Int) -> String? {
        return segment < segmentTitles.count ? segmentTitles[segment] : nil
    }
    
    override func setEnabled(_ enabled: Bool, forSegmentAt segment: Int) {
        super.setEnabled(enabled, forSegmentAt: segment)
        
        if segment < enabledSegments.count {
            enabledSegments[segment] = enabled
        } else {
            while enabledSegments.count <= segment {
                enabledSegments.append(true)
            }
            enabledSegments[segment] = enabled
        }
        
        updateSegments()
    }
    
    func updateSegments() {
        labels.forEach { $0.removeFromSuperview() }
        secondaryLabels.forEach { $0.removeFromSuperview() }
        selectionIndicators.forEach { $0.removeFromSuperview() }
        segmentBackgrounds.forEach { $0.removeFromSuperview() }
        
        labels.removeAll()
        secondaryLabels.removeAll()
        selectionIndicators.removeAll()
        segmentBackgrounds.removeAll()
        
        let totalGapWidth = segmentGap * CGFloat(numberOfSegments - 1)
        let segmentWidth = (bounds.width - totalGapWidth) / CGFloat(numberOfSegments)
        
        for i in 0..<numberOfSegments {
            let isEnabled = i < enabledSegments.count ? enabledSegments[i] : true
            let segmentX = (segmentWidth + segmentGap) * CGFloat(i)
            
            let segmentFrame = CGRect(
                x: segmentX,
                y: 0,
                width: segmentWidth,
                height: 80
            )
            
            let segmentBackground = UIView(frame: segmentFrame)
            
            if isEnabled {
                segmentBackground.backgroundColor = .white
            } else {
                segmentBackground.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            }
            
            segmentBackground.layer.cornerRadius = 8
            segmentBackground.layer.borderWidth = 2
            
            if i == selectedSegmentIndex && isEnabled {
                segmentBackground.layer.borderColor = UIColor.button.cgColor
            } else {
                segmentBackground.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
            }
            
            addSubview(segmentBackground)
            segmentBackgrounds.append(segmentBackground)
            
            let indicatorSize: CGFloat = 20
            let indicator = UIView(frame: CGRect(
                x: segmentFrame.minX + 10,
                y: 10,
                width: indicatorSize,
                height: indicatorSize
            ))
            
            indicator.layer.cornerRadius = indicatorSize/2
            indicator.layer.borderWidth = 2
            
            if isEnabled {
                indicator.layer.borderColor = UIColor.button.cgColor
                indicator.backgroundColor = i == selectedSegmentIndex ? .button : .clear
            } else {
                indicator.layer.borderColor = UIColor.lightGray.cgColor
                indicator.backgroundColor = .clear
            }
            
            addSubview(indicator)
            selectionIndicators.append(indicator)

            let labelText = i < segmentTitles.count ? segmentTitles[i] : "Segment \(i+1)"
            let labelFont = UIFont.boldSystemFont(ofSize: 14)
            let labelAttributes = [NSAttributedString.Key.font: labelFont]
            let labelSize = (labelText as NSString).size(withAttributes: labelAttributes)
            
            let label = UILabel(frame: CGRect(
                x: segmentFrame.minX + 10,
                y: segmentFrame.maxY - labelSize.height - 10,
                width: min(labelSize.width, segmentFrame.width / 2),
                height: labelSize.height
            ))
            
            label.text = labelText
            label.textAlignment = .left
            label.font = labelFont
            
            if isEnabled {
                label.textColor = i == selectedSegmentIndex ? .button : .darkGray
            } else {
                label.textColor = .lightGray
            }
            
            addSubview(label)
            labels.append(label)
            
            let secondaryLabelText = i < secondaryTexts.count ? secondaryTexts[i] : "Detail"
            let secondaryLabelFont = UIFont.systemFont(ofSize: 12)
            let secondaryLabelAttributes = [NSAttributedString.Key.font: secondaryLabelFont]
            let secondaryLabelSize = (secondaryLabelText as NSString).size(withAttributes: secondaryLabelAttributes)
            
            let secondaryLabel = UILabel(frame: CGRect(
                x: label.frame.maxX + 5,
                y: label.frame.minY,
                width: min(secondaryLabelSize.width, segmentFrame.width / 2 - 10),
                height: secondaryLabelSize.height
            ))
            
            secondaryLabel.text = secondaryLabelText
            secondaryLabel.textAlignment = .left
            secondaryLabel.font = secondaryLabelFont
            secondaryLabel.textColor = isEnabled ? .lightGray : .lightGray.withAlphaComponent(0.5)
            
            addSubview(secondaryLabel)
            secondaryLabels.append(secondaryLabel)
        }
    }
    
    @objc private func segmentSelected() {
        updateSegments()
    }
    
    func setSecondaryText(_ text: String, forSegmentAt segment: Int) {
        if segment >= secondaryTexts.count {
            while secondaryTexts.count <= segment {
                secondaryTexts.append("Detail")
            }
        }
        secondaryTexts[segment] = text
        updateSegments()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let point = touch.location(in: self)
        
        let totalGapWidth = segmentGap * CGFloat(numberOfSegments - 1)
        let segmentWidth = (bounds.width - totalGapWidth) / CGFloat(numberOfSegments)
        
        for i in 0..<numberOfSegments {
            let segmentX = (segmentWidth + segmentGap) * CGFloat(i)
            let segmentFrame = CGRect(
                x: segmentX,
                y: 0,
                width: segmentWidth,
                height: 80
            )
            if segmentFrame.contains(point) && i < enabledSegments.count && enabledSegments[i] {
                selectedSegmentIndex = i
                sendActions(for: .valueChanged)
                break
            }
        }
    }
}
