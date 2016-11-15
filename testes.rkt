#lang racket

(require rackunit)
(require "constantes.rkt")
(require "dados.rkt")
(require "jogo.rkt")

;; Constantes usadas nos testes
;#
(define (proxima-arma pa)
  (test-suite
   "proxima-arma"
   ...))
;;Exemplo/Teste
(check-expect (proxima-arma "esquerda") "meio")
(check-expect (proxima-arma "meio") "direita")
(check-expect (proxima-arma "direita") "esquerda")
;;****************************************************************************************************************************   
;#
(define (proximo-morcego m)
  (test-suite
   "proximo-morcego"
   ...))
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
;#
(define (proxima-bruxa b)
  (test-suite
   "proxima-bruxa"
   ...))
 ;; exemplos / testes
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
;;******************************************************************************************************************************   
;#
(define (proximo-corvo c)
  (test-suite
   "proximo-corvo"
   ...))
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
#;
(define desenha-arma
  (test-suite
   "desenha-arma"
   ...))
 ;;Exemplo/Teste
(check-expect (desenha-arma "esquerda") IMG-ARMA-45-ESQ)
(check-expect (desenha-arma "meio") IMG-ARMA-MEIO)
(check-expect (desenha-arma "direita") IMG-ARMA-45-DIR)   
;;*********************************************************************************************************************
#;
(define distancia x1 y1 x2 y2
  (test-suite
   "distancia x1 y1 x2 y2"
   ...))
(check-expect (distancia 3 0 0 4) 5)

#;
(define trata-tecla-arma q ke
  (test-suite
   "trata-tecla-arma q ke"
   ...))
;exemplos
(check-expect (trata-tecla-arma IMG-ARMA-45-ESQ " ") "meio")
(check-expect (trata-tecla-arma ARMA-INICIAL "0") ARMA-INICIAL)
;;**************************************************************************************************************************   

#;
(define trata-mouse-tests
  (test-suite
   "trata-mouse tests"
   ...))

#;
(define terminou?-tests
  (test-suite
   "terminou? tests"
   ...))

;; Adicione os testes restantes



;; ---------------------------------------------------------------------

;; Função que executa um grupo de testes.
(define (executar-testes . testes)
  (run-tests (test-suite "Todos os testes" testes))
  (void))

;; Chama a função para executar os testes.
#;
(executar-testes tock-tests
                 desenha-tests
                 trata-tecla-tests
                 trata-mouse-tests
                 terminou?-tests)
Contact GitHub API Training Shop Blog About
© 2016 GitHub, Inc. Terms Privacy Security Status Help
