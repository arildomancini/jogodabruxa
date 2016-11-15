#lang racket

;; Arquivo para definição dos tipos de dados do programa.
(require 2htdp/image)
(require 2htdp/universe)

;; Jean Carlos Neto Grr 2016 7741
;; Arildo Mancini Grr 2016 7512
;; Programa jogo mata a bruxa e seus bichos

;;***************************************************************************************************************************
(define-struct morcego (x dx))
;;Morcego é (make-morcego Natural Inteiro)
;;interp. representa a morcego que está numa posição x
;;da tela e anda a uma velocidade dx (dx também indica a direção
;;em que ela está apontando)

;exemplos:
(define ALVO-MOR-INICIAL (make-morcego 0 10))
(define ALVO-MOR-MEIO (make-morcego (/ LARGURA-CENARIO 2) 10))
(define ALVO-MOR-ANTES-VIRAR (make-morcego (+ LIMITE-DIR-MOR 5) 10))
(define ALVO-MOR-VIRADA (make-morcego LIMITE-DIR-MOR -10))
(define ALVO-MOR-MEIO-VORTANO (make-morcego (/ LARGURA-CENARIO 2) -10))
(define ALVO-MOR-CHEGANDO (make-morcego 50 -10))
(define ALVO-MOR-ULTRAPASSOU (make-morcego (+ LIMITE-DIR-MOR 20) 50))
(define ALVO-MOR-NO-LIMITE (make-morcego LIMITE-DIR-MOR -50))

;;*********************************************************************************************************
(define-struct bruxa (x dx))
;;Bruxa é (make-bruxa Natural Inteiro)
;;interp. representa a bruxa que está numa posição x
;;da tela e anda a uma velocidade dx (dx também indica a direção
;;em que ela está apontando)

;exemplos:
(define ALVO-BRUXA-INICIAL (make-bruxa 0 10))
(define ALVO-BRUXA-MEIO (make-bruxa (/ LARGURA-CENARIO 2) 10))
(define ALVO-BRUXA-ANTES-VIRAR (make-bruxa (+ LIMITE-DIR-BRU 5) 10))
(define ALVO-BRUXA-VIRADA (make-bruxa LIMITE-DIR-BRU -10))
(define ALVO-BRUXA-MEIO-VORTANO (make-bruxa (/ LARGURA-CENARIO 2) -10))
(define ALVO-BRUXA-CHEGANDO (make-bruxa 50 -10))
(define ALVO-BRUXA-ULTRAPASSOU (make-bruxa (+ LIMITE-DIR-BRU 20) 50))
(define ALVO-BRUXA-NO-LIMITE (make-bruxa LIMITE-DIR-BRU -50))

;;****************************************************************************************************************
(define-struct corvo (x dx))
;;Corvo é (make-corvo Natural Inteiro)
;;interp. representa a corvo que está numa posição x
;;da tela e anda a uma velocidade dx (dx também indica a direção
;;em que ela está apontando)

;exemplos:
(define ALVO-CORVO-INICIAL (make-corvo 0 10))
(define ALVO-CORVO-MEIO (make-corvo (/ LARGURA-CENARIO 2) 10))
(define ALVO-CORVO-ANTES-VIRAR (make-corvo (+ LIMITE-DIR-COR 5) 10))
(define ALVO-CORVO-VIRADA (make-corvo LIMITE-DIR-COR -10))
(define ALVO-CORVO-MEIO-VORTANO (make-corvo (/ LARGURA-CENARIO 2) -10))
(define ALVO-CORVO-CHEGANDO (make-corvo 50 -10))
(define ALVO-CORVO-ULTRAPASSOU (make-corvo (+ LIMITE-DIR-COR 20) 50))
(define ALVO-CORVO-NO-LIMITE (make-corvo LIMITE-DIR-COR -50))

#;
(define (fn-para-bruxa b)
  (... (bruxa-x b) (bruxa-dx b))
  )
;;*********************************************************************************************************************
(define-struct arma (x y))
;;Arma é (make-arma Natural Inteiro)
;;interp. representa a arma que está numa posição x
;;da tela e movimenta (x y) em que ela está apontando)
;;!!!
;; Arma é um desses (só pode ser um dos possíveis valores):
;;  - "esquerda"
;;  - "meio"
;;  - "direita"
;; interp. representa a posição da arma
;; dispensa exemplos

;;Template (modelo) para função que consome dados do tipo posiçao da arma
#;
(define (fn-para-posicao-arma pa)
  (cond [(string=? pa "esquerda") (... pa) ] 
        [(string=? pa "meio") (... pa)]    
        [(string=? pa "direita") (... pa)] 
        ))


;; ==================================================================================================================
;; ListaDeAlvos é um desses:
;; - empty       
;; - (cons Morcego Bruxa Corvo ListaDeAlvos)    
;; interp. uma lista de Alvos
(define LDMM-1 empty)
(define LDMM-2 (cons ALVO-MOR-INICIAL empty))
(define LDMM-3 (cons ALVO-MOR-INICIAL (cons ALVO-MOR-MEIO empty)))
(define LDBB-1 empty)
(define LDBB-2 (cons ALVO-BRUXA-INICIAL empty))
(define LDBB-3 (cons ALVO-BRUXA-INICIAL (cons ALVO-BRUXA-MEIO empty)))
(define LDCC-1 empty)
(define LDCC-2 (cons ALVO-CORVO-INICIAL empty))
(define LDCC-3 (cons ALVO-CORVO-INICIAL (cons ALVO-CORVO-MEIO empty)))

#;
(define (fn-para-ld-alvo ld-alvo)
  (cond [(empty? ld-alvo) (...)]                   ;CASO BASE (CONDIÇÃO DE PARADA)
        [else (... (first ld-alvo)                 ;Alvos
                   (fn-for-ld-alvo (rest ld-alvo)))])) ;RECURSÃO EM CAUDA


(define-struct jogo (arma alvos game-over?))
;; Jogo é (make-jogo Arma ListaDeAlvos Boolean)
;; interp. representa um jogo que tem uma arma
;; e VARIOS alvos.

(define JOGO-INICIAL (make-jogo ALVO-MOR-INICIAL
                                (list IMG-ARMA-MEIO)
                                #false))
(define JOGO-MEIO (make-jogo ALVO-MOR-ANTES-VIRAR
                                (list IMG-ARMA-MEIO)
                                #false))
(define JOGO-ZICA (make-jogo
                   (make-morcego (- (/ LARGURA-CENARIO 2)-5) 10)
                   (list IMG-ARMA-45-ESQ)
                   #false))
(define JOGO-ZICA-BRABA (make-jogo
                   (make-morcego (- (/ LARGURA-CENARIO 2)-5) 10)
                   (list IMG-ARMA-MEIO)
                   #true))
(define JOGO-ACABOU (make-jogo ALVO-MOR-ANTES-VIRAR
                               (list IMG-ARMA-45-ESQ)  
                               #true))

;(define JOGO-3-ALVOS (make-jogo ALVO-MOR-INICIAL
                                     ; (list IMG-ARMA-45-ESQ
                                         ;;   (make-arma
                                          ;   (* LARGURA-CENARIO 0.25)
                                          ;   0
                                           ;  (/ ALTURA-CENARIO 2)
                                           ;  DY-ARMA-DEFAULT)
                                           ; (make-arma
                                            ; (* LARGURA-CENARIO 0.75)
                                            ; 0
                                            ; (* ALTURA-CENARIO 0.25)
                                           ;  DY-ARMA-DEFAULT))
                                    ;  #false))

#;
(define (fn-para-jogo j)
  (... (jogo-arma j)
       (jogo-alvos j)
       (jogo-game-over? j)))
