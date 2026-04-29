# Changelog

All notable changes to FS25_MarketDynamics will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [1.1.5.0] - 2026-04-29

### Added
- Custom contract quantity — new text-input dialog lets you enter any amount instead of being limited to presets
- Custom delivery window — type any number of in-game or real-world days for contract deadlines
- MDM Settings Panel — new in-game settings UI accessible from the server settings screen

### Fixed
- Save file moved from `savegameDirectory/modSettings/` to `savegameDirectory/` directly, preventing dedicated servers from rejecting uploaded savegames that contain subfolders (#47)
- Existing saves from v1.1.4.x are automatically migrated to the new path on first load
- Qty preset buttons in the contract dialog no longer overflow outside the dialog visual boundary (#46)
- Custom input dialog height increased so hint text is fully visible

---

## [1.1.4.1] - 2026-04-28

### Fixed
- Contract list no longer duplicates or desyncs on dedicated servers
- Contracts now correctly sync to all clients after server load (#43)

---

## [1.1.4.0] - 2026-04-26

### Fixed
- MDM settings tab no longer overwrites the MP Server Settings tab in the ESC menu

---

## [1.1.3.0] - 2026-04-26

### Fixed
- Multiplayer contract sync reliability improvements
- KingMods escape key conflict resolved (#33)
- Comprehensive README added with feature overview and keyboard shortcuts (#32)
- German translation updated

---

## [1.1.2.0] - 2026-04-22

### Added
- Three new world events: **ColdSnap**, **FinancialPanic**, and **ProteinPremium**

---

## [1.1.1.0] - 2026-04-09

### Changed
- BetterContracts integration renamed to **FuturesMission** throughout — no functional change, aligns with the correct mod name

### Fixed
- Multiplayer futures contract network sync (#31)
- Network sync and delivery time calculation edge cases
- Duplicate BC contracts no longer created in `onBCContractCreated`
- Game time now uses `MDMUtil.getGameTime` (absolute) instead of `g_currentMission.time`

---

## [1.1.0.0] - 2026-03-29

### Added
- **BetterContracts integration** — full BC↔MDM handshake; futures contracts exposed to the BC UI
- `BCIntegration.getContractsForFarm` for savegame migration support
- 4 new API functions exposed for BetterContracts cross-mod use
- InfoDialog shown when New Contract is pressed with BetterContracts active

### Fixed
- Price display $0 bug on first load
- Contract click not registering in some UI states
- Volatility calculation edge cases
- Delivery lockout not correctly enforced
- Game freeze prevented when pressing New Contract with BetterContracts active

---

## [1.0.9.2] - 2026-04-22 *(pre-release tag)*

### Added
- ColdSnap, FinancialPanic, ProteinPremium world events

---

## [1.0.0.0] - 2026-03-24

### Added
- **Futures contract system** — lock in a price for a future harvest; penalty applies for missed delivery
- **Contract admin dialog** — server admins can view, manage, and delete contracts in-game
- **World Events system** — randomized global events (trade disruption, drought, bumper harvest, etc.) that shift crop prices
- **Market Settings** — dedicated ESC > Settings tab for event frequency, futures penalty, volatility scale, and price toggle
- **UsedPlus integration** — futures contract payouts credit the UsedPlus market API when detected
- **25-language localization** — full translations shipped at launch
- Contract creation dialog with quantity presets and delivery window selection
- Price history graph per crop on the Market Screen
- HUD settlement notifications when a contract pays out or expires
- Cross-mod API via `g_currentMission.MarketDynamics`

### Fixed
- 7-bug audit pass covering tab UX, N key inputEvent, setTextColor crash
- Native `fs25_dialogButtonBox` used for all dialogs (correct FS25 button bar pattern)
- Dedicated server support — simulation runs headless with no GUI dependencies
- Settings tab no longer conflicts with the vanilla settings screen

---

## [0.1.0] - 2026-03-19 *(pre-release)*

### Added
- Initial public pre-release
- MarketEngine with daily + intraday price volatility
- WorldEventSystem with 4 starter events
- FuturesMarket with contract creation and delivery tracking
- MarketSerializer (save/load per savegame)
- Market Screen UI with price graph and contract list tab
- SellingStation hook for automatic futures delivery tracking
- Build script for packaging and deployment
