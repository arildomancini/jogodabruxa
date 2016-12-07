#lang racket

(require racket/math)  ;para poder usar funcoes trigonometricas
(require 2htdp/universe)
(require racket/list)
(require 2htdp/image)
;; Jean Carlos Neto Grr 2016 7741
;; Arildo Mancini Grr 2016 7512
;; Programa Jogo Mata Bruxas/Morcegos/Corvos

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
(define Y-SURGIR (* ALTURA-CENARIO 0.25))  
;;================================================================================================================================             
;;DEFINIÇÕES DE DADOS

(define-struct morcego (x dx y))
;;Morcego é (make-morcego Natural Inteiro)
;;interp. representa a morcego que está numa posição x
;;da tela e anda a uma velocidade dx (dx também indica a direção
;;em que ela está apontando)
;exemplos:
(define MOR-INICIAL (make-morcego (/ LARGURA-CENARIO 2) 10 Y-PADRAO))
(define MOR-MEIO (make-morcego (/ LARGURA-CENARIO 2) 10 Y-PADRAO))
(define MOR-ANTES-VIRAR (make-morcego (+ LIMITE-DIR-MOR 5) 10 Y-PADRAO))
(define MOR-VIRADA (make-morcego LIMITE-DIR-MOR -10 Y-PADRAO))
(define MOR-MEIO-VOLTANDO (make-morcego (/ LARGURA-CENARIO 2) -10 Y-PADRAO))
(define MOR-CHEGANDO (make-morcego 50 -10 Y-PADRAO))
(define MOR-ULTRAPASSOU (make-morcego (+ LIMITE-DIR-MOR 20) 50 Y-PADRAO))
(define MOR-NO-LIMITE (make-morcego LIMITE-DIR-MOR -50 Y-PADRAO))
;;*******************************************                           
(define-struct bruxa (x dx y dy))
;; Bruxa é (make-bruxa Natural Natural Inteiro)
;; interp. representa o bruxa que está numa posição x
;; da tela e anda a uma velocidade dx (dx também indica a direção
;; em que ele está apontando)

;exemplos:
(define BRUXA-INICIAL (make-bruxa X 0 LIMITE-DIREITO DY-B-DEFAULT))
(define BRUXA-MEIO (make-bruxa X 0 (/ ALTURA-CENARIO 2) DY-B-DEFAULT))
(define BRUXA-ANTES-VIRAR (make-bruxa X 0 (+ LIMITE-ESQUERDO  5) DY-B-DEFAULT))
(define BRUXA-VIRADA (make-bruxa X 0 LIMITE-ESQUERDO  (- DY-B-DEFAULT)))
(define BRUXA-MEIO-VOLTANDO (make-bruxa X 0 (/ LARGURA-CENARIO 2) DY-B-DEFAULT))
(define BRUXA-ULTRAPASSOU (make-bruxa X 0 (+ LIMITE-DIREITO -5) (- DY-B-DEFAULT)))
(define BRUXA-NO-LIMITE (make-bruxa X 0 LIMITE-DIREITO DY-B-DEFAULT))

#;
(define (fn-para-bruxa b)
  (... (bruxa-y b) (bruxa-dy b))
  )
;;*******************************************
(define-struct corvo (x dx y))
;;Corvo é (make-corvo Natural Inteiro)
;;interp. representa a corvo que está numa posição x
;;da tela e anda a uma velocidade dx (dx também indica a direção
;;em que ela está apontando)

;exemplos:
(define CORVO-INICIAL  (make-corvo (/ LARGURA-CENARIO 2) 10 Y-PADRAO))
(define CORVO-MEIO (make-corvo (/ LARGURA-CENARIO 2) 10 Y-PADRAO))
(define CORVO-ANTES-VIRAR (make-corvo (+ LIMITE-DIR-COR 5) 10 Y-PADRAO))
(define CORVO-VIRADO (make-corvo LIMITE-DIR-COR -10 Y-PADRAO))
(define CORVO-MEIO-VOLTANDO (make-corvo (/ LARGURA-CENARIO 2) -10 Y-PADRAO))
(define CORVO-ULTRAPASSOU (make-corvo (+ LIMITE-DIR-COR 20) 50 Y-PADRAO))
(define CORVO-NO-LIMITE (make-corvo LIMITE-DIR-COR -50 Y-PADRAO))

;;*******************************************
(define-struct fada (x dx y))
;;Fada é (make-fada Natural Inteiro)
;;interp. representa a fada que está numa posição x
;;da tela e anda a uma velocidade dx (dx também indica a direção
;;em que ela está apontando)

;exemplos:
(define FADA-INICIAL  (make-fada (/ LARGURA-CENARIO 2) 10 Y-PADRAO))
(define FADA-MEIO (make-fada (/ LARGURA-CENARIO 2) 10 Y-PADRAO))
(define FADA-ANTES-VIRAR (make-fada (+ LIMITE-DIR-FAD 5) 10 Y-PADRAO))
(define FADA-VIRADA (make-fada LIMITE-DIR-FAD -10 Y-PADRAO))
(define FADA-MEIO-VOLTANDO (make-fada (/ LARGURA-CENARIO 2) -10 Y-PADRAO))
(define FADA-ULTRAPASSOU (make-fada (+ LIMITE-DIR-FAD 20) 50 Y-PADRAO))
(define FADA-NO-LIMITE (make-fada LIMITE-DIR-FAD -50 Y-PADRAO))

;;*******************************************
; ListaDebruxa, ListaDemorcegos, ListaDecorvo e ListaDefada é um desses:
;; - empty
;; - (cons bruxas, morcegos, corvos e fadas  ListaDebruxa/morcegos/corvos e fadas)
;; interp. um da listas de bruxas, morcegos, corvos e fadas
(define LDM-1 empty)
(define LDM-2 (cons MOR-INICIAL empty))
(define LDM-3 (cons MOR-INICIAL (cons MOR-MEIO empty)))
(define LDM-J1 (list MOR-INICIAL MOR-MEIO))
                      
(define LDB1 empty)
(define LDB2 (cons BRUXA-INICIAL  empty))
(define LDB3 (cons BRUXA-INICIAL (cons BRUXA-MEIO empty)))
(define LDB-J1 (list BRUXA-INICIAL
                      (make-bruxa (/ LARGURA-CENARIO 4) 0 (/ ALTURA-CENARIO 2) DY-B-DEFAULT)
                      (make-bruxa (/ LARGURA-CENARIO 4/3) 0 (/ ALTURA-CENARIO 3/2) DY-B-DEFAULT)))

(define LDC-1 empty)
(define LDC-2 (cons CORVO-INICIAL empty))
(define LDC-3 (cons CORVO-INICIAL (cons CORVO-MEIO empty)))
(define LDC-J1 (list CORVO-INICIAL MOR-MEIO))

(define LDF-1 empty)
(define LDF-2 (cons FADA-INICIAL empty))
(define LDF-3 (cons FADA-INICIAL (cons FADA-MEIO empty)))
(define LDF-J1 (list FADA-INICIAL FADA-MEIO))
                      
#;
(define (fn-for-ldb ldb)
  (cond [(empty? ldb) (...)]                    ;CASO BASE (CONDIÇÃO DE PARADA)
        [else (... (first ldb)                  ;ListaDEbruxa
                   (fn-for-ldb (rest ldb)))])) ;RECURSÃO EM CAUDA

;;*************************************************
(define-struct arma (x dx y))
;;Arma é (make-arma Natural Inteiro)
;;interp. representa a arma que está numa posição x
;;da tela e anda a uma velocidade dx (dx também indica a direção
;;em que ela está apontando)

;exemplos:
(define ARMA-INICIAL (make-arma LIMITE-ESQUERDO 10 Y))
(define ARMA-MEIO (make-arma (/ LARGURA-CENARIO 2) 10 Y ))
(define ARMA-ANTES-VIRAR (make-arma (+ LIMITE-DIREITO 5) 10 Y ))
(define ARMA-PARADA (make-arma (/ LARGURA-CENARIO 2) 0 LIMITE-BAIXO )) 

#;
(define (fn-para-arma a)
  (... (arma-x a) (arma-dx a)
       (arma-y a)) 
  )
;;*********************************************
(define-struct tiro (x y dy))
;; Tiro é (make-tiro Natural Inteiro Natural)
;; interp. um tiro que apenas na horizontal
(define TIRO-PADRAO (make-tiro 600 200 0))
(define LDT1 (list TIRO-PADRAO))

#;
(define (fn-para-tiro t)
  (... (tiro-x t) (tiro-y t)
       (tiro-dy t))
  )
;;***********************************************
(define-struct jogo (arma bruxas morcegos corvos fadas game-over? tsurgi tiros tsurgif))
;; Jogo é (make-jogo Arma ListaDeBruxa ListaDemorcegos ListaDeCorvos ListaDeFadas Boolean Numero+ ListaDetiros Numero+)
;; interp. representa um jogo que tem uma arma
;; e bruxa, morgegos, corvos, fadas, Boolean,tsurgi,tiros e tsurgifadas.

(define JOGO-INICIAL (make-jogo ARMA-INICIAL
                                (list BRUXA-INICIAL)
                                LDM-J1
                                LDC-J1
                                LDF-J1
                                #false
                                1
                                empty
                                1))
(define JOGO-MEIO (make-jogo ARMA-ANTES-VIRAR
                                (list BRUXA-MEIO)
                                LDM-J1
                                LDC-J1
                                LDF-J1
                                #false
                                1
                                empty
                                1))
(define JOGO-ALVOS (make-jogo
                   (make-arma (- (/ LARGURA-CENARIO 2) MEIO-W-ARMA -5) 10 Y)
                   (list BRUXA-MEIO)
                   LDM-J1
                   LDC-J1
                   LDF-J1
                   #false
                   1
                   empty
                   1))
(define JOGO-ALVOS-MOVEL (make-jogo
                   (make-arma (- (/ LARGURA-CENARIO 2) MEIO-W-ARMA -5) 10 Y)
                   (list BRUXA-MEIO)
                   LDM-J1
                   LDC-J1
                   LDF-J1
                   #true
                   1
                   empty
                   1))
(define JOGO-ACABOU (make-jogo ARMA-MEIO
                               (list BRUXA-MEIO)
                               LDM-J1
                               LDC-J1
                               LDF-J1 
                               #true
                               1
                               empty
                               1))

(define JOGO-INICIAL-N-ALVOS (make-jogo ARMA-INICIAL
                                LDB-J1
                                LDM-J1
                                LDC-J1
                                LDF-J1
                                #false
                                1
                                empty
                                1))

(define JOGO-INICIAL-SURGINDO (make-jogo ARMA-PARADA
                                empty         
                                empty
                                empty
                                empty
                                #false 
                                0
                                empty
                                1))

#;
(define (fn-para-jogo j)
  (... (jogo-arma j)
       (jogo-bruxas j)
       (jogo-morcegos j)
       (jogo-corvos j)
       (jogo-fadas j)
       (jogo-game-over? j)
       (jogo-tsurgi j)
       (jogo-tiros j)
       (jogo-tsurgif j)))

;; =================================================================================================================================================
;; Funções:
;; INICIO DA PARTE LÓGICA DO JOGO
;; Colisao-tiros-bruxas? : ListaDeTiro ListaDeBruxas -> (pair Tiro Bruxa) | false
;; verifica se tiros acertaram bruxas

(define (colisao-tiros-bruxas? ldt ldb)
  (local
    [
     (define (colisao-tiro-bruxa? t b)       
       (if (<= (distancia (tiro-x t) (tiro-y t)
                          (bruxa-x b) (bruxa-y b))
               (+ MEIO-W-TIRO MEIO-W-ARMA))
           (list t b)
           #false))

     (define (cria-pares item lista) 
       (map (lambda (item2) (list item item2)) lista))

     (define (produto-cartesiano list1 list2)
       (cond [(empty? list1) empty]
             [else
              (append (cria-pares (first list1) list2)
                      (produto-cartesiano (rest list1) list2))]))

     (define busca 
       (memf (lambda (par) (colisao-tiro-bruxa? (first par) (second par))) 
           (produto-cartesiano ldt ldb)))
     
     ]
    (if (false? busca)
        #false
        (first busca)))) 

(check-equal? (colisao-tiros-bruxas? LDT1 LDB1) #false)
;;********************************************
;; Colisao-tiros-morcegos? : ListaDeTiro ListaDeMorcegos -> (pair Tiro Morcego) | false
;; verifica se tiros acertaram morcegos

(define (colisao-tiros-morcegos? ldt ldm) 
  (local
    [
     (define (colisao-tiro-morcego? t m)       
       (if (<= (distancia (tiro-x t) (tiro-y t)
                          (morcego-x m) (morcego-y m))
               (+ MEIO-W-TIRO MEIO-H-MOR))
           (list t m)
           #false))

     (define (cria-pares item lista)
       (map (lambda (item2) (list item item2)) lista))

     (define (produto-cartesiano list1 list2)
       (cond [(empty? list1) empty]
             [else
              (append (cria-pares (first list1) list2)
                      (produto-cartesiano (rest list1) list2))]))

     (define busca
       (memf (lambda (par) (colisao-tiro-morcego? (first par) (second par)))
             (produto-cartesiano ldt ldm)
            ))
     
     ]
    (if (false? busca)
        #false
        (first busca))))

(check-equal? (colisao-tiros-morcegos? empty LDM-3) #false)   
;;*********************************************
;; colisao-tiros-corvos? : ListaDeTiro ListaCorvos -> (pair Tiro Corvo) | false
;; verifica se tiros acertaram corvos

(define (colisao-tiros-corvos? ldt ldc) 
  (local
    [
     (define (colisao-tiros-corvos? t c)       
       (if (<= (distancia (tiro-x t) (tiro-y t)
                          (corvo-x c) (corvo-y c))
               (+ MEIO-W-TIRO MEIO-H-COR))
           (list t c)
           #false))

     (define (cria-pares item lista)
       (map (lambda (item2) (list item item2)) lista))

     (define (produto-cartesiano list1 list2)
       (cond [(empty? list1) empty]
             [else
              (append (cria-pares (first list1) list2)
                      (produto-cartesiano (rest list1) list2))]))

     (define busca
       (memf (lambda (par) (colisao-tiros-corvos? (first par) (second par)))
           (produto-cartesiano ldt ldc)))
     
     ]
    (if (false? busca)
        #false
        (first busca))))

(check-equal? (colisao-tiros-corvos? empty LDC-3) #false) 
;;***************************************************
;; colisao-tiros-fadas? : ListaDeTiro ListaFadas -> (pair Tiro Fadas) | false
;; verifica se tiros acertaram fadas

(define (colisao-tiros-fadas? ldt ldf) 
  (local
    [
     (define (colisao-tiros-fadas? t f)       
       (if (<= (distancia (tiro-x t) (tiro-y t)
                          (fada-x f) (fada-y f))
               (+ MEIO-W-TIRO MEIO-H-FAD))
           (list t f)
           #false))

     (define (cria-pares item lista)
       (map (lambda (item2) (list item item2)) lista))

     (define (produto-cartesiano list1 list2)
       (cond [(empty? list1) empty]
             [else
              (append (cria-pares (first list1) list2)
                      (produto-cartesiano (rest list1) list2))]))

     (define busca
       (memf (lambda (par) (colisao-tiros-fadas? (first par) (second par)))
           (produto-cartesiano ldt ldf)))
     
     ]
    (if (false? busca)
        #false
        (first busca))))

(check-equal? (colisao-tiros-fadas? empty LDF-3) #false) 
;;***************************************************
;; proxima-arma :ARMA ->ARMA
;; recebe uma arma na posicao x e retorna uma arma com posição
;; x atualizada com o dx

;(define (proxima-arma a) a)

(define (proxima-arma a)
  (cond
    [(> (arma-x a) LIMITE-DIREITO)
     (make-arma LIMITE-DIREITO (- (arma-dx a))
                      (arma-y a))]
    [(< (arma-x a) LIMITE-ESQUERDO) 
     (make-arma LIMITE-ESQUERDO (- (arma-dx a))
                      (arma-y a))]
   
    [else
     (make-arma (+ (arma-x a) (arma-dx a)) (arma-dx a)
                      (arma-y a))]))  

 (check-equal? (proxima-arma ARMA-INICIAL) (make-arma 109 10 350))
;;********************************************
;; proximo-morcego : Morcego -> Morcego
;; recebe uma morcego na posicao x e retorna uma morcego com posição
;; x atualizada com o dx
 
;(define (proximo-morcego m) m)
(define (proximo-morcego m)
  (cond 
        [(> (morcego-x m) LIMITE-DIR-MOR)
         (make-morcego LIMITE-DIR-MOR (- (morcego-dx m)) (morcego-y m))] 
        [(< (morcego-x m) 0)
         (make-morcego 0 (- (morcego-dx m))(morcego-y m))]
        [else
         (make-morcego (+ (morcego-x m) (morcego-dx m))
             (morcego-dx m)(morcego-y m))])
 )
; exemplos / testes
;casos em que ele anda pra direita sem chegar no limite 
(check-equal? (proximo-morcego (make-morcego 0 10 Y-PADRAO))
              (make-morcego 10 10 Y-PADRAO)) 
(check-equal? (proximo-morcego MOR-MEIO)
              (make-morcego (+ (/ LARGURA-CENARIO 2) 10 ) 
                         10 Y-PADRAO))
; casos em que chega no limite direito e tem que virar
(check-equal? (proximo-morcego MOR-ANTES-VIRAR)
              MOR-VIRADA )
(check-equal? (proximo-morcego MOR-ULTRAPASSOU)
                            MOR-NO-LIMITE)
; caso em que ele anda pra esquerda sem chegar no limite 
(check-equal? (proximo-morcego MOR-MEIO-VOLTANDO)
                            (make-morcego (- (/ LARGURA-CENARIO 2) 10)
                                       -10 Y-PADRAO))

; casos em que chega no limite esquerdo e tem que virar
(check-equal? (proximo-morcego (make-morcego -10 -10 Y-PADRAO))
                           (make-morcego 0 10 Y-PADRAO))
(check-equal? (proximo-morcego (make-morcego -20 -50 Y-PADRAO))
                            (make-morcego 0 50 Y-PADRAO))

;;********************************************
;; proxima-bruxa : Bruxa -> Bruxa
;; faz bruxa andar no eixo y, e se trombar nos limites,
;; inverte dy
;; (define (proxima-bruxa b) b)

(define (proxima-bruxa b)
  (cond
    [(> (bruxa-x b) LIMITE-DIREITO)
     (make-bruxa LIMITE-DIREITO (- (bruxa-dx b))
                      (bruxa-y b) (bruxa-dy b) )]
    [(< (bruxa-x b) LIMITE-ESQUERDO)
     (make-bruxa LIMITE-ESQUERDO (- (bruxa-dx b))
                      (bruxa-y b) (bruxa-dy b) )] 
    [else
     (make-bruxa (+ (bruxa-x b) (bruxa-dx b)) (bruxa-dx b) 
                      (bruxa-y b) (bruxa-dy b) )]))

;exemplos / testes
;casos em que ela anda pra direita sem chegar no limite
(check-equal? (proxima-bruxa BRUXA-MEIO)
             (make-bruxa X 0 (/ ALTURA-CENARIO 2) DY-B-DEFAULT))
; ;casos em que chega no limite direito e tem que virar
(check-equal? (proxima-bruxa BRUXA-ULTRAPASSOU)
              (make-bruxa X 0 (+ LIMITE-DIREITO -5) (- DY-B-DEFAULT)))
;; caso em que ela anda pra esquerda sem chegar no limite 
(check-equal? (proxima-bruxa BRUXA-ANTES-VIRAR)
              (make-bruxa X 0 (+ LIMITE-ESQUERDO  5) DY-B-DEFAULT))

;;*******************************************
;; proximo-corvo : Corvo -> Corvo
;; recebe uma corvo na posicao x e retorna uma corvo com posição
;; x atualizada com o dx
;(define (proxima-corvo c) c)

(define (proximo-corvo c)
  (cond 
        [(> (corvo-x c) LIMITE-DIR-COR)
         (make-corvo LIMITE-DIR-COR (- (corvo-dx c)) (corvo-y c))]
         [(< (corvo-x c) 0)
         (make-corvo 0 (- (corvo-dx c))(corvo-y c))]
        [else
         (make-corvo (+ (corvo-x c) (corvo-dx c)) 
             (corvo-dx c)(corvo-y c))])
 )
; exemplos / testes
;casos em que ele anda pra direita sem chegar no limite
(check-equal? (proximo-corvo (make-corvo 0 10 Y-PADRAO))
              (make-corvo 10 10 Y-PADRAO)) 
(check-equal? (proximo-corvo CORVO-MEIO)
              (make-corvo (+ (/ LARGURA-CENARIO 2) 10)
                         10 Y-PADRAO))
; casos em que chega no limite direito e tem que virar
(check-equal? (proximo-corvo CORVO-ANTES-VIRAR)
              CORVO-VIRADO)
(check-equal? (proximo-corvo CORVO-ULTRAPASSOU)
                            CORVO-NO-LIMITE)
; caso em que ele anda pra esquerda sem chegar no limite 
(check-equal? (proximo-corvo CORVO-MEIO-VOLTANDO)
                            (make-corvo (- (/ LARGURA-CENARIO 2) 10)
                                       -10 Y-PADRAO))

; casos em que chega no limite esquerdo e tem que virar
(check-equal? (proximo-corvo (make-corvo -10 -10 Y-PADRAO))
                            (make-corvo 0 10 Y-PADRAO))
(check-equal? (proximo-corvo (make-corvo -20 -50 Y-PADRAO))
                            (make-corvo 0 50 Y-PADRAO))
 
;;********************************************
;; proxima-fada : Fada -> Fada
;; recebe uma fada na posicao x e retorna uma fada com posição
;; x atualizada com o dx
;(define (proxima-fada f) f)

(define (proxima-fada f)
  (cond 
        [(> (fada-x f) LIMITE-DIR-FAD)
         (make-fada LIMITE-DIR-FAD (- (fada-dx f)) (fada-y f))]
         [(< (fada-x f) 0)
         (make-fada 0 (- (fada-dx f))(fada-y f))]
        [else
         (make-fada (+ (fada-x f) (fada-dx f)) 
             (fada-dx f)(fada-y f))])
 )

; exemplos / testes
;casos em que ele anda pra direita sem chegar no limite
(check-equal? (proxima-fada (make-fada 0 10 Y-PADRAO))
              (make-fada 10 10 Y-PADRAO)) 
(check-equal? (proxima-fada FADA-MEIO)
              (make-fada (+ (/ LARGURA-CENARIO 2) 10)
                         10 Y-PADRAO))
; casos em que chega no limite direito e tem que virar
(check-equal? (proxima-fada FADA-ANTES-VIRAR)
              FADA-VIRADA)
(check-equal? (proxima-fada FADA-ULTRAPASSOU)
                            FADA-NO-LIMITE)
; caso em que ele anda pra esquerda sem chegar no limite 
(check-equal? (proxima-fada FADA-MEIO-VOLTANDO)
                            (make-fada (- (/ LARGURA-CENARIO 2) 10)
                                       -10 Y-PADRAO))

; casos em que chega no limite esquerdo e tem que virar
(check-equal? (proxima-fada (make-fada -10 -10 Y-PADRAO))
                            (make-fada 0 10 Y-PADRAO))
(check-equal? (proxima-fada (make-fada -20 -50 Y-PADRAO))
                            (make-fada 0 50 Y-PADRAO))
 
;;********************************************
;; proximas-bruxas : ListaDeBruxa -> ListaDeBruxa
;; proximas bruxas
;; (define (proximas-bruxas ldb) ldb)

 (define (proximas-bruxas ldb) 
  (map proxima-bruxa ldb))

(check-equal? (proximas-bruxas LDB1) empty)
;;*******************************************
;; proximos-morcegos : ListaDeMorcegos -> ListaDeMorcegos
;; proximos morcegos
;;(define (proximos-morcegos ldm) ldm)

 (define (proximos-morcegos ldm) 
  (map proximo-morcego ldm))

(check-equal? (proximos-morcegos LDM-3) (list (make-morcego 610 10 200) (make-morcego 610 10 200)))
;;*******************************************
;; proximos-corvos : ListaDeCorvos -> ListaDeCorvos
;; proximos-corvos
;;(define (proximos-corvos ldc) ldc)

 (define (proximos-corvos ldc) 
  (map proximo-corvo ldc))

(check-equal? (proximos-corvos LDC-3) (list (make-corvo 610 10 200) (make-corvo 610 10 200)))
;;*******************************************
;; proximas-fadas : ListaDeFadas -> ListaDeFadas
;; proximas-fadas
;;(define (proximas-fadas ldf) ldf)

 (define (proximas-fadas ldf) 
  (map proxima-fada ldf))

(check-equal? (proximas-fadas LDF-3) (list (make-fada 610 10 200) (make-fada 610 10 200)))
;;*******************************************
;; distancia : Numero Numero Numero Numero -> Numero
;; calcula distancia
(define (distancia x1 y1 x2 y2)
  (sqrt (+ (sqr (- x2 x1)) (sqr (- y2 y1)))))

(check-equal? (distancia 3 0 0 4) 5)
;;*******************************************
 ;; proximo-tiro : Tiro -> Tiro
 ;;;; recebe proximo tiro
 ;;define (proximo-tiro t) t)

 (define (proximo-tiro t)
  (make-tiro (tiro-x t) (- (tiro-y t) 20) (tiro-dy t)))

(check-equal? (proximo-tiro (make-tiro 100 100 0)) (make-tiro 100 80 0)) 
(check-equal? (proximo-tiro (make-tiro 10 80 0)) (make-tiro 10 60 0))
(check-equal? (proximo-tiro (make-tiro 15 50 0)) (make-tiro 15 30 0))
(check-equal? (proximo-tiro TIRO-PADRAO) (make-tiro 600 180 0))
;;*******************************************
;; proximos-tiros : Tiros -> Tiros
;; recebe uma lista de tiros
;;(define (proximos-tiros ldt) ldt)

 (define (proximos-tiros ldt)
  (filter (lambda (t) (and (<= (tiro-y t) ALTURA-CENARIO) (>= (tiro-y t) 0)))  
          (map proximo-tiro ldt)))

(check-equal? (proximos-tiros LDT1) (list (make-tiro 600 180 0)))

;;*******************************************
;; proximo-jogo : Jogo -> Jogo
;; atualiza o jogo
; (define (proximo-jogo j)  j)

(define (proximo-jogo j) 
  (local 
    [
     (define surgi? (= (jogo-tsurgi j) 0))
     (define acertou-bruxa? (colisao-tiros-bruxas? (jogo-tiros j) (jogo-bruxas j)))
     (define acertou-morcego? (colisao-tiros-morcegos? (jogo-tiros j) (jogo-morcegos j)))     
     (define acertou-corvo? (colisao-tiros-corvos? (jogo-tiros j) (jogo-corvos j)))
     (define surgif? (= (jogo-tsurgif j) 0))
     (define acertou-fada? (colisao-tiros-fadas? (jogo-tiros j) (jogo-fadas j)))
     ]

   (make-jogo (proxima-arma (jogo-arma j))
                   (cond
                     [surgi? 
                          (surgi-bruxa (proximas-bruxas (jogo-bruxas j)))]
                     [(list? acertou-bruxa?)
                          (proximas-bruxas 
                           (remove (second acertou-bruxa?) (jogo-bruxas j)))
                          ]                           
                     [else
                      (proximas-bruxas (jogo-bruxas j))])
                   (cond
                     [surgi? 
                          (surgi-morcego (proximos-morcegos (jogo-morcegos j)))]
                     [(list? acertou-morcego?)
                          (proximos-morcegos
                           (remove (second acertou-morcego?) (jogo-morcegos j)))]                          
                     [else
                      (proximos-morcegos (jogo-morcegos j))])
                   (cond
                     [surgi? 
                          (surgi-corvo (proximos-corvos (jogo-corvos j)))]
                     [(list? acertou-corvo?)
                          (proximos-corvos
                           (remove (second acertou-corvo?) (jogo-corvos j)))]                          
                     [else
                      (proximos-corvos (jogo-corvos j))])
                   (cond
                     [surgif? 
                          (surgif-fada (proximas-fadas (jogo-fadas j)))]
                     [(list? acertou-fada?)
                          (proximas-fadas
                           (remove (second acertou-fada?) (jogo-fadas j)))]                           
                     [else
                      (proximas-fadas (jogo-fadas j))])
                   
                   (cond [(list? acertou-fada?) 
                          #true 
                          ]
                     [else (jogo-game-over? j)])                     
                   
                   (remainder (+ (jogo-tsurgi j) 1) 40)  
                   (if (list? acertou-bruxa?) 
                       (proximos-tiros
                        (remove (first acertou-bruxa?) (jogo-tiros j)))   
                       (proximos-tiros (jogo-tiros j)))
                       (remainder (+ (jogo-tsurgif j) 1) 200)))) 

;;*******************************************
;; surgi-bruxa : ListaDeBruxa -> ListaDeBruxa
;; cria novo bruxa no local especificado
  
 (define (surgi-bruxa ldb)
  (cons (make-bruxa X-SURGIR (random 50) (random 250) (random 100)) ldb))
;;*******************************************
;; surgi-morcego : ListaDeMorcegos -> ListaDeMorcegos
;; cria novo morcego no local especificado

 (define (surgi-morcego ldm)
  (cons (make-morcego X-SURGIR (random 30) (random 40)) ldm))
;;*******************************************
;; surgi-corvo : ListaDeCorvos -> ListaDeCorvos
;; cria novo corvo no local especificado

 (define (surgi-corvo ldc)
  (cons (make-corvo X-SURGIR (random 50) (random 400)) ldc))
;;*******************************************
;; surgi-fada : ListaDeFadas -> ListaDeFadas
;; cria novo fada no local especificado

 (define (surgif-fada ldf)
  (cons (make-fada X-SURGIR (random 10) (random 300)) ldf))
 ;; FIM DA PARTE LÓGICA
;;==============================================================================================================================            
;; INICIO DA PARTE VISUAL
;; desenha-jogo : Jogo -> Image 
;; desenha o jogo

 (define (desenha-jogo j)
   (cond [ (jogo-game-over? j)
           GAME-OVER]
  [else (overlay
   (desenha-tiros (jogo-tiros j))
   (desenha-bruxas (jogo-bruxas j))
   (desenha-morcegos (jogo-morcegos j))   
   (desenha-corvos (jogo-corvos j))
   (desenha-fadas (jogo-fadas j))
   (desenha-arma (jogo-arma j)))]))
;;*******************************************
;; Desenha-morcego: Morcego -> Image
;; retorna a representação do cenário com a morcego
 (define (desenha-morcego m)
  (place-image 
   (if (< (morcego-dx m) 0)
       IMG-MOR-VOLTANDO
       IMG-MOR-INO)
   (morcego-x m)
  (random 60)
   CENARIO)
  )
;;*******************************************
;; desenha-morcegos : ListaDeMorcegos -> Image
;; desenha morcegos
 (define (desenha-morcegos ldm)
  (foldl overlay CENARIO (map desenha-morcego ldm))) 
;;*******************************************
;; desenha-bruxa : Bruxa -> Image
;; desenha o bruxa
 (define (desenha-bruxa b)
  (place-image
  (if (< (bruxa-dx b) 1)
     IMG-BRUXA-VOLTANDO
     IMG-BRUXA-INO)
  (bruxa-x b)
  (bruxa-y b)
  CENARIO))
;;*******************************************
;; desenha-bruxas : ListaDeBruxa -> Image
;; desenha bruxas
 (define (desenha-bruxas ldb)
  (foldl overlay CENARIO (map desenha-bruxa ldb))) 
;;*******************************************
;; Desenha-corvo: Corvo -> Image
;; retorna a representação do cenário com a corvo

(define (desenha-corvo c)
  (place-image
   (if (< (corvo-dx c) 0) 
       IMG-CORVO-VOLTANDO
       IMG-COR-INO)
   (corvo-x c) 
   (corvo-y c)
     CENARIO)
  )
;;*******************************************
;; Desenha-fada: fada -> Image
;; retorna a representação do cenário com a fada

(define (desenha-fada f)
  (place-image
   (if (< (fada-dx f) 0) 
       IMG-FAD-VOLTANDO
       IMG-FAD-INO)
   (fada-x f) 
   (fada-y f)
     CENARIO)
  )
;;*************************************************
;; desenha-corvos : ListaDecorvos -> Image
;; desenha corvos
 (define (desenha-corvos ldc)
  (foldl overlay CENARIO (map desenha-corvo ldc)))
;;*************************************************
;; desenha-fadas : ListaDefadas -> Image
;; desenha fadas
 (define (desenha-fadas ldf)
  (foldl overlay CENARIO (map desenha-fada ldf))) 
;;************************************************
;; desenha-tiro : Tiro -> Image
;; desenha o tiro
 (define (desenha-tiro t) 
  (place-image IMG-TIRO (tiro-x t) (tiro-y t) CENARIO))
;;*******************************************
;; desenha-tiros : ListaDeTiros -> Image
;; desenha tiross
 (define (desenha-tiros ldt)
  (foldl overlay CENARIO (map desenha-tiro ldt)))
;;*******************************************
;; desenha-arma: arma -> Image
;; retorna a representação do cenário com a arma
#;
(define (fn-para-arma a)
  (... (arma-x v) (arma-dx a)
       (arma-y a))
  )

(define (desenha-arma a) 
  (place-image
            (if (< (arma-dx a) 0)
                IMG-ARMA-VOLTANDO
                IMG-ARMA-INO)
   (arma-x a)
   (arma-y a)
   TELA-JOGO)   
  )

;; FIM DA PARTE VISUAL
;;=============================================================================================================================
;; INICIO DA LOGICA DE INTERAÇÃO

;; trata-tecla : Jogo KeyEvent -> Jogo
;; trata tecla usando trata-tecla-arma
(define (trata-tecla j ke)
  (cond
    [(and (jogo-game-over? j) (key=? ke "\r"))
         JOGO-INICIAL-SURGINDO]
    [(key=? ke " ") 
     (make-jogo
           (trata-tecla-arma (jogo-arma j) ke) 
           (jogo-bruxas j)
           (jogo-morcegos j)
           (jogo-corvos j)
           (jogo-fadas j)
           (jogo-game-over? j)
           (jogo-tsurgi j)
           (cons (make-tiro (arma-x (jogo-arma j))                           
                            (arma-y (jogo-arma j))
                            0)
                 (jogo-tiros j)
                 )
           (jogo-tsurgif j)
           )]
    [else (make-jogo
           (trata-tecla-arma (jogo-arma j) ke)
           (jogo-bruxas j)
           (jogo-morcegos j)
           (jogo-corvos j)
           (jogo-fadas j)
           (jogo-game-over? j)
           (jogo-tsurgi j)
           (jogo-tiros j)
           (jogo-tsurgif j) 
           )]))

(check-equal? (trata-tecla JOGO-ALVOS-MOVEL "\r")
              JOGO-INICIAL-SURGINDO) 
;;*******************************************
;; trata-tecla-arma: arma KeyEvent -> arma
;; quando tecla seta é pressionada, arma deve inverter direção(x)
;;(define (trata-tecla-arma a ke) a)

(define (trata-tecla-arma a ke)
  (cond [(key=? ke "right")
         (make-arma (arma-x a) D-ARMA-DEFAULT (arma-y a))]
        [(key=? ke "left")
         (make-arma (arma-x a) (- D-ARMA-DEFAULT) (arma-y a))]
        [else a])) 

(define (trata-tecla-release j ke)
  (make-jogo
    (trata-tecla-arma-release (jogo-arma j) ke)
    (jogo-bruxas j)
    (jogo-morcegos j)
    (jogo-corvos j)
    (jogo-fadas j) 
    (jogo-game-over? j)    
    (jogo-tsurgi j)
    (jogo-tiros j)
    (jogo-tsurgif j)
    ))

(define (trata-tecla-arma-release a ke)
  (if (member ke (list "right" "left"))
      (make-arma (arma-x a) 0 (arma-y a)) 
      a)) 
;exemplos
(check-equal? (trata-tecla-arma IMG-ARMA-INO " ")IMG-ARMA-INO) 
(check-equal? (trata-tecla-arma ARMA-INICIAL "0") ARMA-INICIAL)
;;*******************************************  
;; Numero Numero Numero Numero -> Numero
; Calcula angulo entre 2 pontos
(define (calcula-angulo x1 y1 x2 y2)  
  (radians->degrees (atan (- y2 y1) (- x2 x1))))   

(define (inverte-y y)
  (- ALTURA-CENARIO y))  ;INVERTER Y PARA OS CALCULOS FICAREM DE ACORDO COM O PRIMEIRO QUADRANTE DO PLANO CARTESIANO
;;*******************************************
;; Jogo -> Jogo
;; inicie o mundo com (main JOGO-INICIAL-SURGINDO)    
(define (main j)                  
  (big-bang j       ; Jogo  (estado inicial do jogo)
            (on-tick proximo-jogo) ; Jogo -> Jogo 
            (to-draw desenha-jogo)  ; EstadoInicaldoJogo -> Image   
                                          ;(retorna uma imagem que representa o estado atual do jogo)
            (on-key trata-tecla)    ; Arma KeyEvent -> arma
                                    ;(retorna um novo estado da arma dado o estado atual e uma interação com a tecla)

            (on-release trata-tecla-release)))   
           
;; FIM DA LOGICA DE INTERAÇÃO 
 