# NebulaForge - Interstellar Gaming Metaverse

[![Stacks](https://img.shields.io/badge/Stacks-Blockchain-purple)](https://stacks.co)
[![Clarity](https://img.shields.io/badge/Clarity-Smart%20Contract-blue)](https://clarity-lang.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Overview

NebulaForge powers the next generation of decentralized gaming through an immersive interstellar metaverse where players forge legendary artifacts, command cosmic fleets, and compete across galaxies for ultimate supremacy and astronomical rewards.

Built for the future of Web3 gaming, NebulaForge creates a seamless ecosystem where digital ownership meets competitive gameplay, featuring military-grade security with rate limiting, comprehensive event tracking, and decentralized reward distribution.

## 🚀 Features

### Core Gaming Mechanics

- **Cosmic Artifact Forging**: Create and evolve unique NFT artifacts with dynamic attributes
- **Command Center System**: Build and customize interstellar command centers with progression systems
- **Multi-Galaxy Exploration**: Explore multiple star systems with varying difficulty and reward tiers
- **Peer-to-Peer Trading**: Secure trading of rare galactic assets with atomic swaps
- **Competitive Leaderboards**: Real-time rankings for prestigious cosmic championships
- **Governance Integration**: Earn tokens through skilled gameplay and strategic decisions

### Advanced Features

- **Cross-Galaxy Tournaments**: Participate in tournaments with substantial prize pools
- **Experience & Leveling**: Dynamic progression system with 100 levels
- **Rate Limiting Security**: Military-grade protection against abuse
- **Event Tracking**: Comprehensive blockchain event logging
- **Reward Distribution**: Automated and fair reward mechanisms

## 🏗 Architecture

### Smart Contract Structure

```
contracts/
├── nebula-forge.clar          # Main contract
└── dependencies/              # Future modular contracts
```

### Core Components

#### NFT Assets

- **Bitrealm Assets**: Unique cosmic artifacts with metadata
- **Player Avatars**: Command center representations with progression

#### Data Storage

- **Asset Metadata**: Names, descriptions, rarity, power levels, attributes
- **Avatar Progression**: Levels, experience, achievements, equipment
- **World Registry**: Star system configurations and requirements
- **Trading System**: Active trades with expiry and status tracking
- **Leaderboards**: Player rankings and performance metrics

#### Security Features

- **Access Control**: Admin whitelist system
- **Rate Limiting**: Time-based function call restrictions
- **Input Validation**: Comprehensive parameter checking
- **Event Logging**: Full audit trail of all actions

## 📋 Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) v2.0+
- [Node.js](https://nodejs.org/) v16+
- [Stacks CLI](https://docs.stacks.co/docs/cli)

## 🛠 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/peace-source/nebula-forge.git
cd nebula-forge
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Initialize Clarinet

```bash
clarinet check
```

## 🔧 Development

### Running Tests

```bash
# Run all tests
npm test

# Check contract syntax
clarinet check

# Run specific test file
npx vitest tests/nebula-forge.test.ts
```

### Local Deployment

```bash
# Start local devnet
clarinet integrate

# Deploy to testnet
clarinet deployment apply --testnet
```

### Contract Verification

```bash
# Format code
clarinet fmt

# Check for errors
clarinet check contracts/nebula-forge.clar
```

## 📚 API Reference

### Public Functions

#### Protocol Administration

```clarity
(initialize-protocol (entry-fee uint) (max-entries uint))
```

Initializes the protocol with configuration parameters.

#### Cosmic Artifact Management

```clarity
(mint-bitrealm-asset (name (string-ascii 50)) (description (string-ascii 200)) 
                     (rarity (string-ascii 20)) (power-level uint) 
                     (world-id uint) (attributes (list 10 (string-ascii 20))))
```

Forges new cosmic artifacts with unique properties.

```clarity
(transfer-game-asset (token-id uint) (recipient principal))
```

Transfers cosmic artifacts between commanders.

#### Command Center System

```clarity
(create-avatar (name (string-ascii 50)) (world-access (list 10 uint)))
```

Establishes new interstellar command center.

```clarity
(update-avatar-experience (avatar-id uint) (experience-gained uint))
```

Advances command center experience and handles level progression.

#### Star System Management

```clarity
(create-game-world (name (string-ascii 50)) (description (string-ascii 200)) 
                   (entry-requirement uint))
```

Creates new explorable star systems.

#### Trading System

```clarity
(create-trade (asset-id uint) (price uint) (expiry uint))
```

Initiates peer-to-peer artifact trading.

```clarity
(execute-trade (trade-id uint))
```

Executes secure artifact trades with atomic swaps.

### Read-Only Functions

```clarity
(get-world-details (world-id uint))
(get-avatar-details (avatar-id uint))
(get-next-level-requirement (avatar-id uint))
(can-receive-experience (avatar-id uint) (experience-amount uint))
(get-paginated-leaderboard (page uint) (items-per-page uint))
```

## 🎮 Usage Examples

### Creating Your First Avatar

```clarity
;; Create a command center with access to worlds 1 and 2
(contract-call? .nebula-forge create-avatar "StarCommander" (list u1 u2))
```

### Minting Cosmic Artifacts

```clarity
;; Mint a legendary sword for world 1
(contract-call? .nebula-forge mint-bitrealm-asset 
  "Nebula Sword" 
  "A legendary weapon forged in the heart of a dying star"
  "legendary"
  u800
  u1
  (list "fire" "cosmic" "sharp"))
```

### Trading Assets

```clarity
;; Create a trade for asset #1 at 1000 STX, expires in 1000 blocks
(contract-call? .nebula-forge create-trade u1 u1000000 (+ block-height u1000))

;; Execute the trade
(contract-call? .nebula-forge execute-trade u1)
```

## 🔐 Security Features

### Access Control

- Admin whitelist system for protocol management
- Owner validation for asset transfers
- Principal address validation

### Rate Limiting

- 24-hour windows with 100 max calls per function
- Prevents spam and abuse
- Configurable limits per function

### Input Validation

- String length validation (1-50 chars for names, 1-200 for descriptions)
- Numeric range validation (power levels 1-1000)
- Array size limits (1-10 attributes)
- Rarity tier validation

## 📊 Constants & Configuration

### Game Mechanics

- **MAX_LEVEL**: 100 levels maximum
- **MAX_EXPERIENCE_PER_LEVEL**: 1000 XP per level
- **BASE_EXPERIENCE_REQUIRED**: 100 XP for level calculations

### Security

- **RATE_LIMIT_WINDOW**: 144 blocks (24 hours)
- **MAX_CALLS_PER_WINDOW**: 100 calls per window

### Event Types

- Asset minting, transfers, and trading events
- Avatar creation and experience events
- World creation and level-up events

## 🧪 Testing

The contract includes comprehensive tests covering:

- Asset minting and transfers
- Avatar creation and progression  
- Trading system functionality
- Access control and security
- Input validation
- Rate limiting mechanisms

Run tests with:

```bash
npm test
```

## 🚀 Deployment

### Testnet Deployment

```bash
# Configure testnet settings
clarinet deployment plan --testnet

# Deploy to testnet
clarinet deployment apply --testnet
```

### Mainnet Deployment

```bash
# Configure mainnet settings  
clarinet deployment plan --mainnet

# Deploy to mainnet (requires mainnet STX)
clarinet deployment apply --mainnet
```

## 📈 Roadmap

### Phase 1: Core Infrastructure ✅

- [x] NFT system implementation
- [x] Avatar progression mechanics
- [x] Trading system
- [x] Security framework

### Phase 2: Enhanced Gameplay 🔄

- [ ] Tournament system
- [ ] Guild mechanics
- [ ] Advanced crafting
- [ ] Cross-chain integration

### Phase 3: Ecosystem Expansion 📋

- [ ] Mobile integration
- [ ] Governance token
- [ ] DAO implementation
- [ ] Marketplace frontend

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Process

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

### Code Standards

- Follow Clarity best practices
- Include comprehensive tests
- Document all public functions
- Use consistent naming conventions

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
