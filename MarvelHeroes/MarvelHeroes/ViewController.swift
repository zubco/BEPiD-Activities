//
//  ViewController.swift
//  MarvelHeroes
//
//  Created by Gustavo Lima on 08/05/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MarvelApiRequestDelegate, UISearchBarDelegate {
    
    // Campo para busca
    @IBOutlet weak var sbHeroSearch: UISearchBar!
    
    // Informações do herói
    @IBOutlet weak var lblHeroName: UILabel!
    @IBOutlet weak var tvHeroBio: UITextView!
    @IBOutlet weak var ivHero: UIImageView!
    @IBOutlet weak var ivBackground: UIImageView!
    @IBOutlet weak var veDescription: UIVisualEffectView!
    @IBOutlet weak var lblCopyright: UILabel!
    
    // indicador de atividade
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let database = MarvelHeroesDatabase()
    
    /// Esconde a status Bar
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Carrega o iron man inicialmente
        // Se preferir coloque o nome do seu herói marvel favorito
        let parameters = ["name":"iron man"]
        
        // Prepara uma requisição se colocando como delegate
        let marvelRequest = MarvelApiRequest(operation: .Characters, parameters: parameters, delegate: self)

        // executa a requisição
        marvelRequest.execute()
        
        database.execute()
        
        // indicator de atividade
        activityIndicator.startAnimating()
    }

    
    /// Recebe a lista de herois para preencher na interface
    ///
    /// - Parameter characters: lista de herois
    func didFinish(characters: [MarvelCharacter]){
        
        self.sbHeroSearch.resignFirstResponder()
        
        // como pode retornar mais de 1 estamos preenchendo o primeiro retornado
        if let character = characters.first {
            
            // limpa o campo de busca
            self.sbHeroSearch.text = nil
            
            // preenche as informações do heroi
            self.lblHeroName.text = character.name
            
            // existem muitos herois que estão sem descrição. Caso não exista
            // descrição nós escondemos a view que deveria exibir a descrição
            self.veDescription.isHidden = character.bioDescription == nil || (character.bioDescription?.isEmpty)!
            
            self.tvHeroBio.text = character.bioDescription
            
            // baixa as imagens do heroi
            // task para baixar a imagem
            URLSession.shared.dataTask(with: character.thumbnailUrl!, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(String(describing:error))
                    return
                }
                
                // a imagem recebida presica ser preenchida na main queue
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    self.ivHero.image = image
                    self.ivBackground.image = image
                    self.activityIndicator.stopAnimating()
                })
                
            }).resume()
        
            
            // preenche o copyright
            self.lblCopyright.text = character.copyright
            
        } else {
            // hero not found
            
            self.lblHeroName.text = self.sbHeroSearch.text! + " not found."
            
            self.tvHeroBio.text = nil
            
            self.ivHero.image = nil
        }
        
    }
    
    
    /// Caso algum erro na chamada da API
    func didFail(data: Data?, response: URLResponse?, error: Error?) {
        activityIndicator.stopAnimating()
    }

    
    /// Busca um herói
    ///
    /// - Parameter searchBar: searchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        // caso alguma coisa tenha sido preenchida
        if let heroName = searchBar.text{
            
            // inicia uma requisição com o texto do campo da search bar
            let marvelRequest = MarvelApiRequest(operation: .Characters, parameters: ["nameStartsWith":heroName], delegate: self)
            
            marvelRequest.execute()
            
            activityIndicator.startAnimating()
        }
    }
    
    
    /// Detectar tap na view de backgorund
    ///
    /// - Parameter sender: sender
    @IBAction func backgroundTap(_ sender: Any) {
        
        // dispensar o teclado fazendo a search bar dispensar o foco
        self.sbHeroSearch.resignFirstResponder()
    }
}


