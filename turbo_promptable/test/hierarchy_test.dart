import 'package:test/test.dart';
import 'package:turbo_promptable/turbo_promptable.dart';

void main() {
  group('Hierarchy DTOs', () {
    test('TeamDto compiles and exports correctly', () {
      final team = TeamDto(
        metaData: MetaDataDto(name: 'Test Team', description: 'A test team'),
      );

      expect(team.metaData?.name, 'Test Team');
      expect(team.metaData?.description, 'A test team');
      expect(team.shouldExport, true);
      expect(team.areas, isNull);
    });

    test('AreaDto compiles and exports correctly', () {
      final area = AreaDto(
        metaData: MetaDataDto(name: 'Test Area', description: 'A test area'),
      );

      expect(area.metaData?.name, 'Test Area');
      expect(area.metaData?.description, 'A test area');
      expect(area.roles, isNull);
    });

    test('RoleDto compiles and exports correctly', () {
      final role = RoleDto(
        metaData: MetaDataDto(name: 'Test Role', description: 'A test role'),
        expertise: ExpertiseDto(
          metaData: MetaDataDto(
              name: 'Engineering Expertise',
              description: 'Engineering expertise description'),
          field: 'Engineering',
          specialization: 'Backend',
          experience: '5 years',
        ),
      );

      expect(role.metaData?.name, 'Test Role');
      expect(role.metaData?.description, 'A test role');
      expect(role.expertise, isNotNull);
    });

    test('Hierarchy nesting works (Team → Area → Role)', () {
      final role = RoleDto(
        metaData: MetaDataDto(
            name: 'Developer', description: 'Software developer role'),
        expertise: ExpertiseDto(
          metaData: MetaDataDto(
              name: 'Engineering Expertise',
              description: 'Engineering expertise description'),
          field: 'Engineering',
          specialization: 'Backend',
          experience: '5 years',
        ),
      );

      final area = AreaDto(
        metaData:
            MetaDataDto(name: 'Engineering', description: 'Engineering area'),
        roles: [role],
      );

      final team = TeamDto(
        metaData:
            MetaDataDto(name: 'Product Team', description: 'Main product team'),
        areas: [area],
      );

      expect(team.areas, isNotNull);
      expect(team.areas!.length, 1);
      expect(team.areas!.first, isA<AreaDto>());

      final areaFromTeam = team.areas!.first;
      expect(areaFromTeam.metaData?.name, 'Engineering');
      expect(areaFromTeam.roles, isNotNull);
      expect(areaFromTeam.roles!.length, 1);
      expect(areaFromTeam.roles!.first, isA<RoleDto>());

      final roleFromArea = areaFromTeam.roles!.first;
      expect(roleFromArea.metaData?.name, 'Developer');
    });

    test('Hierarchy structure works correctly', () {
      final role = RoleDto(
        metaData: MetaDataDto(
            name: 'Developer', description: 'Software developer role'),
        expertise: ExpertiseDto(
          metaData: MetaDataDto(
              name: 'Engineering Expertise',
              description: 'Engineering expertise description'),
          field: 'Engineering',
          specialization: 'Backend',
          experience: '5 years',
        ),
      );

      final area = AreaDto(
        metaData:
            MetaDataDto(name: 'Engineering', description: 'Engineering area'),
        roles: [role],
      );

      final team = TeamDto(
        metaData:
            MetaDataDto(name: 'Product Team', description: 'Main product team'),
        areas: [area],
      );

      // Test hierarchy structure
      expect(team.areas, isNotNull);
      expect(team.areas!.first.roles, isNotNull);
      expect(team.areas!.first.roles!.first.expertise, isNotNull);
    });

    test('Frontmatter generation works', () {
      final team = TeamDto(
        metaData:
            MetaDataDto(name: 'Product Team', description: 'Main product team'),
      );

      // Use toYaml() for YAML frontmatter format
      final frontmatter = team.toYaml();
      expect(frontmatter, isNotNull);
      expect(frontmatter, contains('name: Product Team'));
      expect(frontmatter, contains('description: Main product team'));
    });
  });
}
