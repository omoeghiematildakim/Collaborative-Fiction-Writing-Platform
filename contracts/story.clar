;; Story Contract

(define-data-var story-id-nonce uint u0)

(define-map stories
  { id: uint }
  {
    title: (string-ascii 100),
    author: principal,
    content: (string-utf8 10000),
    created-at: uint
  }
)

(define-public (create-story (title (string-ascii 100)) (content (string-utf8 10000)))
  (let
    ((new-story-id (+ (var-get story-id-nonce) u1)))
    (var-set story-id-nonce new-story-id)
    (ok (map-set stories
      { id: new-story-id }
      {
        title: title,
        author: tx-sender,
        content: content,
        created-at: block-height
      }
    ))
  )
)

(define-read-only (get-story (id uint))
  (map-get? stories { id: id })
)

(define-read-only (get-story-count)
  (var-get story-id-nonce)
)

