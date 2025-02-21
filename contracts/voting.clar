;; Voting Contract

(define-data-var poll-id-nonce uint u0)

(define-map polls
  { id: uint }
  {
    story-id: uint,
    description: (string-utf8 500),
    options: (list 5 (string-utf8 100)),
    created-at: uint
  }
)

(define-map votes
  { poll-id: uint, voter: principal }
  { option: uint }
)

(define-public (create-poll (story-id uint) (description (string-utf8 500)) (options (list 5 (string-utf8 100))))
  (let
    ((new-poll-id (+ (var-get poll-id-nonce) u1)))
    (var-set poll-id-nonce new-poll-id)
    (ok (map-set polls
      { id: new-poll-id }
      {
        story-id: story-id,
        description: description,
        options: options,
        created-at: block-height
      }
    ))
  )
)

(define-public (vote (poll-id uint) (option uint))
  (ok (map-set votes
    { poll-id: poll-id, voter: tx-sender }
    { option: option }
  ))
)

(define-read-only (get-poll (id uint))
  (map-get? polls { id: id })
)

(define-read-only (get-vote (poll-id uint) (voter principal))
  (map-get? votes { poll-id: poll-id, voter: voter })
)

