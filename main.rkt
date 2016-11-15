;Este arquivo é o arquivo principal de onde o programa deve ser chamado.
;A única modificação que deve ser feita neste arquivo são os nomes finais das funções chamadas
;dentro do big-bang e o nome final do EstadoMundo. As funções em si devem ser implementadas em "jogo.rkt".

#lang racket

(require 2htdp/image)
(require 2htdp/universe)
(require "jogo.rkt")   ;importa as funções definidas em "jogo.rkt" 

;;*****************************************************************************************************************************
;; Morcego -> Morcego
;; inicie o mundo com (main-morcego ALVO-MOR-INICIAL)
(define (main-morcego m)
           (big-bang m                ; Morcego   (estado inicial do mundo)
           (on-tick   proximo-morcego) ; Morcego -> Morcego
                                       ;retorna a proxima morcego
                                 
            (to-draw   desenha-morcego) ; Morcego -> Image   
                                          ;retorna a imagem da morcego 
           ))

;;*********************************************************************************************************************

;; Bruxa -> Bruxa
;; inicie o mundo com (main-bruxa ALVO-BRUXA-INICIAL)
(define (main-bruxa b)
           (big-bang b               ; Bruxa   (estado inicial do mundo)
           (on-tick   proxima-bruxa) ; bruxa -> bruxa
                                     ; retorna a proxima bruxa
                                 
            (to-draw   desenha-bruxa) ; Bruxa -> Image   
                                          ;retorna a imagem da bruxa
           ))
;;*********************************************************************************************************************

;; Corvo -> Corvo
;; inicie o mundo com (main-corvo ALVO-CORVO-INICIAL)
(define (main-corvo c)
           (big-bang c               ; CORVO-INICIAL (estado inicial)
           (on-tick   proximo-corvo) ; corvo -> corvo
                                     ; retorna a proximo corvo
                                 
            (to-draw   desenha-corvo) ; Corvo -> Image   
                                          ;retorna a imagem da corvo
           ))

;;**********************************************************************************************************************************
;; Proxima-arma -> Proxima-arma
;; inicie o mundo com ...

(define (main-arma ARMA-INICIAL)
  (big-bang ARMA-INICIAL               ; Arma   (estado inicial do mundo)
            (on-tick   proxima-arma TEMPO-ARMA)     ; Arma -> Arma    
                                 
            (to-draw   desenha-arma)   ; Arma -> Image   
                                          
            (on-key    trata-tecla-arma)))    ; Arma KeyEvent -> Arma
