//
//  StampViewController.swift
//  Park_Stamp_Generator
//
//  Created by Rishabh Ganesh on 6/2/22.
//

import UIKit
import SwiftUI

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer)
    {
        print("Save finished!")
    }
}

class StampViewController: UIViewController {
    var parkString = String()
    var dateString = String()
    var attractionString = String()
    var size = CGSize(width: 250, height: 250)
    
    @IBOutlet weak var lightblue: UIButton!
    @IBOutlet weak var blue: UIButton!
    @IBOutlet weak var yellow: UIButton!
    @IBOutlet weak var red: UIButton!
    @IBOutlet weak var purple: UIButton!
    @IBOutlet weak var green: UIButton!
    @IBOutlet weak var black: UIButton!
    @IBOutlet weak var brown: UIButton!
    @IBOutlet weak var orange: UIButton!
    @IBOutlet weak var stampView: UIImageView!
    @IBOutlet weak var contextView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contextView.image = UIImage(named:
        "black")
        stampView.image = makeStamp(parkName: parkString, date: dateString, attractionName: attractionString, radius: 81, color: UIColor.black)
        

    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        let inputImage = blendImages(contextView.image!, stampView.image!)
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: inputImage)
    }
    @IBAction func lightbluePressed(_ sender: Any) {
        contextView.image = UIImage(named:
        "lblue")
        stampView.image = makeStamp(parkName: parkString, date: dateString, attractionName: attractionString, radius: 81, color: UIColor.systemTeal)

    }
    @IBAction func bluePressed(_ sender: Any) {
        contextView.image = UIImage(named:
        "blue")
        stampView.image = makeStamp(parkName: parkString, date: dateString, attractionName: attractionString, radius: 81, color: UIColor.blue)

    }
    @IBAction func yellowPressed(_ sender: Any) {
        contextView.image = UIImage(named:
        "olive")
        stampView.image = makeStamp(parkName: parkString, date: dateString, attractionName: attractionString, radius: 81, color: UIColor(red: 0.6275, green: 0.5608, blue: 0.3961, alpha: 1.0))
    }
    
    @IBAction func redPressed(_ sender: Any) {
        contextView.image = UIImage(named:
        "red")
        stampView.image = makeStamp(parkName: parkString, date: dateString, attractionName: attractionString, radius: 81, color: UIColor.red)
    }
    
    @IBAction func purplePressed(_ sender: Any) {
        contextView.image = UIImage(named:
        "purp")
        stampView.image = makeStamp(parkName: parkString, date: dateString, attractionName: attractionString, radius: 81, color: UIColor.purple)
    }
    
    @IBAction func greenPressed(_ sender: Any) {
        contextView.image = UIImage(named:
        "green")
        stampView.image = makeStamp(parkName: parkString, date: dateString, attractionName: attractionString, radius: 81, color: UIColor.systemGreen)
    }
    
    @IBAction func blackPressed(_ sender: Any) {
        contextView.image = UIImage(named:
        "black")
        stampView.image = makeStamp(parkName: parkString, date: dateString, attractionName: attractionString, radius: 81, color: UIColor.black)
    }
    
    @IBAction func brownPressed(_ sender: Any) {
        contextView.image = UIImage(named:
        "brown")
        stampView.image = makeStamp(parkName: parkString, date: dateString, attractionName: attractionString, radius: 81, color: UIColor.brown)
    }
    
    @IBAction func orangePressed(_ sender: Any) {
        contextView.image = UIImage(named:
        "orange")
        stampView.image = makeStamp(parkName: parkString, date: dateString, attractionName: attractionString, radius: 81, color: UIColor.orange)
    }
    
    func centerArcPerpendicular(text str: String, context: CGContext, radius r: CGFloat, theta: CGFloat, color: UIColor, font: UIFont, clockwise: Bool){
        // *******************************************************
        // This draws the String str around an arc of radius r,
        // with the text centred at polar angle theta
        // *******************************************************

        let characters: [String] = str.map { String($0) } // An array of single character strings, each character in str
        let l = characters.count
        let attributes = [NSAttributedString.Key.font: font]

        var arcs: [CGFloat] = [] // This will be the arcs subtended by each character
        var totalArc: CGFloat = 0 // ... and the total arc subtended by the string

        // Calculate the arc subtended by each letter and their total
        for i in 0 ..< l {
            arcs += [chordToArc(characters[i].size(withAttributes: attributes).width, radius: r)]
            totalArc += arcs[i]
        }

        // Are we writing clockwise (right way up at 12 o'clock, upside down at 6 o'clock)
        // or anti-clockwise (right way up at 6 o'clock)?
        let direction: CGFloat = clockwise ? -1 : 1
        let slantCorrection: CGFloat = clockwise ? -.pi / 2 : .pi / 2

        // The centre of the first character will then be at
        // thetaI = theta - totalArc / 2 + arcs[0] / 2
        // But we add the last term inside the loop
        var thetaI = theta - direction * totalArc / 2

        for i in 0 ..< l {
            thetaI += direction * arcs[i] / 2
            // Call centerText with each character in turn.
            // Remember to add +/-90º to the slantAngle otherwise
            // the characters will "stack" round the arc rather than "text flow"
            centre(text: characters[i], context: context, radius: r, theta: thetaI, colour: color, font: font, slantAngle: thetaI + slantCorrection)
            // The centre of the next character will then be at
            // thetaI = thetaI + arcs[i] / 2 + arcs[i + 1] / 2
            // but again we leave the last term to the start of the next loop...
            thetaI += direction * arcs[i] / 2
        }
    }

    func chordToArc(_ chord: CGFloat, radius: CGFloat) -> CGFloat {
        return 2 * asin(chord / (2 * radius))
    }

    func centre(text str: String, context: CGContext, radius r: CGFloat, theta: CGFloat, colour c: UIColor, font: UIFont, slantAngle: CGFloat) {
        // *******************************************************
        // This draws the String str centred at the position
        // specified by the polar coordinates (r, theta)
        // i.e. the x= r * cos(theta) y= r * sin(theta)
        // and rotated by the angle slantAngle
        // *******************************************************

        // Set the text attributes
        let attributes = [NSAttributedString.Key.foregroundColor: c, NSAttributedString.Key.font: font]
        //let attributes = [NSForegroundColorAttributeName: c, NSFontAttributeName: font]
        // Save the context
        context.saveGState()
        // Undo the inversion of the Y-axis (or the text goes backwards!)
        context.scaleBy(x: 1, y: -1)
        // Move the origin to the centre of the text (negating the y-axis manually)
        context.translateBy(x: r * cos(theta), y: -(r * sin(theta)))
        // Rotate the coordinate system
        context.rotate(by: -slantAngle)
        // Calculate the width of the text
        let offset = str.size(withAttributes: attributes)
        // Move the origin by half the size of the text
        context.translateBy (x: -offset.width / 2, y: -offset.height / 2) // Move the origin to the centre of the text (negating the y-axis manually)
        // Draw the text
        str.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        // Restore the context
        context.restoreGState()
    }
    
    func blendImages(_ img: UIImage,_ imgTwo: UIImage) -> UIImage {
        let bottomImage = img
        let topImage = imgTwo

        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))
        let imgView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))

        // - Set Content mode to what you desire
        imgView.contentMode = .scaleAspectFill
        imgView2.contentMode = .scaleAspectFit

        // - Set Images
        imgView.image = bottomImage
        imgView2.image = topImage

        // - Create UIView
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))
        contentView.addSubview(imgView)
        contentView.addSubview(imgView2)

        // - Set Size
        let size = CGSize(width: 125, height: 125)

        // - Where the magic happens
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        //contentView.drawHierarchy(in: contentView.bounds, afterScreenUpdates: true)
        contentView.layer.render(in: UIGraphicsGetCurrentContext()!)
        //contentView.snapshotView(afterScreenUpdates: true)
        //guard
        let i = UIGraphicsGetImageFromCurrentImageContext()
            //let data = UIImageJPEGRepresentation(i, 1.0)
           // else {return nil}

        UIGraphicsEndImageContext()

        return i!
    }
    func makeStamp(parkName: String, date: String, attractionName: String, radius: CGFloat, color: UIColor)->UIImage
    {
        //if the bool parameter in below function is true, black background, no no
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        // *******************************************************************
        // Scale & translate the context to have 0,0
        // at the centre of the screen maths convention
        // Obviously change your origin to suit...
        // *******************************************************************
        context.translateBy(x: size.width / 2, y: size.height / 2)
        context.scaleBy(x: 1, y: -1)
        //context.addEllipse(in: CGRect(x:0, y:294, width: 250, height:250))
        //let rect = CGRect(x: -90, y: -100, width: 180, height: 180)
        //context.addEllipse(in: rect)
        //context.drawPath(using: .fill)
        centerArcPerpendicular(text: parkName, context: context, radius: radius, theta: .pi/2, color: color, font: UIFont.systemFont(ofSize: 16), clockwise: true)
        centerArcPerpendicular(text: attractionName, context: context, radius: radius, theta: CGFloat(3*Double.pi/2), color: color, font: UIFont.systemFont(ofSize: 16), clockwise: false)
        centre(text: date, context: context, radius: 0, theta: 0 , colour: color, font: UIFont(name:
                                                                                                "NFLChargers2007", size: 25)!, slantAngle: 0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}
