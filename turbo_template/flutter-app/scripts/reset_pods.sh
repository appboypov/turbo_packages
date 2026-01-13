#!/bin/bash

set -e

cd ..

echo "🧹 Cleaning Flutter build..."
flutter clean

echo "📦 Getting Flutter dependencies..."
flutter pub get

echo "📱 Navigating to iOS directory..."
cd ios || exit

echo "🗑️  Removing Podfile.lock..."
rm -rf Podfile.lock

echo "🔄 Updating pod repository..."
pod repo update

echo "📥 Installing pods..."
pod install

echo "✅ Pods reset complete!"

