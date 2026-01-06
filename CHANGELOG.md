# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-06

### Added
- Initialize Melos monorepo with workspace resolution for local package linking
- Configure melos.yaml with versioning and publishing settings (conventional commits, git tags)
- Add git hooks for conventional commit validation, pre-commit checks, and pre-push tests
- Add monorepo CI/CD workflows for validation and coordinated releases
- Configure hybrid git strategy supporting both monorepo and individual package repositories
- Add 160 pub points validation script and workflow integration
- Document publishing workflow with Melos dry-run and actual publishing commands

### Packages Included
- turbo_response - Type-safe Success/Fail result wrapper
- turbo_notifiers - Enhanced ValueNotifier for reactive state
- turbo_mvvm - MVVM pattern with BaseViewModel and lifecycle management
- turbo_firestore_api - Type-safe Firestore wrapper with collection/document services
- turbo_forms - Form configuration and validation system
- turbo_routing - Type-safe routing abstraction over go_router
- turbo_widgets - Reusable UI components, extensions, and animations
- turbo_responsiveness - Responsive design utilities and adaptive widgets
- turbolytics - Unified logging, analytics, and crash reporting
