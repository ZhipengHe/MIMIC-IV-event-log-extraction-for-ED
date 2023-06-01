# Changelog

This repo is released as a part of [MIMICEL: MIMIC-IV Event Log for Emergency Department](https://physionet.org/content/mimicel-ed/) on PhysioNet. All notable changes to this project will be documented in this file. 


## [2.1.0] - 2023-06-01

### Changed

- Removed 59 cases with zero or negative ED length of stay, meaning the event `Enter the ED` occurred at the same time or after the event `Discharge from the ED` in the same ED stay.  This cleaning operation is implemented in a new SQL script named `4_clean.sql`. 

### Fixed

- Fixed a bug when integrating the diagnosis table with the activity `Discharge from the ED`. `LEFT JOIN` is utilised (instead of `INNER JOIN`) to include 1098 cases. This fix is implemented in `2_activity.sql`.
- Fixed a bug to remove events occurred at the same time or after the event `Discharge from the ED` in a single ED stay, due to the fact that discharge should represent the unique end of an ED stay (refer to Step 5 in the Methods section). This fix is implemented in `2_activity.sql`

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


[unreleased]: https://github.com/ZhipengHe/MIMIC-IV-event-log-extraction-for-ED/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/ZhipengHe/MIMIC-IV-event-log-extraction-for-ED/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/ZhipengHe/MIMIC-IV-event-log-extraction-for-ED/compare/v1.1.0...v2.0.0
[1.1.0]: https://github.com/ZhipengHe/MIMIC-IV-event-log-extraction-for-ED/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/ZhipengHe/MIMIC-IV-event-log-extraction-for-ED/commits/v1.0.0