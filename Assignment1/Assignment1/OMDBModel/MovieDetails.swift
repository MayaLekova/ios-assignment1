/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class MovieDetails {
	public var title : String?
	public var year : Int?
	public var rated : String?
	public var released : String?
	public var runtime : String?
	public var genre : String?
	public var director : String?
	public var writer : String?
	public var actors : String?
	public var plot : String?
	public var language : String?
	public var country : String?
	public var awards : String?
	public var poster : String?
	public var metascore : Int?
	public var imdbRating : Double?
	public var imdbVotes : String?
	public var imdbID : String?
	public var type : String?
	public var response : Bool?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Json4Swift_Base]
    {
        var models:[Json4Swift_Base] = []
        for item in array
        {
            models.append(Json4Swift_Base(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {

		title = dictionary["Title"] as? String
		year = dictionary["Year"] as? Int
		rated = dictionary["Rated"] as? String
		released = dictionary["Released"] as? String
		runtime = dictionary["Runtime"] as? String
		genre = dictionary["Genre"] as? String
		director = dictionary["Director"] as? String
		writer = dictionary["Writer"] as? String
		actors = dictionary["Actors"] as? String
		plot = dictionary["Plot"] as? String
		language = dictionary["Language"] as? String
		country = dictionary["Country"] as? String
		awards = dictionary["Awards"] as? String
		poster = dictionary["Poster"] as? String
		metascore = dictionary["Metascore"] as? Int
		imdbRating = dictionary["imdbRating"] as? Double
		imdbVotes = dictionary["imdbVotes"] as? String
		imdbID = dictionary["imdbID"] as? String
		type = dictionary["Type"] as? String
		response = dictionary["Response"] as? Bool
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.title, forKey: "Title")
		dictionary.setValue(self.year, forKey: "Year")
		dictionary.setValue(self.rated, forKey: "Rated")
		dictionary.setValue(self.released, forKey: "Released")
		dictionary.setValue(self.runtime, forKey: "Runtime")
		dictionary.setValue(self.genre, forKey: "Genre")
		dictionary.setValue(self.director, forKey: "Director")
		dictionary.setValue(self.writer, forKey: "Writer")
		dictionary.setValue(self.actors, forKey: "Actors")
		dictionary.setValue(self.plot, forKey: "Plot")
		dictionary.setValue(self.language, forKey: "Language")
		dictionary.setValue(self.country, forKey: "Country")
		dictionary.setValue(self.awards, forKey: "Awards")
		dictionary.setValue(self.poster, forKey: "Poster")
		dictionary.setValue(self.metascore, forKey: "Metascore")
		dictionary.setValue(self.imdbRating, forKey: "imdbRating")
		dictionary.setValue(self.imdbVotes, forKey: "imdbVotes")
		dictionary.setValue(self.imdbID, forKey: "imdbID")
		dictionary.setValue(self.type, forKey: "Type")
		dictionary.setValue(self.response, forKey: "Response")

		return dictionary
	}

}
