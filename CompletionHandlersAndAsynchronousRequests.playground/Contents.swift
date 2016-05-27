//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

class ViewController : UIViewController {
    
    // Views that need to be accessible to all methods
    let jsonResult = UILabel()
    var pokemon = UILabel ()
    var pokemonWeight = UILabel()
    var pokemonWeightValue = UILabel()
    var pokemonType = UILabel()
    var pokemonTypeValue = UILabel()
    var pokemonHeight = UILabel()
    var pokemonHeightValue = UILabel()
    //let pokemonPick = UITextField()
    
    var currentPokemon = "383"
    var height = ""
    var name = ""
    var type = ""
    var weight = ""

    
    // If data is successfully retrieved from the server, we can parse it here
    func parseMyJSON(theData : NSData) {
        
        // Print the provided data
        print("")
        print("====== the data provided to parseMyJSON is as follows ======")
        print(theData)
        
        // De-serializing JSON can throw errors, so should be inside a do-catch structure
        do {
            
            // Do the initial de-serialization
            // Source JSON is here:
            // http://www.learnswiftonline.com/Samples/subway.json
            //
            let json = try NSJSONSerialization.JSONObjectWithData(theData, options: NSJSONReadingOptions.AllowFragments)
            
            guard let characterDetails: [String: AnyObject] = json as? [String:AnyObject] else {
                print ("coult not create dictionary")
                return
            }
            
            print("========")
            print(characterDetails)
            
            guard let characterName : String = characterDetails["name"] as? String else {
                print("could not get the character name")
                return
            }
            
            print("========")
            print(characterName)
            
            guard let characterHeight : Double = characterDetails["height"] as? Double else {
                print("could not get the height name as String")
                return
            }
            
            print("========")
            print(characterHeight)
            
            guard let characterHeightAsString : String = String(characterHeight) else {
                print("could not get the heigh name as string")
                return
            }

            print("========")
            print(characterHeightAsString)
            
            guard let characterWeight : Double = characterDetails["weight"] as? Double else {
                print("could not get the weight name")
                return
            }
            
            print("========")
            print(characterWeight)

            guard let characterWeightAsString : String = String(characterWeight) else {
                print("could not get the weight name as string")
                return
                
            }
            
            print("========")
            print(characterWeightAsString)
            
            guard let characterTypes : [AnyObject] = characterDetails["types"] as? [AnyObject] else {
                print("could not get the type")
                return
            }
            
            print("========")
            print(characterTypes)
            
            guard let typeData : [ String : AnyObject ] = characterTypes[0] as? [ String : AnyObject ] else {
                print("could not get the type data")
                return
            }

            print("========")
            print(typeData)
            
            guard let typeDetails : [ String : String ] = typeData["type"] as? [ String : String] else {
                print("could not get the type details")
                return
            }
            
            print("========")
            print(typeDetails)

            guard let characterSlotType : String = typeDetails["name"]! as String else {
                print ("could not get the type slot 1")
                return
            }
            
            print("========")
            print(characterSlotType)

            
            // Now we can update the UI
            // (must be done asynchronously)
            dispatch_async(dispatch_get_main_queue()) {
                //self.pokemon.text = name
                self.pokemonHeightValue.text = characterHeightAsString
                self.pokemonWeightValue.text = characterWeightAsString
                self.pokemonTypeValue.text = characterSlotType
            }
            
        } catch let error as NSError {
            print ("Failed to load: \(error.localizedDescription)")
        }
        
        
    }
    
    // Set up and begin an asynchronous request for JSON data
    func getMyJSON() {
        
        //if let pickText = Int(pokemonPick.text) {
        
        //currentPokemon = pokemonPick.text as String
            
        // Define a completion handler
        // The completion handler is what gets called when this **asynchronous** network request is completed.
        // This is where we'd process the JSON retrieved
        let myCompletionHandler : (NSData?, NSURLResponse?, NSError?) -> Void = {
            
            (data, response, error) in
            
            // This is the code run when the network request completes
            // When the request completes:
            //
            // data - contains the data from the request
            // response - contains the HTTP response code(s)
            // error - contains any error messages, if applicable
            
            // Cast the NSURLResponse object into an NSHTTPURLResponse objecct
            if let r = response as? NSHTTPURLResponse {
                
                // If the request was successful, parse the given data
                if r.statusCode == 200 {
        
                    // Show debug information (if a request was completed successfully)            
                    print("")
                    print("====== data from the request follows ======")
                    //print(data)
                    print("")
                    print("====== response codes from the request follows ======")
                    print(response)
                    print("")
                    print("====== errors from the request follows ======")
                    print(error)
            
                    if let d = data {
                        
                        // Parse the retrieved data
                        self.parseMyJSON(d)
                        
                    }
                    
                }
                
            }
            
        }
        
        // Define a URL to retrieve a JSON file from
        let address : String = "http://pokeapi.co/api/v2/pokemon/" + currentPokemon + "/"
        
        // Try to make a URL request object
        if let url = NSURL(string: address) {
            
            // We have an valid URL to work with
            print(url)
            
            // Now we create a URL request object
            let urlRequest = NSURLRequest(URL: url)
            
            // Now we need to create an NSURLSession object to send the request to the server
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            // Now we create the data task and specify the completion handler
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: myCompletionHandler)
            
            // Finally, we tell the task to start (despite the fact that the method is named "resume")
            task.resume()
            
        } else {
            
            // The NSURL object could not be created
            print("Error: Cannot create the NSURL object.")
            
        }
        
    }
    
    
    // This is the method that will run as soon as the view controller is created
    override func viewDidLoad() {
        
        // Sub-classes of UIViewController must invoke the superclass method viewDidLoad in their
        // own version of viewDidLoad()
        super.viewDidLoad()

        // Make the view's background be gray
        view.backgroundColor = UIColor.redColor()

        /*
         * Further define label that will show JSON data
         */
        
        // Set the label text and appearance
        pokemon.text = "Pokemon"
        pokemon.font = UIFont.systemFontOfSize(36)
        
        pokemon.translatesAutoresizingMaskIntoConstraints = false
        pokemon.textAlignment = NSTextAlignment.Center
        pokemon.textColor = UIColor.whiteColor()
        view.addSubview(pokemon)
        
        pokemon.textAlignment = .Center
        
        
        pokemonWeight.text = "Weight"
        pokemonWeight.font = UIFont.systemFontOfSize(24)
        pokemonWeight.translatesAutoresizingMaskIntoConstraints = false
        pokemonWeight.textAlignment = NSTextAlignment.Center
        pokemonWeight.textColor = UIColor.whiteColor()
        view.addSubview(pokemonWeight)
        
        pokemonWeight.textAlignment = .Center
        
        pokemonWeightValue.text = "..."
        pokemonWeightValue.font = UIFont.systemFontOfSize(16)
        pokemonWeightValue.translatesAutoresizingMaskIntoConstraints = false
        pokemonWeightValue.textAlignment = NSTextAlignment.Center
        pokemonWeightValue.textColor = UIColor.whiteColor()
        view.addSubview(pokemonWeightValue)
        
        pokemonWeightValue.textAlignment = .Center
        
        pokemonHeight.text = "Height"
        pokemonHeight.font = UIFont.systemFontOfSize(24)
        pokemonHeight.translatesAutoresizingMaskIntoConstraints = false
        pokemonHeight.textAlignment = NSTextAlignment.Center
        pokemonHeight.textColor = UIColor.whiteColor()
        view.addSubview(pokemonHeight)
        
        pokemonHeight.textAlignment = .Center
        
        pokemonHeightValue.text = "..."
        pokemonHeightValue.font = UIFont.systemFontOfSize(16)
        pokemonHeightValue.translatesAutoresizingMaskIntoConstraints = false
        pokemonHeightValue.textAlignment = NSTextAlignment.Center
        pokemonHeightValue.textColor = UIColor.whiteColor()
        view.addSubview(pokemonHeightValue)
        
        pokemonHeightValue.textAlignment = .Center
        
        pokemonType.text = "Type"
        pokemonType.font = UIFont.systemFontOfSize(24)
        view.addSubview(pokemonType)
        pokemonType.translatesAutoresizingMaskIntoConstraints = false
        pokemonType.textAlignment = NSTextAlignment.Center
        pokemonType.textColor = UIColor.whiteColor()
        
        pokemonType.textAlignment = .Center
        
        pokemonTypeValue.text = "..."
        pokemonTypeValue.font = UIFont.systemFontOfSize(16)
        view.addSubview(pokemonTypeValue)
        pokemonTypeValue.translatesAutoresizingMaskIntoConstraints = false
        pokemonTypeValue.textAlignment = NSTextAlignment.Center
        pokemonTypeValue.textColor = UIColor.whiteColor()
        
        pokemonTypeValue.textAlignment = .Center

        
        /*pokemonPick.placeholder = "Pokemon ID"
        pokemonPick.font = UIFont.systemFontOfSize(24)
        view.addSubview(pokemonType)
        pokemonPick.translatesAutoresizingMaskIntoConstraints = false
        pokemonPick.textAlignment = NSTextAlignment.Center
        
        view.addSubview(pokemonPick)*/
        
        jsonResult.text = "..."
        jsonResult.font = UIFont.systemFontOfSize(12)
        jsonResult.numberOfLines = 0   // makes number of lines dynamic
        // e.g.: multiple lines will show up
        jsonResult.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        jsonResult.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(jsonResult)

        /*
         * Add a button
         */
        let getData = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        
        // Make the button, when touched, run the calculate method
        getData.addTarget(self, action: #selector(ViewController.getMyJSON), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Set the button's title
        getData.setTitle("Find My Pokemon", forState: UIControlState.Normal)
        
        // Required to auto layout this button
        getData.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the button into the super view
        view.addSubview(getData)

        /*
         * Layout all the interface elements
         */
        
        // This is required to lay out the interface elements
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Create an empty list of constraints
        var allConstraints = [NSLayoutConstraint]()
        
        // Create a dictionary of views that will be used in the layout constraints defined below
        let viewsDictionary : [String : AnyObject] = [
            "title": jsonResult,
            "getData": getData,
            "Height" : pokemonHeight,
            "Weight" : pokemonWeight,
            "Type"   : pokemonType,
            "HeightValue" : pokemonHeightValue,
            "WeightValue" : pokemonWeightValue,
            "TypeValue" : pokemonTypeValue
            //"Pick"   : pokemonPick
        ]
        
        // Define the vertical constraints
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-50-[title]-[getData]-[Height]-[HeightValue]-[Weight]-[WeightValue]-[Type]-[TypeValue]",
            options: [],
            metrics: nil,
            views: viewsDictionary)
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[title][getData][Height][HeightValue][Weight][WeightValue][Type][TypeValue]",
            options: [],
            metrics: nil,
            views: viewsDictionary)
        allConstraints += horizontalConstraints
        
        // Add the vertical constraints to the list of constraints
        allConstraints += verticalConstraints
        
        // Activate all defined constraints
        NSLayoutConstraint.activateConstraints(allConstraints)
        
        print("Good to go")
        
    }
    
}

// Embed the view controller in the live view for the current playground page
XCPlaygroundPage.currentPage.liveView = ViewController()
// This playground page needs to continue executing until stopped, since network reqeusts are asynchronous
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
