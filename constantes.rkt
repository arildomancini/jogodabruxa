#lang racket

;; Arquivo para definição das constantes do programa.
(require rackunit)
(require 2htdp/image)
(require 2htdp/universe)
(require racket/list)
(provide (all-defined-out)) ;permite que outros arquivos importem deste
;; Jean Carlos Neto Grr 2016 7741
;; Arildo Mancini Grr 2016 7512
;; Programa jogo mata a bruxa e seus bichos
;; ============================================================================================================================
;;CONSTANTES:

;; Constante do cenario:
(define LARGURA-CENARIO 1200)
(define ALTURA-CENARIO 700)
(define X (/ LARGURA-CENARIO 2))
(define Y (/ ALTURA-CENARIO 2))
(define Y-PADRAO 200)
(define PAREDE (bitmap "paredes.png" ))
(define FUNDO (scale/xy 4.65 3.66 (bitmap "Fundo.jpg" )))
(define CENARIO (rectangle LARGURA-CENARIO ALTURA-CENARIO "outline" "black")) 
(define TELA-JOGO (place-image (beside PAREDE PAREDE) 0 (+ ALTURA-CENARIO 60) FUNDO))
(define GAME-OVER (scale 2.1(bitmap "Acabou.png")))
;;*******************************************
;; Constante do tiro 
(define IMG-TIRO (ellipse 10 5 "solid" "black"))
(define MEIO-W-TIRO (/ (image-width IMG-TIRO) 2 ))

;;*******************************************
;; Constante da bruxa:
(define IMG-BRUXA-INO (flip-horizontal(scale 0.1 (bitmap "bruxa.png"))))
(define IMG-BRUXA-VOLTANDO (flip-horizontal IMG-BRUXA-INO))
(define DY-B-DEFAULT 5)

;;******************************************* 
;; Constante do morcego:
 (define IMG-MOR-INO (scale 0.3(bitmap "morcego.png"))) 
 (define IMG-MOR-VOLTANDO (flip-horizontal IMG-MOR-INO))
 (define MEIO-H-MOR (/ (image-width IMG-MOR-INO) 2 ))
 (define LIMITE-ESQ-MOR (- LARGURA-CENARIO MEIO-H-MOR))
 (define LIMITE-DIR-MOR (- LARGURA-CENARIO MEIO-H-MOR))

;;*******************************************
;;; Constante do corvo:
 (define IMG-COR-INO (scale 0.2 (bitmap "corvo.png")))
 (define IMG-CORVO-VOLTANDO (flip-horizontal IMG-COR-INO))
 (define MEIO-H-COR (/ (image-width IMG-COR-INO) 2 ))
 (define LIMITE-ESQ-COR (- LARGURA-CENARIO MEIO-H-COR))
 (define LIMITE-DIR-COR (- LARGURA-CENARIO MEIO-H-COR)) 
;;*******************************************
;;; Constante da Fada:
 (define IMG-FAD-INO (scale 0.2 (bitmap "fada.png")))
 (define IMG-FAD-VOLTANDO (flip-horizontal IMG-FAD-INO))
 (define MEIO-H-FAD (/ (image-width IMG-FAD-INO) 2 ))
 (define LIMITE-ESQ-FAD (- LARGURA-CENARIO MEIO-H-FAD))
 (define LIMITE-DIR-FAD (- LARGURA-CENARIO MEIO-H-FAD)) 
;;*******************************************
;; constante da arma
(define IMG-ARMA-INO (scale 0.2 (bitmap "arma1.png"))) 
(define IMG-ARMA-VOLTANDO (flip-horizontal IMG-ARMA-INO))
(define MEIO-W-ARMA (/ (image-width IMG-ARMA-INO) 2 ))
(define MEIO-A-ARMA (/ (image-height IMG-ARMA-INO) 2 ))
(define LIMITE-DIREITO (- LARGURA-CENARIO MEIO-W-ARMA))
(define LIMITE-BAIXO (- ALTURA-CENARIO MEIO-A-ARMA)) 
(define LIMITE-ESQUERDO MEIO-W-ARMA)
(define D-ARMA-DEFAULT 10)

(define X-SURGIR  LIMITE-DIREITO)
;;================================================================================================================================ 