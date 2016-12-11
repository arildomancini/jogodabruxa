;Este arquivo é o arquivo principal de onde o programa deve ser chamado.
;A única modificação que deve ser feita neste arquivo são os nomes finais das funções chamadas
;dentro do big-bang e o nome final do EstadoMundo. As funções em si devem ser implementadas em "jogo.rkt".

#lang racket

(require 2htdp/image)
(require 2htdp/universe)
(require "jogo.rkt")   ;importa as funções definidas em "jogo.rkt"
(require "dados.rkt") ;importa as funções definidas em "dados.rkt"
(provide (all-defined-out)) ;permite que outros arquivos importem deste

;;*****************************************************************************************************************************
;; Jogo -> Jogo
;; inicie o mundo com (main JOGO-INICIAL-SURGINDO)    
(define (main j)                  
  (big-bang j                      ; Jogo  (estado inicial do jogo)
            (on-tick proximo-jogo) ; Jogo -> Jogo 
            (to-draw desenha-jogo)  ; EstadoInicaldoJogo -> Image   
                                          ;(retorna uma imagem que representa o estado atual do jogo)
            (on-key trata-tecla)    ; Arma KeyEvent -> arma
                                    ;(retorna um novo estado da arma dado o estado atual e uma interação com a tecla) 

            (on-release trata-tecla-release)))    
           

 