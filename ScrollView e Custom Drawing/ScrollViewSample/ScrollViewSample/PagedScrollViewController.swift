//
//  PagedScrollViewController.swift
//  ScrollViewSample
//
//  Created by Gustavo Lima on 5/2/15.
//  Copyright (c) 2015 bepid. All rights reserved.
//

import UIKit

class PagedScrollViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Carrega os arquivos .xib que contém o conteúdo das páginas que serão exibidas
        let page1: UIView! = Bundle.main.loadNibNamed("Page1", owner: self, options: nil)![0] as! UIView
        let page2: UIView! = Bundle.main.loadNibNamed("Page2", owner: self, options: nil)![0] as! UIView
        let page3: UIView! = Bundle.main.loadNibNamed("Page3", owner: self, options: nil)![0] as! UIView
        
        // cria um array com as paginas
        let pages: [UIView?] = [page1,page2,page3]

        // Inicializa o page control
        pageControl.currentPage = 0
        pageControl.numberOfPages = pages.count
        
        // Adicionar as páginas no scrollview
        for page in pages {
            
            // Calcula um novo frame para a página deslocando em X o tamanho de uma página
            // para colocar as views lado a lado
            page?.frame = (page?.frame.offsetBy(dx: scrollView.contentSize.width, dy: 0))!
            
            // adiciona a página na scrollview
            scrollView.addSubview(page!)
            
            // calcula o tamanho do conteúdo da scrollview
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width + self.view.frame.width, height: (page?.frame.height)!)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // calcula o numero da página baseado no quanto o scrollview está deslocado em X
        let page = floor(scrollView.contentOffset.x / self.view.frame.width)
        
        // Para atualizar o current page é necessário converter o float para Int
        pageControl.currentPage = Int(page)
    }

}
