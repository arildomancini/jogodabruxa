;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname Alvo) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)
;; Jean Carlos Neto Grr 2016 7741
;; Arildo Mancini Grr 2016 7512
;; Programa jogo mata a bruxa e seus bichos

;; ============================================================================================================================
;; Constante dos alvos arma:

 ;(define ARMA (scale 0.5(bitmap "arma.png")))
 (define IMG-ARMA-MEIO (scale 0.4 (bitmap "arma1.png")))
 (define IMG-ARMA-ESQ (scale 0.4 (bitmap "arma.png")))
 (define IMG-ARMA-DIR (scale 0.4 (bitmap "arma2.png")))
 (define TEMPO-ARMA 2)
 (define ARMA-INICIAL "meio")
  

;; Constante do CENARIO:

 (define PAREDE (bitmap "paredes.png"))
 (define LARGURA-CENARIO 1200) 
 (define ALTURA-CENARIO  700)
 (define CENARIO(empty-scene LARGURA-CENARIO ALTURA-CENARIO))
 (define CENARIO-CORRETO (place-image (beside PAREDE PAREDE) 0 (- ALTURA-CENARIO 100) CENARIO))
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
;; Definições de dados:

(define-struct morcego (x dx))
;;Morcego é (make-morcego Natural Inteiro)
;;interp. representa a morcego que está numa posição x
;;da tela e anda a uma velocidade dx (dx também indica a direção
;;em que ela está apontando)

;exemplos:
(define ALVO-MOR-INICIAL (make-morcego 100 10))
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
(define ALVO-BRUXA-INICIAL (make-bruxa 0 15))
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
(define ALVO-CORVO-INICIAL (make-corvo 200 5))
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


;;**************************************************************************************************************************
(define-struct jogo (arma morcego bruxa corvo))
;; Jogo é (make-jogo Arma Morcego Bruxa Corvo)
;; interp. representa um jogo que tem arma
;; e VARIOS alvos
(define JOGO-INICIO (make-jogo IMG-ARMA-MEIO
                     ALVO-MOR-INICIAL
                     ALVO-BRUXA-INICIAL
                     ALVO-CORVO-INICIAL
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





;;==========================================================================================================================
;; Funções:



;;*****************************************************************************************************************************
;; Proxima-arma -> Proxima-arma
;; retorna a próxima posição da arma

;(define (proxima-arma pa) pa)

(define (proxima-arma pa)
  
  (cond [(string=? pa "esquerda") "meio"]
        [(string=? pa "direita") "esquerda"]
        [(string=? pa "meio") "direita"]
        ))
  
;;Exemplo/Teste
(check-expect (proxima-arma "esquerda") "meio")
(check-expect (proxima-arma "meio") "direita")
(check-expect (proxima-arma "direita") "esquerda")
;;****************************************************************************************************************************
 



;;*******************************************************************************************************************************
;; Recebe uma posição-arma --> Imagem
;; Interp. a arma recebida e desenha a figura

;;(define (desenha-arma posicao-arma) IMG-ARMA-MEIO) ;STUB

(define (desenha-arma posicao-arma) 
  (cond [(image? posicao-arma) (place-image IMG-ARMA-ESQ (/ LARGURA-CENARIO 2) (- ALTURA-CENARIO (image-height IMG-ARMA-ESQ))  CENARIO-CORRETO)]
        [(image? posicao-arma) (place-image IMG-ARMA-DIR  (/ LARGURA-CENARIO 2) (- ALTURA-CENARIO (image-height IMG-ARMA-DIR)) CENARIO-CORRETO)] 
        [(image? posicao-arma) (place-image IMG-ARMA-MEIO (/ LARGURA-CENARIO 2) (- ALTURA-CENARIO (image-height IMG-ARMA-MEIO)) CENARIO-CORRETO)] 
        ))

;;Exemplo/Teste



;;;PROF. precisava de monitoria para o teste e não consegui.





;;***********************************************************************************************************************************
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
; exemplos / testes
;casos em que ele anda pra direita sem chegar no limite 
(check-expect (proximo-morcego (make-morcego 0 10))
              (make-morcego 10 10)) 
(check-expect (proximo-morcego ALVO-MOR-MEIO)
              (make-morcego (+ (/ LARGURA-CENARIO 2) 10)
                         10))
; casos em que chega no limite direito e tem que virar
(check-expect (proximo-morcego ALVO-MOR-ANTES-VIRAR)
              ALVO-MOR-VIRADA)
(check-expect (proximo-morcego ALVO-MOR-ULTRAPASSOU)
                            ALVO-MOR-NO-LIMITE)
; caso em que ele anda pra esquerda sem chegar no limite 
(check-expect (proximo-morcego ALVO-MOR-MEIO-VORTANO)
                            (make-morcego (- (/ LARGURA-CENARIO 2) 10)
                                       -10))

; casos em que chega no limite esquerdo e tem que virar
(check-expect (proximo-morcego (make-morcego -10 -10))
                            (make-morcego 0 10))
(check-expect (proximo-morcego (make-morcego -20 -50))
                            (make-morcego 0 50))

;;************************************************************************************************************************

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
; exemplos / testes
;casos em que ela anda pra direita sem chegar no limite
(check-expect (proxima-bruxa (make-bruxa 0 10))
              (make-bruxa 10 10)) 
(check-expect (proxima-bruxa ALVO-BRUXA-MEIO)
              (make-bruxa (+ (/ LARGURA-CENARIO 2) 10)
                         10))
; casos em que chega no limite direito e tem que virar
(check-expect (proxima-bruxa ALVO-BRUXA-ANTES-VIRAR)
              ALVO-BRUXA-VIRADA)
(check-expect (proxima-bruxa ALVO-BRUXA-ULTRAPASSOU)
                            ALVO-BRUXA-NO-LIMITE)
; caso em que ela anda pra esquerda sem chegar no limite 
(check-expect (proxima-bruxa ALVO-BRUXA-MEIO-VORTANO)
                            (make-bruxa (- (/ LARGURA-CENARIO 2) 10)
                                       -10))

; casos em que chega no limite esquerdo e tem que virar
(check-expect (proxima-bruxa (make-bruxa -10 -10))
                            (make-bruxa 0 10))
(check-expect (proxima-bruxa (make-bruxa -20 -50))
                            (make-bruxa 0 50))

;;**********************************************************************************************************************

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


; exemplos / testes
;casos em que ele anda pra direita sem chegar no limite
(check-expect (proximo-corvo (make-corvo 0 10))
              (make-corvo 10 10))
(check-expect (proximo-corvo ALVO-CORVO-MEIO)
              (make-corvo (+ (/ LARGURA-CENARIO 2) 10)
                         10))
; casos em que chega no limite direito e tem que virar
(check-expect (proximo-corvo ALVO-CORVO-ANTES-VIRAR)
              ALVO-CORVO-VIRADA)
(check-expect (proximo-corvo ALVO-CORVO-ULTRAPASSOU)
                            ALVO-CORVO-NO-LIMITE)
; caso em que ele anda pra esquerda sem chegar no limite 
(check-expect (proximo-corvo ALVO-CORVO-MEIO-VORTANO)
                            (make-corvo (- (/ LARGURA-CENARIO 2) 10)
                                       -10))

; casos em que chega no limite esquerdo e tem que virar
(check-expect (proximo-corvo (make-corvo -10 -10))
                            (make-corvo 0 10))
(check-expect (proximo-corvo (make-corvo -20 -50))
                            (make-corvo 0 50))

;;**************************************************************************************************************************
;; distancia : Numero Numero Numero Numero -> Numero
;; calcula distancia
; !!!
(define (distancia x1 y1 x2 y2)
  (sqrt (+ (sqr (- x2 x1)) (sqr (- y2 y1)))))

(check-expect (distancia 3 0 0 4) 5)

;;****************************************************************************************************************************
;; proximo-jogo : Jogo -> Jogo
;; atualiza o jogo
;(define (proximo-jogo j)  j)

(define (proximo-jogo j)
  (make-jogo (jogo-arma j)
              (proximo-morcego (jogo-morcego j))   
              (proxima-bruxa (jogo-bruxa j)) 
              (proximo-corvo (jogo-corvo j))))

;;Exemplo/Teste

;;;PROF. precisava de monitoria para o teste e não consegui.



;;******************************************************************************************************************************

;; Desenha-morcego: Morcego -> Image
;; retorna a representação do cenário com a morcego

(define (desenha-morcego m)
  (place-image
   (if (< (morcego-dx m) 0)
       IMG-ALVO-MOR-VORTANO
       IMG-ALVO-MOR-INO)
   (morcego-x m)
   100
   (rectangle LARGURA-CENARIO ALTURA-CENARIO "outline" "black"))
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
   300
   (rectangle LARGURA-CENARIO ALTURA-CENARIO "outline" "black"))
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
     (rectangle LARGURA-CENARIO ALTURA-CENARIO "outline" "black"))
  )

;;************************************************************************************************************************************
;; Desenha-jogo: AlvosArma -> Image
;; retorna a representação do cenário com a arma e os alvos

(define (desenha-jogo j)
  (overlay
   (desenha-corvo (jogo-corvo j))
   (desenha-morcego (jogo-morcego j))
   (desenha-bruxa (jogo-bruxa j))
   (desenha-arma (jogo-arma j))    
   ))

;;****************************************************************************************************************************************************
;; Jogo -> Jogo
;; inicie o mundo com jogo-inicio
(define main
  (big-bang JOGO-INICIO   
            (on-tick proximo-jogo)
            (to-draw desenha-jogo)
         ))
;;*****************************************************************************************************************************
;; Proxima-arma KeyEvent -> Proxima-arma
;; quando teclar muda a posição da arma na tela

 (define (trata-tecla ARMA ke) ARMA)  ;;stub

(define (trata-tecla-arma q ke)
  (cond [(key=? ke " ") "meio"]
       [else q]))

;;exemplos
(check-expect (trata-tecla-arma IMG-ARMA-ESQ " ") "meio")
(check-expect (trata-tecla-arma ARMA-INICIAL "0") ARMA-INICIAL)
;;************************************************************************************************************************************************

