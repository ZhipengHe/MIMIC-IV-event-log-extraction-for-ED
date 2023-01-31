# Changelog

This repo is released as a part of [MIMICEL: MIMIC-IV Event Log for Emergency Department](https://physionet.org/content/mimicel-ed/1.0.0/) on PhysioNet. All notable changes to this project will be documented in this file. 

## [2.0.0] - 2023-01-31

### Added

- Add new attributes (`gender`,`race`, `arrival_transport`, `disposition`) from MIMIC-IV-ED 2.0

### Changed
- Change database schema `mimic_ed` to `mimiciv_ed` (follow changes in [mimic-code](https://github.com/MIT-LCP/mimic-code/commit/d374eb512755d5928abe13a9d88de9a3a25c0366))
- Remove diagnosis code from discharge activity name  

## [1.1.0] - 2022-11-28

### Added

- Add description of standard name labels for xes in `README`
- Add `CHANGELOG.md` to record the changes

### Fixed

- Fix bugs when converting csv to xes

## [1.0.0] - 2022-07-06

### Added

- Add sql scripts for extracting event logs into csv
- Add python code and jupyter notebook for converting csv into xes formart
- Add `README.md` and `LICENSE`


[2.0.0]: https://github.com/ZhipengHe/MIMIC-IV-event-log-extraction-for-ED/compare/v1.1.0...v2.0.0
[1.1.0]: https://github.com/ZhipengHe/MIMIC-IV-event-log-extraction-for-ED/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/ZhipengHe/MIMIC-IV-event-log-extraction-for-ED/commits/v1.0.0