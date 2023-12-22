//
//  Resources.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 7.12.23.
//

import UIKit

struct Resources {
    
    // MARK: - STRINGS
    enum Strings {
        
        static let factsTitle = "Facts"
        static let settingsTitle = "Settings"
        
        enum Facts {
            enum Sections {
                static let userFacts = "My Facts"
                static let savedFacts = "Saved Facts"
                static let proposedFacts = "Proposed Facts"
                static let unknownSection = "Unknown Section"
            }
            
            enum Buttons {
                static let closeButton = "CLOSE"
                static let saveButton = "SAVE"
            }
            
            enum SegmentedControl {
                static let proposedFacts = "Proposed"
                static let favouritsFacts = "Favourits"
            }
            
            enum CellSwipes {
                static let proposedTrailing = "Update"
                static let proposedLeading = "Save"
                static let favouritsTrailing = "Delete"
                static let favouritsLeading = "Edit"
            }
            
            static let unknownTitle: String = "Unknown Title"
        }
    }

    // MARK: - COLORS
    enum Colors {
        
        static let separator: UIColor = .systemGray4
        static let background: UIColor = UIColor(hex: "#F8F9F9")
        static let element: UIColor = .white
        
        enum Bars {
            static let background: UIColor = .white
        }
        
        enum Facts {
            enum CellSwipes {
                static let proposedTrailing: UIColor = .systemCyan
                static let proposedLeading: UIColor = .systemGray
                static let favouritsTrailing: UIColor = .systemRed
                static let favouritsLeading: UIColor = .systemGray
            }
        }
    }
    
    // MARK: - IMAGES
    enum Images {
        
        static let imageErr = UIImage(named: "no_image")
        
        enum TabBar {
            static let factsIcon = UIImage(named: "facts_icon")
            static let settingsIcon = UIImage(named: "settings_icon")
        }
        
    }
    
    // MARK: - SETTINGS
    enum Settings {
        static let proposedFactsAmount = 17
    }
    
    static let designValue: CGFloat = 17
    
    static func getSeparator(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIView {
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        separatorView.backgroundColor = Resources.Colors.separator
        return separatorView
    }
}
