//
//  URLSessionFake.swift
//  BackpackTests
//
//  Created by Caroline Zaini on 21/07/2020.
//  Copyright © 2020 Caroline Zaini. All rights reserved.
//

import Foundation

/// Ce sont les doubles des classes responsable de l'appel réseau qui sont : URLSessionFake qui hérite de URLSession et URLSessionDataTaskFake qui hérite de URLSessionDataTask
/// On va doubler toutes les méthodes dont notre code a besoin pour fonctionner

// MARK: - URLSessionFake

class URLSessionFake : URLSession {
     
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    /// les instances vont être initialiser avec l'init. Les données qu'on va lui passer sont des données qu'on a créer dans FakeResponseData
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    /// On va doubler la méthode dataTask :
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        /// Create an  instance of URLSessionDataTaskFake to use our double :
        let task = URLSessionDataTaskFake()
        /// 2. On configure notre fausse task :
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        
        return task
    }
    
    // Variante de la func dataTask qui utilise URLRequest
    override func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
          /// 1. On crée une instance de URLSessionDataTaskFake pour utiliser notre double :
          let task = URLSessionDataTaskFake()
          /// 2. On configure notre fausse task :
          task.completionHandler = completionHandler
          task.data = data
          task.urlResponse = response
          task.responseError = error
          
          return task
      }
    
}


// MARK: - URLSessionDataTaskFake

class URLSessionDataTaskFake : URLSessionDataTask {
    /// On va doubler la méthode resume et cancel dont notre code a besoin pour fonctionner
    
    /// var completionHandler sera le bloc de retour : c'est une propriété qui aura le type du bloc de retour
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    
    /// Comme c'est instantané, resume ne doit pas lancer l'appel mais appeler directement le bloc de retour avec les données et la réponse donc le bloc (data, response, error) in ->  jusqu'à task?.resume() dans la func getExchange ou getTranslate ou getWeather
    /// Son rôle est simplement d'appeler le bloc de retour
    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
    
    /// Il n'y aura jamais d'appel en cours a annuler car cela a lieu instantanément. On laisse vide
    override func cancel() {}
    
}
