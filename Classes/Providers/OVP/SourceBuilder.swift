//
//  SourceBuilder.swift
//  Pods
//
//  Created by Rivka Peleg on 29/11/2016.
//
//

import UIKit

class SourceBuilder {


    var baseURL: String?
    var partnerId: Int64?
    var ks: String?
    var entryId: String?
    var flavors:[String]?
    var uiconfId:Int64?
    var format:String? = "url"
    var sourceProtocol:String? = "https"
    var playSessionId:String?
    

    func set(baseURL:String?) -> SourceBuilder {
        self.baseURL = baseURL
        return self
    }
    
    
    func set(partnerId:Int64?) -> SourceBuilder {
        self.partnerId = partnerId
        return self
    }
    
    func set(ks:String?) -> SourceBuilder {
        self.ks = ks
        return self
    }

    func set(entryId:String?) -> SourceBuilder {
        self.entryId = entryId
        return self
    }

    func set(flavors:[String]?) -> SourceBuilder {
        self.flavors = flavors
        return self
    }

    func set(uiconfId:Int64?) -> SourceBuilder {
        self.uiconfId = uiconfId
        return self
    }

    func set(format:String?) -> SourceBuilder {
        self.format = format
        return self
    }
    
    func set(sourceProtocol:String?) -> SourceBuilder {
        self.sourceProtocol = sourceProtocol
        return self
    }
    
    func set(playSessionId:String?) -> SourceBuilder {
        self.playSessionId = playSessionId
        return self
    }
    
    
    func build() -> URL? {
        
        guard let baseURL = self.baseURL, baseURL.isEmpty == false , let partnerId = self.partnerId, let entryId = self.entryId, let format = self.format, let sourceProtocol = self.sourceProtocol else {
            return nil
        }
        
        let fileExt = self.fileExtentionByFormat(format: format) 
        var urlAsString: String = baseURL + "/p/" + String(partnerId) + "/sp/" + String(partnerId) + "00/playManifest"
        
        if let ks = self.ks{
            urlAsString = urlAsString + "/ks/" + ks
        }
        
        
        var flavorsExist = false
        if let flavors = self.flavors {
            flavorsExist = true
            urlAsString = urlAsString + "/flavorIds/"
            var first = true
            for flavor in flavors{
                if ( first == false )
                {
                    urlAsString.append(",")
                }
                urlAsString.append(flavor)
                first = false
            }
            
        }
        
        if let uiconfId = self.uiconfId, flavorsExist == false{
            urlAsString.append("/uiConfId/" + String(uiconfId))
        }
        
        urlAsString = urlAsString + "/format/" + format + "/protocol/" + sourceProtocol + "/a." + fileExt
        
        
        var params: [String] = [String]()
        
        if let playSessionId = self.playSessionId{
            params.append("playSessionId=" + playSessionId)
        }
        
        if flavorsExist == true , let uiconfId = self.uiconfId {
            params.append("/uiConfId/" + String(uiconfId))
        }
        
        
        var isFirst = true
        for param in params{
           
            if ( isFirst){
              urlAsString.append("?")
            }else{
              urlAsString.append("&")
            }
            urlAsString.append(param)
            isFirst = false
        }
        
        return URL(string: urlAsString)
    }

    //
    func fileExtentionByFormat(format:String) -> String{
        
        switch format {
        case "applehttp":
            return "m3u8"
        case "mpegdash":
            return "mpd"
        case "url":
            return "mp4"
        default:
            return "mp4"
        }
    }

}
