# Toshy

Toshy installs itself into `~/.config/toshy` and owns `toshy_config.py`
there. The file is large and Toshy rewrites it on upgrade, so it is not
tracked here. Toshy keeps only the parts between `SLICE_MARK_START` and
`SLICE_MARK_END` comments across upgrades.

`user_apps.py` holds the contents of the `user_apps` slice, including its
start and end marker lines. It is the only slice that differs from the
upstream default. It contains terminal tab and workspace shortcuts, the
launcher key, and input source switching.

## Restore on a new machine

1. Install Toshy: https://github.com/RedBearAK/toshy
2. Open `~/.config/toshy/toshy_config.py` and find the `user_apps` slice.
3. Replace everything from its `SLICE_MARK_START` line to its
   `SLICE_MARK_END` line with the contents of `user_apps.py`.
4. Restart the config service:

```
toshy-services-restart
```

## Check for drift

```
diff <(sed -n '/SLICE_MARK_START: user_apps/,/SLICE_MARK_END: user_apps/p' ~/.config/toshy/toshy_config.py) ~/dotfiles/.config/toshy/user_apps.py
```
