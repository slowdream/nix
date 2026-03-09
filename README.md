# Home Manager

Конфигурация окружения через Nix + Home Manager.

## Установка с нуля

### 1. Установка Nix

**официальный установщик**

```bash
curl -L https://nixos.org/nix/install | sh -s -- --daemon
```

Для single-user (без systemd):

```bash
curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
```

### 2. Включение flakes

Добавьте в `~/.config/nix/nix.conf`:

```
experimental-features = nix-command flakes
```

### 3. Home Manager

Отдельная установка не нужна — Home Manager подтягивается через flake при первом запуске.

## Запуск окружения

```bash
cd ~/.config/home-manager
home-manager switch --flake .#slowdream@server
```

Для первого запуска или если home-manager ещё не установлен:

```bash
nix run home-manager -- switch --flake ~/.config/home-manager#slowdream@server
```

## Другие команды

- **Проверка конфигурации** (без применения):

  ```bash
  home-manager build --flake .#slowdream@server
  ```

- **Обновление входов flake**:

  ```bash
  nix flake update
  ```

- **Откат к предыдущей генерации**:

  ```bash
  home-manager switch --flake .#slowdream@server --rollback
  ```

```md
.
├─ flake.nix
├─ flake.lock
├─ hosts/
│  ├─ laptop-zenbook/
│  │  ├─ home.nix          # "склейка" ролей + точечные оверрайды
│  │  └─ hardware.nix      # если нужно (чаще в NixOS, но можно держать рядом)
│  └─ work-pc/
│     └─ home.nix
├─ roles/
│  ├─ base.nix             # must-have: git, zsh, ssh, editors
│  ├─ dev.nix              # lang toolchains, docker tools, etc.
│  ├─ desktop.nix          # gui apps, theming, fonts
│  └─ server.nix           # tmux, htop, cli-only
├─ modules/
│  ├─ shell/
│  │  ├─ zsh.nix
│  │  ├─ starship.nix      # или p10k.nix
│  │  └─ tmux.nix
│  ├─ dev/
│  │  ├─ git.nix
│  │  ├─ direnv.nix
│  │  └─ editors.nix       # neovim/vscode
│  ├─ cli/
│  │  ├─ fzf.nix
│  │  └─ ripgrep.nix
│  └─ xdg.nix              # базовые XDG пути/стандарты
├─ home/
│  ├─ .gitconfig           # если проще хранить как файл
│  ├─ zsh/
│  │  └─ aliases.zsh
│  └─ config/
│     └─ ...               # файлы для xdg.configFile
├─ lib/
│  ├─ mkHost.nix           # хелперы сборки конфигов
│  └─ defaults.nix
└─ pkgs/
   ├─ overlay.nix
   └─ my-tools/
```

## Принцип: host-файлы должны быть «тонкими»

`hosts/<name>/home.nix` обычно делает только:

выбирает роли `(imports = [ roles/base.nix roles/dev.nix ... ])`

задаёт 5–15 опций, которые реально отличаются (мониторинг, GUI, набор шрифтов, пути, приватные переменные, специфичные пакеты)

Всё остальное — в ролях/модулях.

## Правило именования: модуль = одна ответственность

Хорошо:

`modules/shell/zsh.nix` отвечает только за zsh (плагины, алиасы, initExtra…)

`modules/dev/git.nix` отвечает только за git

Плохо:

`modules/common.nix` на 500 строк, куда «свалено всё»

## Используй XDG и раскладывай конфиги через xdg.*File

Это сильно повышает переносимость между системами.

```
xdg.configFile."app/config".text = ...

xdg.dataFile...

xdg.cacheHome (обычно не надо трогать)
```

Отдельный плюс: проще понимать, что реально уезжает в ~/.config, а что в ~.

## “Dotfiles” лучше хранить как генерируемые или source, но осознанно

Есть два рабочих подхода:

A) «Source» — копирование файлов из репо

Удобно для больших конфигов:

`xdg.configFile."nvim".source = ./home/config/nvim;`

B) «Text» — генерация из Nix

Удобно, когда нужно подставлять переменные/опции:

`xdg.configFile."git/config".text = '' ... ${cfg.userEmail} ... '';`

Частая практика: большие конфиги — source, маленькие — text.

## Секреты: не хранить в репо, интегрировать через sops/agenix

Для «универсального окружения» это критично:

пароли/токены/ssh-ключи — внешним менеджером

в HM подтягивать через sops-nix или agenix (в зависимости от твоего стека)

Если пока не готов — хотя бы вынеси приватное в отдельный локальный файл, который не коммитится, и подключай через `imports = [ ./secrets.local.nix ];`.

## Делай “feature flags” через mkIf + options

Если ты пишешь свои модули, хорошая практика:

модуль объявляет опции enable, package, extraConfig

и применяет конфиг через mkIf cfg.enable

Это превращает окружение в конструктор, а не в набор «магических imports».

## Пакеты: отделяй “базовый набор” от “роль-специфичных”

в `roles/base.nix` — минимальный жизненно необходимый CLI

в `roles/dev.nix` — всё для разработки

в `roles/desktop.nix` — GUI, шрифты, темы

И избегай «глобального списка пакетов» на сотню строк в одном месте.

## Версионируй входы и фиксируй совместимость

Практически полезно:

держать nixpkgs одним pinned input

для разных машин не плодить разные nixpkgs, если нет жёсткой причины

если нужна матрица (macOS/linux) — разделяй по system в flake outputs, но модули не дублируй

## Документация прямо в репо

Минимум:

README.md с командами применения (switch/activate), как добавить новый host/роль

`hosts/<name>/README.md` (опционально) для машинных особенностей

Это экономит много времени через 2–3 месяца.

## Набор “неочевидных” мелких best practices

Не хардкодь пути типа `/home/alex` — используй `$HOME/config.home.homeDirectory` (или вообще избегай).

Старайся, чтобы модули работали и на Linux и на macOS, используя pkgs.stdenv.isDarwin / isLinux только точечно.

Логику типа “если ноут — включить tlp/…“ лучше держать в NixOS, но в HM можно держать “laptop UX” (touchpad gestures, gui tools).

Старайся избегать home.file в ~ без нужды — XDG чище.
