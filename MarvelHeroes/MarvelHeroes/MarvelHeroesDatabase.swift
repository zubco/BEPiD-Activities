//
//  MarvelHeroesDatabase.swift
//  MarvelHeroes
//
//  Created by Gustavo Lima on 11/05/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class MarvelHeroesDatabase: NSObject {
    
    // TODO: Implementar esta classe com a responsabilidade de baixar todos os heróis
    // retornados pela API (1485 até esse momento)
    
    // Dicas:
    //
    // - Você precisará fazer várias requisições para recuperar todos os heróis, faça uso do mecanismo
    //   de delegate nessa classe para só responder quando todos heróis estiverem carregados
    //
    // - Como a API da Marvel só suporta 3000 requisições por dia é interessante você persistir 
    //   localmente os heróis para minimizar o número de requisições
    //
    // - Você pode usar o UserDefaults como persistência, é uma forma mais simples e primitiva 
    //   de persistir valores, mas pode ser usada para guardar o json de retorno das requisições
    //   Para recuperar: UserDefaults.standard.object(forKey: "key")
    //   Para salvar:    UserDefaults.standard.set(jsonDObject, forKey: "key")
    //
    // - API da marvel suporta até 100 heróis por requisição, use o parâmetro limit=100
    //   Faça uma MarvelApiRequest(operation: .Characters, parameters: parametros) sem parâmetro de name
    //   para retornar todos os heróis e use o parâmetro offset para recuperar de 100 em 100
    // 
    // - A API retorna um count, quando o offset chegar no fim dos resultados o count será zero, isso
    //   pode ser usado de condição para parar as requisições

}
