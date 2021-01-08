//
//  APIModel.swift
//  RouterTestProject
//
//  Created by Rex Lin on 2021/1/8.
//  Copyright © 2021 Rex. All rights reserved.
//

import UIKit

protocol Convertable: Codable {
    
}

extension Convertable {
    func convertToDict() -> Dictionary<String, Any>? {
        var dict: Dictionary<String, Any>? = nil
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
        } catch {
            print("error: \(error)")
        }
        return dict
    }
}

struct IpDetail: Codable, Convertable {
    let ip: String?
    let bad: Bool?
    let type: String?
    let countryCode: String?
    let countryName: String?
    let latitude: Float?
    let longitude: Float?
    let city: String?
    let region: String?
    let asn: Int?
}

extension IpDetail {
    
    private enum CodingKeys: String, CodingKey {
        case ip             = "ip"
        case bad            = "bad"
        case type           = "type"
        case countryCode    = "countryCode"
        case countryName    = "countryName"
        case latitude       = "latitude"
        case longitude      = "longitude"
        case city           = "city"
        case region         = "region"
        case asn            = "asn"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ip = try? container.decodeIfPresent(String.self, forKey: .ip)
        bad = try? container.decodeIfPresent(Bool.self, forKey: .bad)
        type = try? container.decodeIfPresent(String.self, forKey: .ip)
        countryCode = try? container.decodeIfPresent(String.self, forKey: .countryCode)
        countryName = try? container.decodeIfPresent(String.self, forKey: .countryName)
        latitude = try? container.decodeIfPresent(Float.self, forKey: .latitude)
        longitude = try? container.decodeIfPresent(Float.self, forKey: .longitude)
        city = try? container.decodeIfPresent(String.self, forKey: .city)
        region = try? container.decodeIfPresent(String.self, forKey: .region)
        asn = try? container.decodeIfPresent(Int.self, forKey: .asn)
    }
}


struct RandomUser: Codable, Convertable {
    let results:Results?
    let info:Info?
}

extension RandomUser {
    
    private enum CodingKeys: String, CodingKey {
        case results    = "results"
        case info       = "info"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try? container.decodeIfPresent(Results.self, forKey: .results)
        info = try? container.decodeIfPresent(Info.self, forKey: .info)
    }
}


struct Results: Codable {
    let gender: String?
    let email: String?
    let phone: String?
    let cell: String?
    let nat: String?
}

extension Results {
    
    private enum CodingKeys: String, CodingKey {
        case gender    = "gender"
        case email     = "email"
        case phone     = "phone"
        case cell      = "cell"
        case nat       = "nat"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gender = try? container.decodeIfPresent(String.self, forKey: .gender)
        email = try? container.decodeIfPresent(String.self, forKey: .email)
        phone = try? container.decodeIfPresent(String.self, forKey: .phone)
        cell = try? container.decodeIfPresent(String.self, forKey: .cell)
        nat = try? container.decodeIfPresent(String.self, forKey: .nat)
    }
}


struct Info: Codable {
    let seed: String?
    let results: Int?
    let page: Int?
    let version: String?
}

extension Info {
    
    private enum CodingKeys: String, CodingKey {
        case seed       = "seed"
        case results    = "results"
        case page    = "page"
        case version    = "version"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        seed = try? container.decodeIfPresent(String.self, forKey: .seed)
        results = try? container.decodeIfPresent(Int.self, forKey: .results)
        page = try? container.decodeIfPresent(Int.self, forKey: .page)
        version = try? container.decodeIfPresent(String.self, forKey: .version)
    }
}
