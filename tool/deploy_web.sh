#!/usr/bin/env zsh

flutter build web
rm -rf firebase/public/auth_action
mv build/web firebase/public/auth_action
cd firebase
firebase deploy --only hosting:auth-action
