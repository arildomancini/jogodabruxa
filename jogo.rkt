; Este arquivo deve conter as definições das funções do jogo (com exceção da main).
; As definições devem incluir assinatura, propósito, protótipo e templates utilizados.

#lang racket

(require 2htdp/image)
(require 2htdp/universe)
(require "constantes.rkt") ;importa as constantes definidas no arquivo "constantes.rkt"
(require "dados.rkt") ;importa as definições de dados definidas no arquivo "dados.rkt"

;;Template (modelo) para função que consome dados do tipo ProximaArma
#;
(define (fn-para-proxima-arma pa)
  (cond [(string=? pa "esquerda") (... pa) ]
        [(string=? pa "direita") (... pa)]
        [(string=? pa "meio") (... pa)]
        ))
        
        ;; Proxima-arma -> Proxima-arma
;; retorna a próxima posição da arma

;(define (proxima-arma pa) pa)

(define (proxima-arma pa)
  (cond [(string=? pa "esquerda") "meio"]
        [(string=? pa "direita") "esquerda"]
        [(string=? pa "meio") "direita"]
        ))
;; Recebe uma posição-arma --> Imagem
;; Interp. a arma recebida e desenha a figura

;;(define (desenha-arma posicao-arma) IMG-ARMA-MEIO) ;STUB

(define (desenha-arma posicao-arma)
  (cond [ (string=? posicao-arma "esquerda") IMG-ARMA-45-ESQ]
        [(string=? posicao-arma "direita") IMG-ARMA-45-DIR]
        [(string=? posicao-arma "meio") IMG-ARMA-MEIO]
        ))
;;***********************************************************************************************************************
;; proximo-morcego : Morcego -> Morcego
;; recebe uma morcego na posicao x e retorna uma morcego com posição
;; x atualizada com o dx
;(define (proximo-morcego m) m)
(define (proximo-morcego m)
  (cond 
        [(> (morcego-x m) LIMITE-DIR-MOR)
         (make-morcego LIMITE-DIR-MOR (- (morcego-dx m)))]
        [(< (morcego-x m) 0)
         (make-morcego 0 (- (morcego-dx m)))]
        [else
         (make-morcego (+ (morcego-x m) (morcego-dx m))
             (morcego-dx m))])
 )
;;**********************************************************************************************************************
;; proxima-bruxa : Bruxa -> Bruxa
;; recebe uma bruxa na posicao x e retorna uma bruxa com posição
;; x atualizada com o dx
;(define (proxima-bruxa b) b)

(define (proxima-bruxa b)
  (cond 
        [(> (bruxa-x b) LIMITE-DIR-BRU)
         (make-bruxa LIMITE-DIR-BRU (- (bruxa-dx b)))]
        [(< (bruxa-x b) 0)
         (make-bruxa 0 (- (bruxa-dx b)))]
        [else
         (make-bruxa (+ (bruxa-x b) (bruxa-dx b))
             (bruxa-dx b))])
 )
;;*************************************************************************************************************************
;; proximo-corvo : Corvo -> Corvo
;; recebe uma corvo na posicao x e retorna uma corvo com posição
;; x atualizada com o dx

;(define (proxima-corvo c) c)

(define (proximo-corvo c)
  (cond 
        [(> (corvo-x c) LIMITE-DIR-COR)
         (make-corvo LIMITE-DIR-COR (- (corvo-dx c)))]
        [(< (corvo-x c) 0)
         (make-corvo 0 (- (corvo-dx c)))]
        [else
         (make-corvo (+ (corvo-x c) (corvo-dx c))
             (corvo-dx c))])
 )
;;****************************************************************************************************************************
;; distancia : Numero Numero Numero Numero -> Numero
;; calcula distancia
; !!!
(define (distancia x1 y1 x2 y2)
  (sqrt (+ (sqr (- x2 x1)) (sqr (- y2 y1)))))
;;***************************************************************************************************************************
;; Desenha-morcego: Morcego -> Image
;; retorna a representação do cenário com a morcego

;;Template
#;
(define (fn-para-morcego m)
  (... (morcego-x m) (morcego-dx m))
  )

(define (desenha-morcego m)
  (place-image
   (if (< (morcego-dx m) 0)
       IMG-ALVO-MOR-VORTANO
       IMG-ALVO-MOR-INO)
   (morcego-x m)
   Y
   CENARIO-CORRETO)
  )
;;******************************************************************************************************************************
;; Desenha-bruxa: Bruxa -> Image
;; retorna a representação do cenário com a bruxa

(define (desenha-bruxa b)
  (place-image
   (if (< (bruxa-dx b) 0)
       IMG-ALVO-BRUXA-VORTANO
       IMG-ALVO-BRUXA-INO)
   (bruxa-x b)
   Y
   CENARIO-CORRETO)
  )
;;*********************************************************************************************************************************
;; Desenha-corvo: Corvo -> Image
;; retorna a representação do cenário com a corvo

(define (desenha-corvo c)
  (place-image
   (if (< (corvo-dx c) 0)
       IMG-ALVO-CORVO-VORTANO
       IMG-ALVO-COR-INO)
   (corvo-x c)
   Y 
   CENARIO-CORRETO)
  )
;;**********************************************************************************************************************************

;; Proxima-arma KeyEvent -> Proxima-arma
;; quando teclar muda a posição da arma na tela

;; (define (trata-tecla ARMA ke) ARMA)  ;;stub

(define (trata-tecla-arma q ke)
  (cond [(key=? ke " ") "meio"]
        [else q]))  
