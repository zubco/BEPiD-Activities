//
//  GraphicView.swift
//  CustomViewSample
//
//  Created by Gustavo Lima on 4/29/15.
//  Copyright (c) 2015 bepid. All rights reserved.
//

import UIKit

// @objc é necessário para possibilitar criarmos uma IBOutlet
@objc protocol GraphicViewDataSource : NSObjectProtocol{
    
    func numberOfDataPoints(in graphicView: GraphicView) -> Int
    
    func graphicView(_ graphicView: GraphicView, dataPointForIndex index: Int) -> Float
}

@IBDesignable class GraphicView: UIView {
    
    // O Correto seria usar GraphicViewDataSource no lugar de AnyObject porém Xcode ainda
    // não posibilita ligar a Outlet se não for AnyObject mesmo que o Objeto implemente o Protocolo
    @IBOutlet weak var dataSource: AnyObject!
    
    @IBInspectable var title:String!
    
    // Cores do gradiente de fundo
    @IBInspectable var startColor: UIColor = .orange
    @IBInspectable var endColor: UIColor = .red
    
    // dados de exemplo
    fileprivate var dataPoints:[Float] = [0.5, 0.5, 0.0, 0.5, 1.0, 0.5,0.5]
    
    func reloadData()
    {
        // avisa a view que ela precisa ser redesenhada
        self.setNeedsDisplay()
    }
    
    fileprivate func reloadDataPoints()
    {
        // Como nosso data source é AnyObject aqui somos obrigados
        // a verificar se ele implementa o Protocolo
        if dataSource is GraphicViewDataSource
        {
            // descobre o numero de pontos
            let dataCount:Int = dataSource.numberOfDataPoints(in:self)
            
            // inicia um Array to tamanho necessário
            dataPoints = [Float](repeating: 0.0, count: dataCount)
            
            // preenche com os dados do data source
            for index in 0..<dataCount
            {
                dataPoints[index] = dataSource.graphicView(self, dataPointForIndex: index)
            }
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        reloadDataPoints()
        
        // Drawing code
        
        // contexto gráfico
        let ctx:CGContext! = UIGraphicsGetCurrentContext()
        
        // Queremos cantos arredondados com raio 8.0
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 8.0)
        
        // Modifica a área de desenho do contexto atual deixando desenhável 
        // apenas a área definida pelo path
        path.addClip()
        
        // espaço de cores RGB
        let deviceColorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        
        // o tamanho do gráfico vai ocupar somente uma parte da view pois vamos deixar espaço 
        // para escrever um texto. vamos ocupar 4/5
        let desiredGraphSize:CGSize = CGSize(width: self.bounds.size.width * 4/5, height: self.bounds.size.height * 4/5);
        
        // e deixar 1/5 para as duas margens, ou seja cada margens será 1/10
        let margin = desiredGraphSize.width * 1/10 as CGFloat
        
        // Salva o Contexto inicial
        ctx.saveGState()
        
        // Escala o contexto para o tamanho desejado
        ctx.scaleBy(x: desiredGraphSize.width, y: desiredGraphSize.height)
        
        // Desenhar sem serrilhado
        ctx.setShouldAntialias(true)
        
        // Para iniciar o desenho devemos sempre começar pelo fundo e ir 
        // desenhando os elementos um por cima do outro
        
        // Cores para desenho do gradiente para o fundo
        let colors = [startColor.cgColor, endColor.cgColor]
        
        // extensão da área de transição das cores
        let colorLocations:[CGFloat] = [0.0, 1.0] // valores padrão
        
        // Cria o gradiente
        let gradient = CGGradient(colorsSpace: deviceColorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)
        
        // Desenha o gradiente
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x:0, y: 1)
        ctx?.drawLinearGradient(gradient!,
                                    start: startPoint,
                                    end: endPoint,
                                    options: .drawsAfterEndLocation)
        
        // Restaura o contexto para o mesmo estado inicial
        ctx.restoreGState()
        
        // Salva novamente
        ctx.saveGState()
        
        // Translada a margem em x e em y
        ctx.translateBy(x: margin, y: margin)
        
        // Mesmo que antes, porém precisa ser refeito porque o contexto foi restaurado
        // para um estado anterior a essa modificação
        ctx.scaleBy(x: desiredGraphSize.width, y: desiredGraphSize.height)
        
        // cor principal para desenho
        let pencilColor:UIColor = tintColor
        
        // define no contexto atual uma cor para ser usada no desenho
        pencilColor.set()
        
        // define sombra de cor da sombra como a cor de desenho com transparencia 50%
        let shadowColor = pencilColor.withAlphaComponent(0.5).cgColor
        
        // define a posição da sombra
        let shadowOffset = CGSize(width: 1, height: 1)
        
        // desenha a sombra com raio de blur 1
        ctx.setShadow(offset: shadowOffset, blur: 1, color: shadowColor)
        
        // Define que vamos desenhar uma linha com um Path ou seja ponto a ponto        
        let graphPath = UIBezierPath()
        
        var circles = [UIBezierPath]()
        
        // Aqui buscamos o ponto de mínimo e de máximo do gráfico
        // pois vamos normalizar os valores para o gráfico inteiro
        // ser exibido dentro da view
        let maximumSample:Float = dataPoints.max() ?? 1.0
        let minimumSample:Float = dataPoints.min() ?? 0.0
        
        var x: CGFloat = 0
        let count: CGFloat = CGFloat(dataPoints.count)
        
        for dataPoint in dataPoints
        {
            // normaliza os valores entre 0 e 1
            let normalizedX:CGFloat = x / count
            let normalizedY:CGFloat = 1 - CGFloat( (dataPoint - minimumSample) / (maximumSample - minimumSample))
            
            let point = CGPoint(x: normalizedX, y: normalizedY)
            if (x == 0) {
                // para o primeiro ponto de todos apenas vamos definir a posição inicial
                graphPath.move(to: point)
            } else
            {
                // Para os demais pontos será desenhado uma linha
                graphPath.addLine(to: point)
            }
            
            // cria um circulo para ser colocado no ponto
            let circle = UIBezierPath(arcCenter: point, radius: 0.011, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            
            // guarda em um array pois queremos que eles sejam uma das ultimas coisas 
            // a serem colocadas
            circles.append(circle)
            
            x += 1
        }
        
        // espessura da linha
        graphPath.lineWidth = 0.01
        
        // vamos criar um gradiente abaixo da linha do gráfico
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        // adicionamos uma linha para baixo
        clippingPath.addLine(to: CGPoint(x: graphPath.currentPoint.x,
                                         y: graphPath.currentPoint.y + margin))
        
        // fechamos o poligono
        clippingPath.close()
        
        // salva o contexto antes de fazer o clipping
        ctx.saveGState()
        
        // faz o clip
        clippingPath.addClip()
        
        // desenha o gradiente apenas na região que o clip definiu
        ctx.drawLinearGradient(gradient!,
                               start: startPoint,
                               end: endPoint,
                               options: .drawsAfterEndLocation)
        
        // desenha o a linha em todos os pontos
        graphPath.stroke()
        
        // restaura o contexto pois não queremos que a região de clip
        // afete o desenho dos circulos
        ctx.restoreGState()
        
        // desenha os circulos
        for circle in circles{
            circle.fill()
        }
        
        // restaura o contexto inicial
        ctx.restoreGState()

        if self.title != nil
        {
            // Alinhamento do texto
            let textStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            textStyle.alignment = .right
            textStyle.lineBreakMode = .byClipping
            
            // Atritutos da fonte
            let textFontAttributes = [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
                NSForegroundColorAttributeName: pencilColor,
                NSBackgroundColorAttributeName: UIColor.clear,
                NSBaselineOffsetAttributeName: 0,
                NSParagraphStyleAttributeName: textStyle
            ] as [String : Any]
            
            // Calcula o tamanho mínimo para o texto ser exibido
            let textSize:CGSize = title.size(attributes: textFontAttributes)
            
            // Desenha o texto 
            title.draw(in: self.bounds.insetBy(dx: 10, dy: (self.bounds.height - textSize.height) / 2),withAttributes: textFontAttributes)
        }
        
        
        // Desenha linhas horizontais
        let linePath = UIBezierPath()
        
        let linesRect = CGRect(origin: CGPoint(x:margin,y:margin), size: desiredGraphSize)
        
        // linha do topo
        var y = linesRect.origin.y
        
        linePath.move(to: linesRect.origin)
        linePath.addLine(to: CGPoint(x: linesRect.size.width, y: y))
        
        // linha da base
        y = linesRect.size.height + linesRect.origin.y
        
        linePath.move(to:    CGPoint(x: linesRect.origin.x, y: y))
        linePath.addLine(to: CGPoint(x: linesRect.size.width, y: y))
        
        // linha do centro
        y = self.bounds.height / 2
        
        linePath.move(to:    CGPoint(x: linesRect.origin.x, y: y))
        linePath.addLine(to: CGPoint(x: linesRect.size.width, y: y))
        
        // cor de desenho das linhas cor pencil com 30% de transparência
        let color = pencilColor.withAlphaComponent(0.3)
        
        // seta a cor no contexto corrente
        color.setStroke()
        
        // seta a espessura da linha
        linePath.lineWidth = 1.0
        
        // desenha o path das linhas
        linePath.stroke()

    }
    
    
}
