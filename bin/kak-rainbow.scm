#!/usr/bin/env -S guile -s
!#

(use-modules (ice-9 rdelim))

(define (main)
  (let* ((selections
           (string->list
             (string-delete
               (char-set #\space #\')
               (read-line))))
         (locations (string-split (read-line) #\space))
         (colors (string-split (read-line) #\space))
         (brackets_opening (string->char-set (read-line)))
         (brackets_closing (string->char-set (read-line)))
         (color_id
           (lambda (x) (modulo x (length colors))))
         (spec "")
         (level -1))
    (for-each
      (lambda (bracket)
        (begin
          (cond ((char-set-contains? brackets_opening bracket)
                 (begin (set! level (+ level 1))))
                ((char-set-contains? brackets_closing bracket)
                 (begin (set! level (- level 1)))))))
      (list-head
        selections
        (max 0 (- (length selections) 500))))
    (for-each
      (lambda (bracket location)
        (cond ((char-set-contains? brackets_opening bracket)
               (begin
                 (set! level (+ level 1))
                 (set! spec
                   (string-append
                     spec " " location "|"
                     (list-ref colors (color_id level))))))
              ((char-set-contains? brackets_closing bracket)
               (begin
                 (set! spec
                   (string-append
                     spec " " location "|"
                     (list-ref colors (color_id level))))
                 (set! level (- level 1))))))
      (list-tail
        selections
        (max 0 (- (length selections) 500)))
      (list-tail
        locations
        (max 0 (- (length locations) 500))))
    (display spec)))

(main)
