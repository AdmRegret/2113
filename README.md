# keywork

Every night at **21:13**, your KDE Plasma desktop switches to a random Coheed and Cambria wallpaper and plays a short audio clip for one minute, then puts everything back the way it was.

Named after the Keywork from The Amory Wars. Entirely unnecessary. Highly recommended.

## What it does

1. Picks a random image from `~/Pictures/Wallpapers/keywork`.
2. Remembers your current wallpaper.
3. Pauses [AlbumShift](https://github.com/AdmRegret/AlbumShift) if it's installed, so a rotation can't land mid-minute.
4. Sets the wallpaper and plays a random clip from `~/Music/keywork`.
5. After 60 seconds, stops the clip, restores your wallpaper, and resumes AlbumShift.

The restore also runs if keywork is interrupted (Ctrl+C or a stopped service), so you're never stuck in 21:13 forever.

## Bring your own art

This repo doesn't include any images or audio. Album artwork and music belong to the band and their artists, so add your own collection:

- **Wallpapers** go in `~/Pictures/Wallpapers/keywork` (`.jpg`, `.jpeg`, `.png`, `.webp`)
- **Audio clips** go in `~/Music/keywork` (`.wav`, `.flac`, `.ogg`, `.opus`, `.mp3`)

With no audio clip present, keywork runs silently.

## Requirements

- KDE Plasma (uses `plasma-apply-wallpaperimage`, works on Wayland)
- `bash`, `python3`, `shuf` (coreutils)
- An audio player: `pw-play` (PipeWire, default on Fedora/Nobara), `mpv`, or `paplay`

## Install

```bash
git clone https://github.com/AdmRegret/2113.git
cd 2113
./install.sh
```

The installer copies `keywork` to `~/.local/bin`, creates the image and audio folders, and enables a systemd user timer for 21:13 daily.

Test without waiting for 21:13:

```bash
KEYWORK_SECONDS=10 keywork
```

## Configuration

Settings are environment variables. For the timer, add them to the service with `systemctl --user edit keywork.service`:

```ini
[Service]
Environment=KEYWORK_VOLUME=0.5
```

| Variable | Default | Notes |
|---|---|---|
| `KEYWORK_DIR` | `~/Pictures/Wallpapers/keywork` | Wallpaper folder |
| `KEYWORK_SOUND_DIR` | `~/Music/keywork` | Audio clip folder |
| `KEYWORK_SECONDS` | `60` | How long the takeover lasts |
| `KEYWORK_VOLUME` | `0.8` | Clip volume, `0.0` to `1.0` |

To change the time, edit `OnCalendar` in `~/.config/systemd/user/keywork.timer`, then run `systemctl --user daemon-reload`. But why would you.

## Timer details

- `AccuracySec=1s` fires right at 21:13:00 instead of up to a minute late.
- `Persistent=false` skips a missed 21:13 (machine off or asleep) instead of running it at the next boot.
- Times use your system time zone.

Check the next run with `systemctl --user list-timers keywork.timer`, and logs with `journalctl --user -u keywork`.

## Notes

- A clip longer than the takeover is cut off when the wallpaper restores.
- If your system audio is muted at 21:13, the clip plays silently. keywork doesn't override your mute.
- If AlbumShift's rotation came due during the paused minute, it rotates right after resuming.

## Uninstall

```bash
./install.sh --uninstall
```

Your image and audio folders are left in place.

## AI disclosure

This project was developed with [Claude](https://claude.ai), Anthropic's AI assistant. The script was tested with stubbed Plasma, audio, and systemd commands, including the interrupt and restore paths. Review the code before running it, as you would any script from the internet.

## Disclaimer

A fan project. Not affiliated with or endorsed by Coheed and Cambria.
