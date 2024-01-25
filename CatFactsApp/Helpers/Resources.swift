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
            
            enum DeletingAlert {
                static let title = "Delete fact"
                static let message = "Do you want to delete this fact?"
                static let deleteAction = "DELETE"
                static let cancelAction = "CANCEL"
            }
            
            static let unknownTitle: String = "Unknown Title"
        }
        
        enum Settings {
            
            enum ThemeCases {
                static let light = "Light"
                static let dark = "Dark"
                static let device = "Device"
            }
            
            enum TextFieldAlert {
                static let title = "Wrong value"
                static let message = "Amount of proposed facts must be numeric"
                static let action = "Close"
            }
            static let proposedFactsAmount = "Amount of proposed facts:"
            static let appTheme = "Theme:"
            static let language = "Language:"
        }
    }

    // MARK: - COLORS
    enum Colors {
        
        static let separator = UIColor(named: "separator")!
        static let background = UIColor(named: "background")!
        static let element = UIColor(named: "element")!
        static let tintColor = UIColor(named: "tint_color")!
        
        enum Bars {
            static let background = UIColor(named: "bars_background")!
        }
        
        enum Facts {
            enum CellSwipes {
                static let proposedTrailing = UIColor(named: "proposed_trailing")!
                static let proposedLeading = UIColor(named: "proposed_leading")!
                static let favouritsTrailing = UIColor(named: "favourits_trailing")!
                static let favouritsLeading = UIColor(named: "favourits_leading")!
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
        
        
    }
    
    static let designValue: CGFloat = 17
    
    static func getSeparator(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIView {
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        separatorView.backgroundColor = Resources.Colors.separator
        return separatorView
    }
}
