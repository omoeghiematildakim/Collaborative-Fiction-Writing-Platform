;; Contribution Contract

(define-data-var contribution-id-nonce uint u0)

(define-map contributions
  { id: uint }
  {
    story-id: uint,
    author: principal,
    content: (string-utf8 10000),
    status: (string-ascii 20),
    created-at: uint
  }
)

(define-public (submit-contribution (story-id uint) (content (string-utf8 10000)))
  (let
    ((new-contribution-id (+ (var-get contribution-id-nonce) u1)))
    (var-set contribution-id-nonce new-contribution-id)
    (ok (map-set contributions
      { id: new-contribution-id }
      {
        story-id: story-id,
        author: tx-sender,
        content: content,
        status: "pending",
        created-at: block-height
      }
    ))
  )
)

(define-read-only (get-contribution (id uint))
  (map-get? contributions { id: id })
)

(define-read-only (get-contribution-count)
  (var-get contribution-id-nonce)
)

