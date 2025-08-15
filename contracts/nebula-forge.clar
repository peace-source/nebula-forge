;; Title: NebulaForge - Interstellar Gaming Metaverse
;;
;; Summary:
;; NebulaForge powers the next generation of decentralized gaming through an immersive
;; interstellar metaverse where players forge legendary artifacts, command cosmic fleets,
;; and compete across galaxies for ultimate supremacy and astronomical rewards.
;;
;; Description:
;; Built for the future of Web3 gaming, NebulaForge creates a seamless ecosystem where
;; digital ownership meets competitive gameplay. Players can:
;;
;; - Forge and evolve unique cosmic artifacts with dynamic attributes
;; - Build and customize interstellar command centers with progression systems
;; - Explore multiple star systems with varying difficulty and reward tiers
;; - Engage in secure peer-to-peer trading of rare galactic assets
;; - Compete in real-time leaderboards for prestigious cosmic championships
;; - Earn governance tokens through skilled gameplay and strategic decisions
;; - Participate in cross-galaxy tournaments with substantial prize pools
;;
;; The protocol implements military-grade security with rate limiting, comprehensive
;; event tracking, and decentralized reward distribution, ensuring fair play and
;; sustainable tokenomics for long-term ecosystem growth.

;; ERROR CONSTANTS
(define-constant ERR-NOT-AUTHORIZED (err u1))
(define-constant ERR-INVALID-GAME-ASSET (err u2))
(define-constant ERR-INSUFFICIENT-FUNDS (err u3))
(define-constant ERR-TRANSFER-FAILED (err u4))
(define-constant ERR-LEADERBOARD-FULL (err u5))
(define-constant ERR-ALREADY-REGISTERED (err u6))
(define-constant ERR-INVALID-REWARD (err u7))
(define-constant ERR-INVALID-INPUT (err u8))
(define-constant ERR-INVALID-SCORE (err u9))
(define-constant ERR-INVALID-FEE (err u10))
(define-constant ERR-INVALID-ENTRIES (err u11))
(define-constant ERR-PLAYER-NOT-FOUND (err u12))
(define-constant ERR-INVALID-AVATAR (err u13))
(define-constant ERR-WORLD-NOT-FOUND (err u14))
(define-constant ERR-INVALID-NAME (err u15))
(define-constant ERR-INVALID-DESCRIPTION (err u16))
(define-constant ERR-INVALID-RARITY (err u17))
(define-constant ERR-INVALID-POWER-LEVEL (err u18))
(define-constant ERR-INVALID-ATTRIBUTES (err u19))
(define-constant ERR-INVALID-WORLD-ACCESS (err u20))
(define-constant ERR-INVALID-OWNER (err u21))
(define-constant ERR-MAX-LEVEL-REACHED (err u22))
(define-constant ERR-MAX-EXPERIENCE-REACHED (err u23))
(define-constant ERR-INVALID-LEVEL-UP (err u24))
(define-constant ERR-TRADE-NOT-FOUND (err u25))
(define-constant ERR-TRADE-EXPIRED (err u26))
(define-constant ERR-INVALID-TRADE-STATUS (err u27))
(define-constant ERR-INSUFFICIENT-BALANCE (err u28))

;; GAME MECHANICS CONSTANTS
(define-constant MAX-LEVEL u100)
(define-constant MAX-EXPERIENCE-PER-LEVEL u1000)
(define-constant BASE-EXPERIENCE-REQUIRED u100)
(define-constant RATE-LIMIT-WINDOW u144) ;; 24 hours in blocks (10 min blocks)
(define-constant MAX-CALLS-PER-WINDOW u100)

;; EVENT TYPE CONSTANTS
(define-constant EVENT-ASSET-MINTED "asset-minted")
(define-constant EVENT-ASSET-TRANSFERRED "asset-transferred")
(define-constant EVENT-AVATAR-CREATED "avatar-created")
(define-constant EVENT-EXPERIENCE-GAINED "experience-gained")
(define-constant EVENT-LEVEL-UP "level-up")
(define-constant EVENT-WORLD-CREATED "world-created")
(define-constant EVENT-TRADE-INITIATED "trade-initiated")
(define-constant EVENT-TRADE-COMPLETED "trade-completed")
(define-constant EVENT-TRADE-CANCELLED "trade-cancelled")

;; PROTOCOL CONFIGURATION VARIABLES
(define-data-var protocol-fee uint u10)
(define-data-var max-leaderboard-entries uint u50)
(define-data-var total-prize-pool uint u0)
(define-data-var total-assets uint u0)
(define-data-var total-avatars uint u0)
(define-data-var total-worlds uint u0)
(define-data-var total-trades uint u0)

;; ACCESS CONTROL
(define-map protocol-admin-whitelist
  principal
  bool
)

;; INPUT VALIDATION FUNCTIONS

;; Validates cosmic artifact names (1-50 characters, non-empty)
(define-private (is-valid-name (name (string-ascii 50)))
  (and
    (>= (len name) u1)
    (<= (len name) u50)
    (not (is-eq name ""))
  )
)

;; Validates artifact descriptions (1-200 characters, non-empty)
(define-private (is-valid-description (description (string-ascii 200)))
  (and
    (>= (len description) u1)
    (<= (len description) u200)
    (not (is-eq description ""))
  )
)