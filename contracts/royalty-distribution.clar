;; Royalty Distribution Contract

(define-fungible-token royalty-token)

(define-map contributor-shares
  { story-id: uint, contributor: principal }
  { share: uint }
)

(define-map story-revenue
  { story-id: uint }
  { total-revenue: uint }
)

(define-public (set-contributor-share (story-id uint) (contributor principal) (share uint))
  (ok (map-set contributor-shares
    { story-id: story-id, contributor: contributor }
    { share: share }
  ))
)

(define-public (add-revenue (story-id uint) (amount uint))
  (let
    ((current-revenue (default-to { total-revenue: u0 } (map-get? story-revenue { story-id: story-id }))))
    (try! (ft-mint? royalty-token amount tx-sender))
    (ok (map-set story-revenue
      { story-id: story-id }
      { total-revenue: (+ (get total-revenue current-revenue) amount) }
    ))
  )
)

(define-read-only (get-contributor-share (story-id uint) (contributor principal))
  (map-get? contributor-shares { story-id: story-id, contributor: contributor })
)

(define-read-only (get-story-revenue (story-id uint))
  (map-get? story-revenue { story-id: story-id })
)

