# Miner Sim 3000 — Hackathon Split (3 People)

## Build Target

- Primary: HTML5
- Controls Scaffolded: WASD + Mouse Aim / Left Click / Space / E / W / 1-4 / B

## GameMaker Version Sync

- Open this project using the same GameMaker release across all 3 teammates.
- Project metadata is pinned to a compatibility baseline in [Mining Sim 3000.yyp](Mining Sim 3000.yyp).
- If the IDE still prompts for downgrade, one teammate should run Project Tool once, then commit the resulting metadata changes so everyone stays in sync.

## What is already scaffolded in project

- Main loop rooms: `rm_hub`, `rm_minigame`, `rm_boss_arena`
- Core objects: player, dirt blocks, mine entrances, workers, goblins, shop, boss
- Core scripts: boot, ore data, economy ticks, mining+combat helpers, minigame resolver, hub generation

---

## Shaarav (Lead / Strong Coder) — "Core Systems Owner"

### Primary ownership (Shaarav)

1. Stabilize architecture and data flow.
2. Refactor globals into robust structs / helper APIs.
3. Combat polish + boss behavior tuning.
4. Save/load + game-over/win flow.

### First coding tasks (Shaarav)

- Add persistent save (`money`, upgrades, unlocked mines, worker levels).
- Improve boss AI phases (dash / projectile / cooldown windows).
- Add proper invulnerability frames + hit feedback for player.
- Gate boss room with explicit prompt/UI state.

### Files to focus (Shaarav)

- `scripts/scr_boot/scr_boot.gml`
- `scripts/scr_economy/scr_economy.gml`
- `scripts/scr_mining/scr_mining.gml`
- `objects/obj_game_manager/*`
- `objects/obj_boss/*`

---

## Kian (Minigames + General Logic) — "Interaction Owner"

### Primary ownership (Kian)

1. Expand unlock minigames by ore type.
2. Build retry/cooldown UX and outcomes.
3. Add additional side-minigame hooks.

### First coding tasks (Kian)

- Replace one timing minigame with 5 variants by ore difficulty.
- Add fail states with clear text feedback and countdown.
- Add "practice mode" minigame from hub (no reward).
- Add minigame SFX trigger hooks.

### Files to focus (Kian)

- `scripts/scr_minigame/scr_minigame.gml`
- `objects/obj_minigame_controller/*`
- `objects/obj_mine_entrance/*`
- `rooms/rm_minigame/*`

---

## Darsh (Design + Light Code) — "Feel & Visual Owner"

### Primary ownership (Darsh)

1. Placeholder art pipeline + naming consistency.
2. HUD readability and icon pass.
3. Layout polish of hub/minigame/boss arena.

### First coding/design tasks

- Replace rectangle placeholders with pixel sprites.
- Add sprite sheets: player idle/walk, goblin walk, boss, blocks by ore tint.
- Improve HUD typography/colors and objective panel.
- Tweak room composition for visual navigation and readability.

### Files to focus (Darsh)

- Sprites + tilesets (new resources)
- `objects/obj_player/obj_player_Draw_0.gml`
- `objects/obj_dirt_block/obj_dirt_block_Draw_0.gml`
- `objects/obj_game_manager/obj_game_manager_Draw_0.gml`
- room layer composition in `rm_hub`, `rm_boss_arena`

---

## Fast 6-Hour Hackathon Timeline

1. Hour 1: Core loop sanity (Shaarav) + minigame variant setup (Kian) + placeholder art pack (Darsh)
2. Hour 2-3: Economy balance + unlock pacing + room readability pass
3. Hour 4: Boss tuning + weapon feel + VFX/audio placeholders
4. Hour 5: Bug sweep, soft-lock checks, restart flow
5. Hour 6: Demo route rehearsal (start -> first mine -> upgrades -> boss)

## Demo Success Path (what judges should see)

1. Mine dirt and discover shaft
2. Play unlock minigame
3. Buy worker and observe passive income
4. Buy weapon upgrade
5. Enter boss room and win
