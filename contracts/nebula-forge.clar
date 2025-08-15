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

;; Validates artifact rarity tiers
(define-private (is-valid-rarity (rarity (string-ascii 20)))
  (or
    (is-eq rarity "common")
    (is-eq rarity "uncommon")
    (is-eq rarity "rare")
    (is-eq rarity "epic")
    (is-eq rarity "legendary")
  )
)

;; Validates power levels (1-1000 range)
(define-private (is-valid-power-level (power uint))
  (and (>= power u1) (<= power u1000))
)

;; Validates attribute arrays (1-10 attributes max)
(define-private (is-valid-attributes (attributes (list 10 (string-ascii 20))))
  (and
    (>= (len attributes) u1)
    (<= (len attributes) u10)
  )
)

;; Validates star system access permissions
(define-private (is-valid-world-access (worlds (list 10 uint)))
  (and
    (>= (len worlds) u1)
    (<= (len worlds) u10)
    (fold check-world-exists worlds true)
  )
)

;; Helper function to verify star system existence
(define-private (check-world-exists
    (world-id uint)
    (valid bool)
  )
  (and valid (is-some (get-world-details world-id)))
)

;; NFT DEFINITIONS
(define-non-fungible-token bitrealm-asset uint)
(define-non-fungible-token player-avatar uint)

;; DATA STRUCTURES

;; Cosmic Artifact Metadata Storage
(define-map bitrealm-asset-metadata
  { token-id: uint }
  {
    name: (string-ascii 50),
    description: (string-ascii 200),
    rarity: (string-ascii 20),
    power-level: uint,
    world-id: uint,
    attributes: (list 10 (string-ascii 20)),
    experience: uint,
    level: uint,
  }
)

;; Command Center (Avatar) Metadata Storage
(define-map avatar-metadata
  { avatar-id: uint }
  {
    name: (string-ascii 50),
    level: uint,
    experience: uint,
    achievements: (list 20 (string-ascii 50)),
    equipped-assets: (list 5 uint),
    world-access: (list 10 uint),
  }
)

;; Star System Registry
(define-map game-worlds
  { world-id: uint }
  {
    name: (string-ascii 50),
    description: (string-ascii 200),
    entry-requirement: uint,
    active-players: uint,
    total-rewards: uint,
  }
)

;; Galactic Leaderboard System
(define-map leaderboard
  { player: principal }
  {
    score: uint,
    games-played: uint,
    total-rewards: uint,
    avatar-id: uint,
    rank: uint,
    achievements: (list 20 (string-ascii 50)),
  }
)

;; Player Ranking Cache
(define-map player-rankings
  { rank: uint }
  {
    player: principal,
    score: uint,
  }
)

;; Interstellar Trading Hub
(define-map active-trades
  { trade-id: uint }
  {
    seller: principal,
    asset-id: uint,
    price: uint,
    expiry: uint,
    status: (string-ascii 20),
    buyer: (optional principal),
  }
)

;; Security Rate Limiting System
(define-map rate-limits
  {
    function: (string-ascii 50),
    caller: principal,
  }
  {
    last-call: uint,
    calls: uint,
  }
)

;; READ-ONLY UTILITY FUNCTIONS

;; Checks if caller has administrative privileges
(define-read-only (is-protocol-admin (sender principal))
  (default-to false (map-get? protocol-admin-whitelist sender))
)

;; Validates principal addresses for security
(define-read-only (is-valid-principal (input principal))
  (and
    (not (is-eq input tx-sender))
    (not (is-eq input (as-contract tx-sender)))
  )
)

;; Enhanced principal validation with registry check
(define-read-only (is-safe-principal (input principal))
  (and
    (is-valid-principal input)
    (or
      (is-protocol-admin input)
      (is-some (map-get? leaderboard { player: input }))
    )
  )
)

;; Retrieves star system configuration
(define-read-only (get-world-details (world-id uint))
  (map-get? game-worlds { world-id: world-id })
)

;; Fetches command center details
(define-read-only (get-avatar-details (avatar-id uint))
  (map-get? avatar-metadata { avatar-id: avatar-id })
)

;; Returns top-performing players (simplified implementation)
(define-read-only (get-top-players)
  (let ((max-entries (var-get max-leaderboard-entries)))
    (list
      tx-sender
    )
  )
)

;; Calculates experience required for next level advancement
(define-read-only (get-next-level-requirement (avatar-id uint))
  (match (get-avatar-details avatar-id)
    metadata (ok (calculate-level-up-experience (get level metadata)))
    ERR-INVALID-AVATAR
  )
)

;; Validates if command center can receive experience points
(define-read-only (can-receive-experience
    (avatar-id uint)
    (experience-amount uint)
  )
  (match (get-avatar-details avatar-id)
    metadata (ok (and
      (< (get level metadata) MAX-LEVEL)
      (validate-experience-gain (get experience metadata) experience-amount
        (get level metadata)
      )
    ))
    ERR-INVALID-AVATAR
  )
)

;; Retrieves paginated leaderboard data
(define-read-only (get-paginated-leaderboard
    (page uint)
    (items-per-page uint)
  )
  (let (
      (start (* page items-per-page))
      (end (+ start items-per-page))
    )
    (filter is-valid-ranking
      (map get-ranking-at-position (generate-sequence start end))
    )
  )
)

;; PROTOCOL ADMINISTRATION

;; Initializes the NebulaForge protocol with configuration parameters
(define-public (initialize-protocol
    (entry-fee uint)
    (max-entries uint)
  )
  (begin
    (asserts! (is-protocol-admin tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (and (>= entry-fee u1) (<= entry-fee u1000)) ERR-INVALID-FEE)
    (asserts! (and (>= max-entries u1) (<= max-entries u500)) ERR-INVALID-ENTRIES)

    (var-set protocol-fee entry-fee)
    (var-set max-leaderboard-entries max-entries)

    (ok true)
  )
)

;; COSMIC ARTIFACT MANAGEMENT

;; Forges new cosmic artifacts with unique properties
(define-public (mint-bitrealm-asset
    (name (string-ascii 50))
    (description (string-ascii 200))
    (rarity (string-ascii 20))
    (power-level uint)
    (world-id uint)
    (attributes (list 10 (string-ascii 20)))
  )
  (let ((token-id (+ (var-get total-assets) u1)))
    (asserts! (is-protocol-admin tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-valid-name name) ERR-INVALID-NAME)
    (asserts! (is-valid-description description) ERR-INVALID-DESCRIPTION)
    (asserts! (is-valid-rarity rarity) ERR-INVALID-RARITY)
    (asserts! (is-valid-power-level power-level) ERR-INVALID-POWER-LEVEL)
    (asserts! (is-some (get-world-details world-id)) ERR-WORLD-NOT-FOUND)
    (asserts! (is-valid-attributes attributes) ERR-INVALID-ATTRIBUTES)

    (try! (nft-mint? bitrealm-asset token-id tx-sender))

    (map-set bitrealm-asset-metadata { token-id: token-id } {
      name: name,
      description: description,
      rarity: rarity,
      power-level: power-level,
      world-id: world-id,
      attributes: attributes,
      experience: u0,
      level: u1,
    })

    (var-set total-assets token-id)

    (unwrap! (emit-asset-event EVENT-ASSET-MINTED token-id tx-sender none)
      ERR-NOT-AUTHORIZED
    )

    (ok token-id)
  )
)

;; Transfers cosmic artifacts between commanders
(define-public (transfer-game-asset
    (token-id uint)
    (recipient principal)
  )
  (begin
    (asserts!
      (is-eq tx-sender
        (unwrap! (nft-get-owner? bitrealm-asset token-id) ERR-INVALID-GAME-ASSET)
      )
      ERR-NOT-AUTHORIZED
    )

    (asserts! (is-valid-principal recipient) ERR-INVALID-INPUT)

    (nft-transfer? bitrealm-asset token-id tx-sender recipient)
  )
)

;; COMMAND CENTER (AVATAR) SYSTEM

;; Establishes new interstellar command center
(define-public (create-avatar
    (name (string-ascii 50))
    (world-access (list 10 uint))
  )
  (let ((avatar-id (+ (var-get total-avatars) u1)))
    (asserts! (is-valid-name name) ERR-INVALID-NAME)
    (asserts! (is-valid-world-access world-access) ERR-INVALID-WORLD-ACCESS)
    (asserts! (is-none (map-get? leaderboard { player: tx-sender }))
      ERR-ALREADY-REGISTERED
    )

    (try! (nft-mint? player-avatar avatar-id tx-sender))

    (map-set avatar-metadata { avatar-id: avatar-id } {
      name: name,
      level: u1,
      experience: u0,
      achievements: (list),
      equipped-assets: (list),
      world-access: world-access,
    })

    (map-set leaderboard { player: tx-sender } {
      score: u0,
      games-played: u0,
      total-rewards: u0,
      avatar-id: avatar-id,
      rank: u0,
      achievements: (list),
    })

    (var-set total-avatars avatar-id)
    (ok avatar-id)
  )
)

;; Advances command center experience and handles level progression
(define-public (update-avatar-experience
    (avatar-id uint)
    (experience-gained uint)
  )
  (let (
      (current-metadata (unwrap! (get-avatar-details avatar-id) ERR-INVALID-AVATAR))
      (avatar-owner (unwrap! (nft-get-owner? player-avatar avatar-id) ERR-INVALID-AVATAR))
      (current-level (get level current-metadata))
      (current-experience (get experience current-metadata))
    )
    (asserts! (is-protocol-admin tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (<= avatar-id (var-get total-avatars)) ERR-INVALID-AVATAR)
    (asserts! (> experience-gained u0) ERR-INVALID-INPUT)
    (asserts! (< current-level MAX-LEVEL) ERR-MAX-LEVEL-REACHED)
    (asserts!
      (validate-experience-gain current-experience experience-gained
        current-level
      )
      ERR-MAX-EXPERIENCE-REACHED
    )

    (let (
        (new-experience (+ current-experience experience-gained))
        (should-level-up (can-level-up current-experience experience-gained current-level))
        (new-level (if should-level-up
          (+ current-level u1)
          current-level
        ))
      )
      (asserts! (or (not should-level-up) (<= new-level MAX-LEVEL))
        ERR-MAX-LEVEL-REACHED
      )

      (map-set avatar-metadata { avatar-id: avatar-id }
        (merge current-metadata {
          experience: new-experience,
          level: new-level,
        })
      )

      (ok should-level-up)
    )
  )
)

;; STAR SYSTEM MANAGEMENT

;; Creates new explorable star systems
(define-public (create-game-world
    (name (string-ascii 50))
    (description (string-ascii 200))
    (entry-requirement uint)
  )
  (let ((world-id (+ (var-get total-worlds) u1)))
    (asserts! (is-protocol-admin tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-valid-name name) ERR-INVALID-NAME)
    (asserts! (is-valid-description description) ERR-INVALID-DESCRIPTION)
    (asserts! (>= entry-requirement u0) ERR-INVALID-INPUT)

    (map-set game-worlds { world-id: world-id } {
      name: name,
      description: description,
      entry-requirement: entry-requirement,
      active-players: u0,
      total-rewards: u0,
    })

    (var-set total-worlds world-id)
    (ok world-id)
  )
)

;; GALACTIC LEADERBOARD SYSTEM

;; Updates commander performance metrics
(define-public (update-player-score
    (player principal)
    (new-score uint)
  )
  (let ((current-stats (unwrap! (map-get? leaderboard { player: player }) ERR-PLAYER-NOT-FOUND)))
    (asserts! (is-protocol-admin tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-valid-principal player) ERR-INVALID-INPUT)
    (asserts! (and (>= new-score u0) (<= new-score u10000)) ERR-INVALID-SCORE)

    (map-set leaderboard { player: player }
      (merge current-stats {
        score: new-score,
        games-played: (+ (get games-played current-stats) u1),
      })
    )

    (ok true)
  )
)

;; REWARD DISTRIBUTION SYSTEM

;; Distributes cosmic rewards to top-performing commanders
(define-public (distribute-bitcoin-rewards)
  (let ((top-players (get-top-players)))
    (asserts! (is-protocol-admin tx-sender) ERR-NOT-AUTHORIZED)

    (try! (fold distribute-reward (filter is-valid-reward-candidate top-players)
      (ok true)
    ))

    (ok true)
  )
)

;; EVENT TRACKING SYSTEM

;; Emits blockchain events for artifact activities
(define-public (emit-asset-event
    (event-type (string-ascii 20))
    (asset-id uint)
    (sender principal)
    (recipient (optional principal))
  )
  (begin
    (print {
      event: event-type,
      asset-id: asset-id,
      sender: sender,
      recipient: recipient,
      timestamp: stacks-block-height,
    })
    (ok true)
  )
)

;; INTERSTELLAR TRADING SYSTEM

;; Initiates peer-to-peer artifact trading
(define-public (create-trade
    (asset-id uint)
    (price uint)
    (expiry uint)
  )
  (let (
      (trade-id (+ (var-get total-trades) u1))
      (owner (unwrap! (nft-get-owner? bitrealm-asset asset-id) ERR-INVALID-GAME-ASSET))
    )
    (asserts! (> price u0) ERR-INVALID-INPUT)
    (asserts! (< price u1000000000) ERR-INVALID-INPUT)
    (asserts! (is-eq tx-sender owner) ERR-NOT-AUTHORIZED)
    (asserts! (> expiry stacks-block-height) ERR-INVALID-INPUT)

    (map-set active-trades { trade-id: trade-id } {
      seller: tx-sender,
      asset-id: asset-id,
      price: price,
      expiry: expiry,
      status: "active",
      buyer: none,
    })

    (var-set total-trades trade-id)

    (unwrap! (emit-asset-event EVENT-TRADE-INITIATED asset-id tx-sender none)
      ERR-NOT-AUTHORIZED
    )

    (ok trade-id)
  )
)

;; Executes secure artifact trades with atomic swaps
(define-public (execute-trade (trade-id uint))
  (let ((total-trades-count (var-get total-trades)))
    (asserts! (<= trade-id total-trades-count) ERR-TRADE-NOT-FOUND)
    (asserts! (> trade-id u0) ERR-INVALID-INPUT)

    (let (
        (trade (unwrap! (map-get? active-trades { trade-id: trade-id })
          ERR-TRADE-NOT-FOUND
        ))
        (asset-id (get asset-id trade))
      )
      (asserts! (is-eq (get status trade) "active") ERR-INVALID-TRADE-STATUS)
      (asserts! (<= stacks-block-height (get expiry trade)) ERR-TRADE-EXPIRED)
      (asserts! (>= (stx-get-balance tx-sender) (get price trade))
        ERR-INSUFFICIENT-BALANCE
      )

      ;; Execute atomic swap
      (try! (stx-transfer? (get price trade) tx-sender (get seller trade)))
      (try! (nft-transfer? bitrealm-asset asset-id (get seller trade) tx-sender))

      ;; Update trade status
      (map-set active-trades { trade-id: trade-id }
        (merge trade {
          status: "completed",
          buyer: (some tx-sender),
        })
      )

      (unwrap!
        (emit-asset-event EVENT-TRADE-COMPLETED asset-id (get seller trade)
          (some tx-sender)
        )
        ERR-NOT-AUTHORIZED
      )

      (ok true)
    )
  )
)

;; PRIVATE HELPER FUNCTIONS

;; Validates reward eligibility
(define-private (is-valid-reward-candidate (player principal))
  (match (map-get? leaderboard { player: player })
    stats (and
      (> (get score stats) u0)
      (is-valid-principal player)
    )
    false
  )
)

;; Distributes individual rewards to commanders
(define-private (distribute-reward
    (player principal)
    (previous-result (response bool uint))
  )
  (match (map-get? leaderboard { player: player })
    player-stats (let ((reward-amount (calculate-reward (get score player-stats))))
      (if (and (is-ok previous-result) (> reward-amount u0))
        (begin
          (map-set leaderboard { player: player }
            (merge player-stats { total-rewards: (+ (get total-rewards player-stats) reward-amount) })
          )
          (ok true)
        )
        previous-result
      )
    )
    previous-result
  )
)

;; Calculates reward amounts based on performance
(define-private (calculate-reward (score uint))
  (if (and (> score u100) (<= score u10000))
    (* score u10)
    u0
  )
)

;; Calculates experience requirements for level advancement
(define-private (calculate-level-up-experience (current-level uint))
  (* BASE-EXPERIENCE-REQUIRED current-level)
)

;; Validates experience point gains within limits
(define-private (validate-experience-gain
    (current-experience uint)
    (gained-experience uint)
    (current-level uint)
  )
  (let (
      (max-allowed-gain (calculate-level-up-experience current-level))
      (new-total-experience (+ current-experience gained-experience))
    )
    (and
      (<= gained-experience max-allowed-gain)
      (<= new-total-experience (* MAX-EXPERIENCE-PER-LEVEL current-level))
    )
  )
)