#!/bin/bash

read -p "Iltimos, git URL'ni kiriting: " REPO_URL

if [ -z "$REPO_URL" ]; then
  echo "Git URL kiritilmadi. Scriptni qayta ishga tushiring va URL kiriting."
  exit 1
fi

if ! [[ "$REPO_URL" =~ ^https:\/\/.*\.git$ ]]; then
  echo "Yaroqli git URL kiriting. Misol: https://github.com/user/repository.git"
  exit 1
fi

PROJECT_NAME=$(basename -s .git "$REPO_URL")

echo "Cloning repository from $REPO_URL"
git clone "$REPO_URL"

cd "$PROJECT_NAME" || { echo "Folderga kira olmadim"; exit 1; }

echo "Installing npm dependencies"
npm install

echo "Building the project"
npm run build

echo "Starting the project"
npm start

echo "Starting the project with PM2"
pm2 start npm --name "$PROJECT_NAME" -- start

pm2 save

pm2 startup

echo "Deployment finished!"
