# Release History

## Version 0.7.0 (04-03-2025)
Support new TypeSpec compiler.

## Version 0.6.0 (03-20-2025)
Support new TypeSpec compiler.
**BREAKING CHANGE**: Removed support for `--version` parameter. Multi-versioned specs will be emitter as-is.

## Version 0.5.1 (02-27-2025)
Support new TypeSpec syntax.

## Version 0.5.0 (01-08-2025)
Support new internal APIView tree-structure.

## Version 0.4.9 (07-09-2024)
Fix issue where "unknown" was rendered as "any".
Support value syntax for objects and arrays.
Support const statements in namespaces.

## Version 0.4.8 (04-18-2024)
Display suppressions in APIView.
Resolve visual anomalies.

## Version 0.4.7 (03-22-2024)
Support TypeSpec string templates.
Fix display issue with templated aliases.
Ensure alias statements end with semicolon.

## Version 0.4.6 (03-08-2024)
Support CrossLanguagePackageId.

## Version 0.4.5 (01-29-2024)
Support named template arguments.
Support unnamed unions.
Support cross-language definition IDs.

## Version 0.4.4 (04-18-2023)
Support future beta releases of TypeSpec.

## Version 0.4.3 (04-17-2023)
Support latest release of TypeSpec.

## Version 0.4.2 (03-16-2023)
Support latest release of TypeSpec.

## Version 0.4.1 (03-13-2023)
Fixed issue where enums with spread members would cause the generator to crash.

## Version 0.4.0 (03-06-2023)
Update for rename of Cadl to TypeSpec.

## Version 0.3.5 (02-10-2023)
Support latest release of Cadl compiler.
**BREAKING CHANGE**: Removed the `--namespace` emitter option.
Added the `--service` emitter option to support filtering output for multi-service specs.
Emitter options `--output-file` and `--version` cannot be used with multi-service specs unless the
  `--service` option is provided.
Added the `--include-global-namespace` option to permit including the global namespace in the token file.
Fixed issue where namespaces that are not proper subnamespaces may be included in the token file.

## Version 0.3.4 (01-13-2023)
Support latest release of Cadl compiler.

## Version 0.3.3 (01-03-2023)
Fixed issue where some type references were not navigable.

## Version 0.3.2 (12-20-2022)
Changed structure of APIView navigation so that aliases appear under a separate "Alias" section, instead of
  within the existing "Models" section. Will likely result in a non-API-related diff with prior APIView versions.

## Version 0.3.1 (12-9-2022)
Support Cadl scalars.

## Version 0.3.0 (11-15-2022)
Add support for aliases and augment decorators.

## Version 0.2.1 (10-27-2022)
Change behavior of `version` emitter option so that if it is not supplied, APIView will be generated for the
  un-projected Cadl, rendering all versioning decorators. Supplying `version` allows the user to project a
  specific version.

## Version 0.2.0 (10-26-2022)
Support `namespace` emitter option to filter the appropriate namespace when it cannot be automatically resolved.
  This is primarily intended for creating APIViews for libraries.
Support `version` emitter option to choose which version of a multi-versioned spec to emit. Specs with a single
  version can omit this. Multi-version specs can omit this if emitting the latest version.
No longer suppress `@doc`, `@summary`, and `@example` decorators. These can be toggled using the APIView UI.
Support rendering multi-line strings.
Change default path for generating artifacts.

## Version 0.1.1 (10-13-2022)
Support compiler-level noEmit option.
Support `output-dir` emitter option.

## Version 0.1.0 (10-5-2022)
Initial release.