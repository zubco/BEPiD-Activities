//
//  MarvelApiRequest.swift
//  MarvelHeroes
//
//  Created by Gustavo Lima on 09/05/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit


/// Protocolo para retorno dos valores da API
@objc public protocol MarvelApiRequestDelegate: NSObjectProtocol
{
    @objc optional func didFinish(characters: [MarvelCharacter])
    @objc optional func didFail(data:Data?,response:URLResponse?, error:Error?)
}


/// Classe responsável por fazer uma requisição para a API da Marvel
/// Consulte https://developer.marvel.com/docs#!/public/getCreatorCollection_get_0 para 
/// um teste interativo das requisições suportadas pela API
public class MarvelApiRequest: NSObject {

    // Tipos de operacoes suportadas na API
    public enum Operation: String
    {
        case Characters
        case Comics
        case Creators
        case Events
        case Series
        case Stories
    }
    
    // Operacao corrente para essa request
    public let operation: Operation
    
    // Objeto de delegate para chamar os métodos do protocolo
    weak var delegate: MarvelApiRequestDelegate?
    
    // mapeamento do tipo de operação para a string da request da API
    fileprivate let apiMap:[Operation:String] =
        [.Characters:"/v1/public/characters",
         .Comics:"/v1/public/comics",
         .Creators:"/v1/public/creators",
         .Events:"/v1/public/events",
         .Series:"/v1/public/series",
         .Stories:"/v1/public/stories"]
    
    // caminho completo da API
    fileprivate let apiPath: String
    
    // parametros para serem chamados pela API
    public var parameters: [String:String]
    
    
    /// Init
    ///
    /// - Parameters:
    ///   - operation: tipo de operação para essa requisição
    ///   - parameters: dicionario de parametros a serem passados pela url
    public init(operation: Operation, parameters: [String:String]) {
        
        self.operation = operation
        self.apiPath = self.apiMap[operation]!
        self.parameters = parameters
        
        super.init()
    }
    
    
    /// Init de conveniência que seta também o delegate
    convenience init(operation: Operation, parameters: [String:String], delegate: MarvelApiRequestDelegate) {
        
        self.init(operation: operation, parameters: parameters)
        
        self.delegate = delegate
    }
    
    /// Executa essa requisição
    public func execute(){
        
        if let urlRequest = self.request(apiPath: self.apiPath, parameters: self.parameters)
        {
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            // cria uma task para a requisição da API
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in

                if error != nil {
                    self.fail(data: data,response: response, error: error)
                    return
                }
                
                guard let responseData = data else {
                    print("Error: did not receive data")
                    self.fail(data: data,response: response, error: error)
                    return
                }
                
                // recupera o objeto JSON a partir dos dados recebidos
                if let jsonObject = self.json(fromData: responseData)
                {
                    self.respond(json: jsonObject)
                }
            })
            
            // executa a requisição de fato
            task.resume()
        }
    }
    
    
    /// Responsavel por retornar para o objeto delegate a resposta recebida
    ///
    /// - Parameter json: json de resposta recebida
    fileprivate func respond(json: [String: AnyObject]) {
    
        if let delegate = self.delegate {
            
            switch self.operation {
                
                case .Characters:
                    
                    if let didFinish = delegate.didFinish
                    {
                        // faz o parse da resposta
                        let characters = self.parseCharacters(json: json)
                        
                        // retorna o objeto já parseado
                        DispatchQueue.main.async {
                            // precisamos garantir que executará na thread main
                            didFinish(characters)
                        }
                        
                    }
                    
                    break
                    
                default:
                    break
                    
            }
        }
    }
    
    
    /// Caso alguma falha ocorra, repassa o erro
    fileprivate func fail(data:Data?,response:URLResponse?, error:Error?)
    {
        if let delegate = self.delegate {
            
            if let didFail = delegate.didFail
            {
                DispatchQueue.main.async {
                    didFail(data, response, error)
                }
                
            }
        }
    }
    
    
    
    /// Cria uma URLRequest
    ///
    /// - Parameters:
    ///   - apiPath: caminho da API
    ///   - parameters: parametros a serem passados via URL
    /// - Returns: uma URLRequest para ser executada
    fileprivate func request(apiPath: String, parameters: [String:String]) -> URLRequest?
    {
        var params = parameters
        
        // internamente a API da Marvel sempre precisa de 3 parametros padrão
        
        // parametro ts obrigatório
        let timestamp = Date.timeIntervalSinceReferenceDate
        
        // calcula uma hash MD5 usando o timestamp, a chave privada e a chave pública 
        // necesários para a API
        let hashParameters = String(format: "%ld%@%@", timestamp, MarvelApiInfo.privateAPIKey,MarvelApiInfo.publicAPIKey)
        
        let hash = hashParameters.md5()

        // 3 Parametros obrigatórios de todas as requisições
        params["ts"] = String(format: "%ld", timestamp)
        
        params["hash"] = hash
        
        params["apikey"] = MarvelApiInfo.publicAPIKey
        
        var endpoint: String = MarvelApiInfo.server + apiPath + "?"
        
        // para cada parametro informado pelo usuário
        for paramName in params.keys
        {
            let paramValue = params[paramName]!
            
            // garante que o valor está encoded para evitar problemas com espaços em branco e outros caracteres
            let decodedValue = paramValue.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
            
            // formata o parâmetro para a URL
            let parameter = String(format: "&%@=%@", paramName, decodedValue)

            endpoint.append(parameter)
        }
        
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return nil
        }
        
        
        // cria e retorna a URLRequest
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }

    
    
    /// Retorna um objeto JSON a partir de um Data
    ///
    /// - Parameter fromData: Data recebido que contem a string JSON
    /// - Returns: dicionário com os dados do JSON
    fileprivate func json(fromData: Data) -> [String: AnyObject]?{
        
        var parsed:[String: AnyObject]  = [String: AnyObject]()
        
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: fromData, options: []) as? [String: AnyObject] else {
                print("error trying to convert data to JSON")
                return nil
            }
            
            parsed = jsonObject
            
        } catch  {
            print("error trying to convert data to JSON")
            return nil
        }
        
        return parsed
    }
    
    
    
    /// Parse do objeto json de resposta
    ///
    /// https://developer.marvel.com/docs#!/public/getCreatorCollection_get_0
    ///
    ///        {
    ///            "code": "int",
    ///            "status": "string",
    ///            "copyright": "string",
    ///            "attributionText": "string",
    ///            "attributionHTML": "string",
    ///            "data": {
    ///                "offset": "int",
    ///                "limit": "int",
    ///                "total": "int",
    ///                "count": "int",
    ///                "results": [
    ///                {
    ///                "id": "int",
    ///                "name": "string",
    ///                "description": "string",
    ///                "modified": "Date",
    ///                "resourceURI": "string",
    ///                "urls": [
    ///                {
    ///                "type": "string",
    ///                "url": "string"
    ///                }
    ///                ],
    ///                "thumbnail": {
    ///                "path": "string",
    ///                "extension": "string"
    ///                },
    ///                "comics": {
    ///                "available": "int",
    ///                "returned": "int",
    ///                "collectionURI": "string",
    ///                "items": [
    ///                {
    ///                "resourceURI": "string",
    ///                "name": "string"
    ///                }
    ///                ]
    ///                },
    ///                "stories": {
    ///                "available": "int",
    ///                "returned": "int",
    ///                "collectionURI": "string",
    ///                "items": [
    ///                {
    ///                "resourceURI": "string",
    ///                "name": "string",
    ///                "type": "string"
    ///                }
    ///                ]
    ///                },
    ///                "events": {
    ///                "available": "int",
    ///                "returned": "int",
    ///                "collectionURI": "string",
    ///                "items": [
    ///                {
    ///                "resourceURI": "string",
    ///                "name": "string"
    ///                }
    ///                ]
    ///                },
    ///                "series": {
    ///                "available": "int",
    ///                "returned": "int",
    ///                "collectionURI": "string",
    ///                "items": [
    ///                {
    ///                "resourceURI": "string",
    ///                "name": "string"
    ///                }
    ///                ]
    ///                }
    ///                }
    ///                ]
    ///            },
    ///            "etag": "string"
    ///        }
    ///
    /// - Parameter json: objeto json recebido da API da Marvel
    /// - Returns: Array de todos os objetos MarvelCharacter preenchidos com os resultados
    fileprivate func parseCharacters(json: [String: AnyObject]) -> [MarvelCharacter] {
        
        var characters = [MarvelCharacter]()
        
        let data = json["data"]!
        
        let results =  data["results"] as! [[String:Any]]
        
        for bio in results {
            
            let character = MarvelCharacter()
            
            character.name = bio["name"] as? String
            
            character.bioDescription = bio["description"] as? String
            
            let thumbnail = bio["thumbnail"] as! [String:String]
            
            let thumbnailPath = thumbnail["path"]!
            
            // garante que troca http por https para não ser necessário cadastro de exceção no Info.plist
            let secureThumbnailPath = thumbnailPath.replacingOccurrences(of: "http", with: "https")
            
            let image = String(format: "%@/detail.%@", secureThumbnailPath, thumbnail["extension"]!)
            
            character.thumbnailUrl = URL(string: image)

            character.copyright = json["attributionText"] as? String
            
            characters.append(character)
        }
        
        return characters
    }
}
