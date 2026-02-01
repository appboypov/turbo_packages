import 'package:turbo_serializable/abstracts/t_writeable.dart';
import 'package:turbo_serializable/markdown/typedefs/t_markdown_typedefs.dart';

class TMdFactory<T extends TWriteable> {
  final T writeable;

  final TMdFrontmatterBuilder? mdFrontmatterBuilder;
  final TMdSectionsBuilder? mdSectionsBuilder;
  final TMdBodyBuilder? mdBodyBuilder;
  final TMdFileBuilder? mdBuilder;

  TMdFactory({
    required this.writeable,
    this.mdFrontmatterBuilder,
    this.mdSectionsBuilder,
    this.mdBodyBuilder,
    this.mdBuilder,
  });

  TMdFrontmatter buildFrontmatter({
    TMdFrontmatterBuilder? mdFrontmatterBuilder,
  }) =>
      (mdFrontmatterBuilder ?? this.mdFrontmatterBuilder)?.call(writeable) ??
      {};

  List<TMdSection> buildSections({
    TMdSectionsBuilder? mdSectionsBuilder,
  }) =>
      (mdSectionsBuilder ?? this.mdSectionsBuilder)?.call(
        writeable,
        buildFrontmatter(),
      ) ??
      [];

  TMdBody buildBody({
    TMdBodyBuilder? mdBodyBuilder,
  }) =>
      (mdBodyBuilder ?? this.mdBodyBuilder)?.call(
        writeable,
        buildFrontmatter(),
        buildSections(),
      ) ??
      '';

  TMdFile build({
    TMdFileBuilder? mdBuilder,
  }) =>
      (mdBuilder ?? this.mdBuilder)?.call(
        writeable,
        buildFrontmatter(),
        buildSections(),
        buildBody(),
      ) ??
      '';
}
