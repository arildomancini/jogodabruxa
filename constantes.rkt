#lang racket

;; Arquivo para definição das constantes do programa.
(require 2htdp/image)
(require 2htdp/universe)

;; Jean Carlos Neto Grr 2016 7741
;; Arildo Mancini Grr 2016 7512
;; Programa jogo mata a bruxa e seus bichos

;inclua outros pacotes ou arquivos necessários usando (require ...)

(provide (all-defined-out)) ;permite que outros arquivos importem deste

;; =================
;; Constantes:
;; Constante dos alvos arma:

 (define ARMA (scale 0.5(bitmap "arma.png")))
 (define IMG-ARMA-MEIO (scale 0.5 (bitmap "arma1.png")))
 (define IMG-ARMA-45-ESQ (bitmap "arma.png"))
 (define IMG-ARMA-45-DIR (bitmap "arma2.png"))
 (define TEMPO-ARMA 2)
 (define ARMA-INICIAL "meio")
  
;; Constante do CENARIO:

 (define PAREDE (bitmap "paredes.png"))
 (define LARGURA-CENARIO 1200)
 (define ALTURA-CENARIO  800)
 (define CENARIO(empty-scene LARGURA-CENARIO ALTURA-CENARIO))
 (define CENARIO-CORRETO (place-image (beside PAREDE PAREDE) 0 (- ALTURA-CENARIO 200) CENARIO))
 (define TELA-GAME-OVER (overlay (text "GAME OVER" 30 "red") CENARIO))

;********************************************************************************************************************************  
;; Constante dos alvos morcego:

 (define IMG-ALVO-MOR-INO (scale 0.3(bitmap "morcego.png")))
 (define IMG-ALVO-MOR-VORTANO (flip-horizontal IMG-ALVO-MOR-INO))
 (define Y2 (/ ALTURA-CENARIO 2))
 (define MEIO-H-ALVO-MOR (/ (image-width IMG-ALVO-MOR-INO) 2 ))
 (define LIMITE-ESQ-MOR (- LARGURA-CENARIO MEIO-H-ALVO-MOR))
 (define LIMITE-DIR-MOR (- LARGURA-CENARIO MEIO-H-ALVO-MOR))

;*********************************************************************************************************************************
;; Constante dos alvos bruxa:

 (define IMG-ALVO-BRUXA-INO (scale 0.2(bitmap "bruxa.png")))
 (define IMG-ALVO-BRUXA-VORTANO (flip-horizontal IMG-ALVO-BRUXA-INO))
 (define Y (* ALTURA-CENARIO 0.25))
 (define MEIO-H-ALVO-BRUXA (/ (image-width IMG-ALVO-BRUXA-INO) 2 ))
 (define LIMITE-ESQ-BRU (- LARGURA-CENARIO MEIO-H-ALVO-BRUXA ))
 (define LIMITE-DIR-BRU (- LARGURA-CENARIO MEIO-H-ALVO-BRUXA ))
 
;***********************************************************************************************************************************
;; Constante dos alvos corvo:

 (define IMG-ALVO-COR-INO (scale 0.2 (bitmap "corvo.png")))
 (define IMG-ALVO-CORVO-VORTANO (flip-horizontal IMG-ALVO-COR-INO))
 (define Y3 (/ ALTURA-CENARIO 2))
 (define MEIO-H-ALVO-COR (/ (image-width IMG-ALVO-COR-INO) 2 ))
 (define LIMITE-ESQ-COR (- LARGURA-CENARIO MEIO-H-ALVO-COR))
 (define LIMITE-DIR-COR (- LARGURA-CENARIO MEIO-H-ALVO-COR))
 

;; =========================================================================================================
