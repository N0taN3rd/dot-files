#!/usr/bin/env bash
# shellcheck disable=1090

launchCDPChrome() {
    nohup google-chrome-unstable \
        --autoplay-policy=no-user-gesture-required \
        --disable-background-networking \
        --disable-background-timer-throttling \
        --disable-backgrounding-occluded-windows \
        --disable-backing-store-limit \
        --disable-breakpad \
        --disable-client-side-phishing-detection \
        --disable-default-apps \
        --disable-domain-reliability \
        --disable-extensions \
        --disable-features=site-per-process,TranslateUI,LazyFrameLoading,LazyImageLoading,BlinkGenPropertyTrees \
        --disable-hang-monitor \
        --disable-infobars \
        --disable-ipc-flooding-protection \
        --disable-popup-blocking \
        --disable-prompt-on-repost \
        --disable-renderer-backgrounding \
        --disable-sync \
        --enable-features=NetworkService,NetworkServiceInProcess,AwaitOptimization \
        --force-color-profile=srgb \
        --metrics-recording-only \
        --mute-audio \
        --no-first-run \
        --remote-debugging-port=9222 \
        --safebrowsing-disable-auto-update \
        about:blank &>/dev/null &
}
